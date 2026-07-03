---
domain: operations
type: concept
owner: <!-- team/role that owns repository configuration -->
last_reviewed:
---

# Repository Configuration

How this repository's GitHub settings are configured and secured, as actually managed under `terraform/` today.

## What's managed — `terraform/`

Using the [`integrations/github`](https://registry.terraform.io/providers/integrations/github/latest/docs) provider, applied manually (not from CI — see [terraform/README.md](../../../terraform/README.md)). The resources live in a reusable module, `terraform/github-repository/`, instantiated by the root config (`terraform/main.tf`) for this repository specifically:

| Resource | Manages |
|---|---|
| `module.github_repository.github_repository.this` | Merge methods (squash + rebase only, no merge commits), auto-merge disabled, delete-branch-on-merge, secret scanning + push protection |
| `module.github_repository.github_repository_ruleset.main` | Ruleset (not classic branch protection) targeting `~DEFAULT_BRANCH`: require a pull request and passing CI (`lint`, `test`, `build`) before merging; block force-pushes/deletion except for the admin repository role |
| `module.github_repository.github_repository_environment.production`, `...staging` | The two fixed deployment environments every repo this module manages gets |
| `module.github_repository.github_repository_collaborators.this` | The full, authoritative collaborator list (empty by default) |

Solo-maintainer defaults were chosen deliberately: the default branch requires a pull request but no minimum approval count, since GitHub can't let a lone maintainer approve their own PR, and the admin repository role can always bypass the ruleset so an emergency merge/force-push stays possible.

## What's not managed here

- **Visibility, the "template repository" flag, description, topics, `has_issues`/`has_wiki`/...** — deliberately left alone (`ignore_changes` in `github-repository/main.tf`), since they're not part of "secure the repository" and touching them risks unrelated drift.
- **CodeQL / code scanning default setup** — no Terraform resource exists for this in the provider. Enabled once, manually, via Settings → Code security → Code scanning → "Set up" → Default.

## See also

- [terraform/README.md](../../../terraform/README.md) — prerequisites, how to run, one-time import steps
- [CI/CD pipeline](ci-cd-pipeline.md) — the `lint`/`test`/`build` checks required by the ruleset
