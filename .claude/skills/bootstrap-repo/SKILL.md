---
name: bootstrap-repo
description: Full first-time setup for a repo cloned from the domain×type github-template scaffold — fills in docs and GitHub workflows via init-github-template, then applies the terraform/ config to the real GitHub repository (branch protection, merge settings, collaborators, production/staging environments). Use when the user wants to bootstrap, set up, or fully configure a freshly cloned github-template repo, or explicitly asks to "run the terraform" as part of initial setup.
---

# Bootstrap repo

Orchestrates the two halves of first-time repo setup: content (docs +
workflows, via `init-github-template`) and infrastructure (GitHub repo
settings, via `terraform/`). Runs them in that order — the docs interview
finalizes CI job names before terraform asserts required status checks
against them, and it's the source of truth for anything else terraform might
need to know about the project.

This skill assumes the target repo already has a `bin/mat` CLI and a
`terraform/` directory (i.e. it's a clone of github-template made after that
tooling was added). If either is missing, stop after the docs/workflows
phase and tell the user this repo predates it — there's nothing to apply.

## 1. Docs & workflows

Invoke the `init-github-template` skill (via the Skill tool) and let it run
its own Explore → Interview → Write → Verify phases in full — don't
re-implement or shortcut any of that here.

## 2. Dev shell — `devenv.nix`

Add the language/tooling packages the project actually needs to
`devenv.nix`'s `packages` list, based on the stack `init-github-template`
just detected (and wrote into `ci.yml`) — e.g. `pkgs.rustc`, `pkgs.cargo`,
`pkgs.rustfmt`, `pkgs.clippy` for Rust; `pkgs.nodejs` for Node; `pkgs.go` for
Go. Keep the existing baseline tooling (`git`, `gh`, `terraform`, `jq`,
`shellcheck`, `shfmt`) — only add to it, don't remove or reorganize what's
there. Update the `enterShell` banner's tool list to match. Then confirm the
shell actually builds (`devenv shell -- true` or equivalent) before moving
on — a broken `devenv.nix` blocks everyone who clones the repo next.

## 3. Terraform — via `mat repo`

`bin/mat repo` owns the actual terraform mechanics (owner/repo detection
from `git remote`, writing `terraform/terraform.tfvars`, `init`, importing
the repo into state if it isn't already there). Drive it in two
non-interactive steps rather than running `mat repo` bare — its bare/guided
mode has its own interactive confirm prompt, which will hang waiting for
stdin when run from a tool call instead of a real terminal:

1. `./bin/mat repo plan` — runs init/import, then shows the plan. Show the
   **full** output to the user, don't summarize or truncate it.
2. `AskUserQuestion`: apply these changes now? Always ask, every run, even
   if a previous run in this same conversation was already approved — this
   changes live branch protection and push restrictions on a shared system.
3. If yes: `./bin/mat repo apply`. If no: stop here and tell the user the
   plan is ready to apply later with `./bin/mat repo apply` (or bare
   `mat repo` from their own terminal, which will prompt them directly).

## 4. Summary

Report what changed in docs/workflows (from `init-github-template`), what
was added to `devenv.nix`, and what terraform did — or didn't, if the user
declined the apply. Don't re-run or re-summarize `init-github-template`'s
own verification output; just point at it.
