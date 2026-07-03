# Repository configuration (Terraform)

Manages this repository's GitHub settings as code: merge/auto-merge behavior,
delete-branch-on-merge, secret scanning, branch protection on `main`, the
`production`/`staging` deployment environments, and the collaborator list. Uses the
[`integrations/github`](https://registry.terraform.io/providers/integrations/github/latest/docs)
provider.

## Layout

```
terraform/
├── main.tf                  # root — provider config, calls the module below
├── variables.tf             # root — repository_owner/name, passed into the module
├── github-repository/       # reusable module: all github_* resources live here
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── setup.sh
└── README.md
```

The root config is what's actually applied to this repository; the
`github-repository` module is written generically (no hardcoded repo name)
so it can be pointed at a different repository by passing different
variables, without touching the module itself.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [GitHub CLI](https://cli.github.com/) (`gh`), logged in (`gh auth login`) —
  or a personal access token with `Administration: write`, `Contents: read`,
  and `Environments: write` on this repository if you'd rather not use `gh`

## Running

Easiest path — `mat repo` (from `bin/mat`) detects the owner/repo from
`git remote`, writes `terraform/terraform.tfvars`, runs `init`, imports the
repo into state if it isn't already there, shows the plan, and asks before
applying:

```bash
mat repo
```

Or drive the underlying pieces yourself. `terraform/setup.sh` is the thin
wrapper that sources a token from `gh` if you're logged in, or prompts for
one otherwise:

```bash
./terraform/setup.sh init
./terraform/setup.sh plan
./terraform/setup.sh apply
```

## One-time import

This repository already exists on GitHub — running `apply` without importing
it first would try to *create* it and fail. `mat repo` handles this
automatically; doing it manually is a one-time step before the first
`plan`/`apply`:

```bash
./terraform/setup.sh import module.github_repository.github_repository.this github-template
```

Nothing else needs importing: `main` currently has no branch protection
rule, there are no manually-added collaborators, and neither the
`production` nor `staging` environment exists yet — all these start as
clean creates that match the empty/absent live state.

## What's intentionally not managed here

- **Visibility, template flag, description, topics, has_issues/has_wiki/...**
  — left alone via `ignore_changes` on `github_repository`. These aren't part
  of "configure and secure the repository" and the provider's schema
  defaults would otherwise silently overwrite them on the first apply.
- **CodeQL / code scanning default setup** — no resource for this exists in
  the `integrations/github` provider. Enable it once, manually: Settings →
  Code security → Code scanning → "Set up" → **Default**.

## State

`terraform.tfstate` is local and gitignored — this is a solo-maintained,
manually-run config, not something driven from CI.
