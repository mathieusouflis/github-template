---
domain: team-process
type: reference
owner: <!-- team/role that owns this convention -->
last_reviewed:
---

# Commit Conventions

We follow **Conventional Commits**, enforced automatically — see [operations/concept/ci-cd-pipeline](../../operations/concept/ci-cd-pipeline.md) for how. Each commit message should be:

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

**Types:**

| Type       | When to use                           |
|------------|----------------------------------------|
| `feat`     | New feature or behavior               |
| `fix`      | Bug fix                               |
| `refactor` | Code change with no behavior change   |
| `test`     | Adding or updating tests              |
| `docs`     | Documentation only                    |
| `chore`    | Tooling, dependencies, config         |
| `perf`     | Performance improvement               |
| `ci`       | CI/CD changes                         |

**Scope** (optional): the module or area affected, e.g. `auth`, `api`, `ui`, `docker`.

**Examples:**
```
feat(auth): add refresh token revocation on logout
fix(api): return 409 when resource already exists
refactor(core): extract validation to separate utility
test(auth): add unit tests for login use case
docs(setup): add environment variable reference
chore(deps): upgrade dependencies
```

**Rules:**
- Use the **imperative mood** ("add" not "adds" or "added")
- Keep the first line under **72 characters**
- Reference issues in the footer: `Closes #42`, `Fixes #17`

## See also

- [team-process/how-to/activate-git-hooks](../how-to/activate-git-hooks.md)
- [operations/concept/ci-cd-pipeline](../../operations/concept/ci-cd-pipeline.md)
