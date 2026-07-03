---
domain: operations
type: concept
owner: <!-- team/role that owns CI/CD -->
last_reviewed:
---

# CI/CD Pipeline

How this repository validates and ships changes, as actually configured under `.github/workflows/` and `.githooks/` today.

## Continuous Integration — `.github/workflows/ci.yml`

Runs on every push to `main` and every pull request targeting `main`. Three jobs, each on a fresh runner:

| Job | Purpose |
|---|---|
| `lint` | Runtime setup, dependency install, lint/type-check |
| `test` | Runtime setup, dependency install, test suite |
| `build` | Runs after `lint` and `test` pass; runtime setup, dependency install, build |

**This workflow ships as a placeholder** — every step currently runs `echo "Replace this step with..."` instead of a real command. It is language-agnostic by construction: fill in the runtime-setup action (`actions/setup-node`, `actions/setup-python`, `actions/setup-go`, etc.) and the install/lint/test/build commands for your stack, then delete the template comment block at the top of the file.

## Commit message validation — `.githooks/commit-msg` + `.github/workflows/commitlint.yml`

Commit messages are validated against Conventional Commits **twice**, both reusing the exact same shell script (`.githooks/commit-msg`) so there is one source of truth for the rule rather than two that can drift apart:

- **Locally**, if the contributor activated the hook (`git config core.hooksPath .githooks`) — fast feedback, but optional and easy to skip.
- **In CI**, on every pull request — the `commitlint.yml` workflow re-runs the same script against every commit in the PR, so a contributor who never activated the local hook is still caught before merge.

See [Commit Conventions](../../../CONTRIBUTING.md#commit-conventions) for the rule itself.

## Release — `.github/workflows/release.yml`

Triggered by pushing a tag matching `v*.*.*`. Creates a GitHub Release with auto-generated release notes from the commit history (`generate_release_notes: true`) — no manual changelog editing required, provided commits follow the Conventional Commits format enforced above.

## Dependency updates — `.github/dependabot.yml`

Two ecosystems are always active regardless of language: `github-actions` (workflow action versions) and `docker`, both checked monthly. Language-specific ecosystems (`npm`, `pip`, `gomod`, `cargo`, `maven`, `gradle`, `composer`, `bundler`) are present but commented out — uncomment the one matching this project's stack.

## See also

- [Commit Conventions](../../../CONTRIBUTING.md#commit-conventions)
- [team-process/how-to/activate-git-hooks](../../team-process/how-to/activate-git-hooks.md)
- [operations/runbooks](../runbooks/)
- [Repository configuration](repository-configuration.md) — the default-branch ruleset requires the `lint`/`test`/`build` checks defined here
