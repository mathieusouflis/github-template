---
domain: team-process
type: reference
owner: <!-- team/role that owns this process -->
last_reviewed:
---

# Pull Request Process

## Reporting bugs

Before opening an issue:
- Search [existing issues](../../../../issues) to avoid duplicates
- Make sure you are on the latest version (`git pull upstream main`)

When opening a bug report, use the **Bug Report** template and include:
- Steps to reproduce
- Expected vs actual behavior
- Your environment (OS, runtime version, relevant tool versions)
- Relevant logs or screenshots

## Suggesting features

Open a **Feature Request** issue with:
- A clear description of the problem the feature solves
- Your proposed solution
- Alternatives you considered

Features that align with the project's scope and architecture are more likely to be accepted.

## Submitting code changes

1. Create a branch from `main`:
   ```bash
   git checkout main
   git pull upstream main
   git checkout -b feat/your-feature-name
   ```
2. Make your changes following [product-code/reference/code-style](../../product-code/reference/code-style.md)
3. Write or update tests — every PR should maintain or improve existing coverage
4. Run the validation suite locally (see [product-code/tutorials/getting-started](../../product-code/tutorials/getting-started.md))
5. Commit following [team-process/reference/commit-conventions](commit-conventions.md)
6. Push and open a Pull Request

## Review and merge

- **One PR per concern** — don't mix unrelated changes
- **Fill the PR template** — describe what changed and why
- **Keep diffs small** — large PRs are hard to review; split if needed. Aim for something reviewable in under 30 minutes
- **All CI checks must pass** before merging
- **Address review comments** — don't force-merge, iterate on feedback
- **Squash or rebase** before merge if history is messy

PRs are merged by maintainers once they have one approving review and all checks are green — see [organizational/reference](../../organizational/reference/) for who that is on this project.

## See also

- [product-code/reference/code-style](../../product-code/reference/code-style.md)
- [team-process/reference/commit-conventions](commit-conventions.md)
