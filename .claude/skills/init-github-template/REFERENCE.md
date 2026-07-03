# Reference

## File manifest

**Root (always exists, always needs real content):**

- `README.md` — badges (fix repo path), one-paragraph description, overview, getting-started pointer, architecture summary + link, docs pointer, contributing pointer, license
- `CONTRIBUTING.md` — clone/upstream URLs, PR process, points at `docs/team-process` and `docs/product-code/tutorials/getting-started`
- `CODE_OF_CONDUCT.md` — Contributor Covenant boilerplate; enforcement contact needs a real name/email or reframing
- `SECURITY.md` — needs a real contact email (`[SECURITY_EMAIL]` placeholder)
- `LICENSE` — needs `[YEAR]` and `[YOUR NAME OR ORGANIZATION]` filled in
- `CHANGELOG.md` — usually fine as-is (Keep a Changelog scaffold, no placeholders to fill until the first release)
- `.env.example` — not a doc, but `docs/product-code/reference/environment-variables.md` must stay in sync with it

**`docs/README.md`** — the domain×type grid (product-code / operations / team-process / organizational × concept / how-to / reference / decisions / tutorials / runbooks). This is the index; update it every time a file underneath is renamed, filled, or deleted. 🚧 marks a `todo_` placeholder; ⧉ marks a file that canonically lives outside `docs/` at a GitHub-required path.

**`docs/product-code/`** (the code itself):
- `concept/todo_architecture-overview.md` → rename once real: what the components are, the core data flow, the constraints that shaped the design
- `decisions/todo_first-architecture-decision.md` → becomes `decisions/0001-<slug>.md`, `0002-<slug>.md`, ... one file per atomic decision (don't cram multiple choices into one ADR — e.g. "why this architecture" and "why this framework/DB" are separate decisions)
- `tutorials/getting-started.md` — prerequisites table, setup steps, common commands, troubleshooting — all stack-specific
- `reference/code-style.md` — tooling commands, naming conventions, formatting, error handling, testing conventions — all stack-specific
- `reference/environment-variables.md` — table generated from `.env.example`, kept in sync

**`docs/operations/`** (running it):
- `concept/ci-cd-pipeline.md` — usually already accurate structurally; update once `ci.yml`/`dependabot.yml` stop being placeholders
- `runbooks/todo_deployment-runbook.md` → rename once a deployment target is known, even provisionally (mark `status: provisional` / leave `last_exercised` empty until it's actually been run)

**`docs/team-process/how-to/activate-git-hooks.md`** — usually needs only the `owner:` frontmatter field filled in; content is already generic and accurate.

**`docs/organizational/`** (solo vs team pivots this domain hard — see interview branch below):
- `concept/todo_role-charter.md` — meaningless for a solo maintainer; delete
- `decisions/todo_tooling-choice.md` — for a solo project, fold tooling rationale into the product-code ADRs instead of a separate org-level decision; delete
- `reference/todo_tool-inventory.md` → rename to `tool-inventory.md`, trimmed to a plain lookup table (tool / used-for / alternatives), no team "Owner" column for a solo project

**`.github/`:**
- `workflows/ci.yml` — replace every `echo "Replace this step with..."` with the real setup-language action + install/lint/test/build commands
- `workflows/commitlint.yml`, `workflows/release.yml` — already language-agnostic, rarely need changes
- `dependabot.yml` — uncomment the `package-ecosystem` matching the stack, drop the other commented-out blocks, keep `github-actions` and `docker` active
- `ISSUE_TEMPLATE/bug_report.yml` — the "Environment" field's placeholder examples (Node/Python/Go) should become stack-specific
- `ISSUE_TEMPLATE/feature_request.yml` — usually fine as-is, no language-specific content
- `ISSUE_TEMPLATE/config.yml`, `SUPPORT.md` — both point at GitHub Discussions by default; rewrite to point at Issues if Discussions is declined (see interview)
- `CODEOWNERS`, `FUNDING.yml` — leave commented/untouched unless the user asks; not part of doc-consistency scope
- `.githooks/pre-push` — wire the commented-out test/build checks to the fast subset of the validation suite

## Interview question bank

Ask in this order — later branches depend on earlier answers. Use `AskUserQuestion`, 1–2 questions per round, recommended option first with its reasoning in the description.

1. **Team size** — solo vs. small team with contributors expected. Gates: `organizational/` domain scope, CODEOWNERS, PR-review-required language in CONTRIBUTING, whether Discussions is worth enabling, whether Code of Conduct needs trimming.
2. **Project purpose** — what the thing actually does, concretely (not "a web app" — what does it serve, to whom). Drives README overview and the architecture doc's framing.
3. **Stack specifics not already derivable** — e.g. web framework choice if the manifest has no framework dependency yet, database choice if `DATABASE_URL`-shaped env vars exist but no driver is chosen. Skip anything the Explore step already answered.
4. **Architecture rationale** — if the repo already has an opinionated structure (layered, hexagonal, monorepo packages), ask *why*, for the first ADR. Common answers: deliberate practice/learning, anticipated growth, team-size fit.
5. **Repo location** — GitHub org/user + repo name, for badges and clone URLs. Check `git remote -v` first; only ask if unset.
6. **Deployment target** — fine to answer "not decided yet" and leave the runbook as an unfilled placeholder rather than inventing one.
7. **License holder** — name (person or org) and year for `LICENSE`.
8. **Security contact** — email for `SECURITY.md`.
9. **GitHub Discussions** — enable, or point everything at Issues instead. Cascades into `CONTRIBUTING.md`, `SUPPORT.md`, `ISSUE_TEMPLATE/config.yml`, and any doc with a "questions?" pointer.
10. **Organizational docs scope** (if solo) — drop role-charter and tooling-choice entirely and trim tool-inventory (recommended), keep everything with solo framing, or delete the whole domain.
11. **PR review process** (if solo) — rewrite CONTRIBUTING's "one approving review" requirement to "CI green is the merge gate," or keep review-required language for anticipated future contributors.
12. **Code of Conduct necessity** — keep (lightly trimmed to point at the maintainer directly) vs. remove entirely for a personal project nobody else will realistically file a conduct complaint against.
13. **Local dev environment** — how a contributor gets required local services running (e.g. a database) — Docker Compose is the usual default; only skip prescribing a method if genuinely undecided.
14. **Deployment/infra tooling** (if a deployment target was named) — e.g. IaC choice (Terraform, Pulumi, Ansible, hand-configured). Don't assume — a user may want infra-as-code for the *real* deployment target while still wanting something lighter (Compose) for local dev; these are separate decisions, not one.

## Verification checklist

- Run every command that now appears in `code-style.md`'s "Running the Full Validation Suite" section and in `ci.yml`, locally, in order. Fix what fails — a formatter violation, a lint warning — don't just note it as a known issue.
- `grep -ril "your-org\|your-repo\|your-username\|\[YEAR\]\|\[SECURITY_EMAIL\]" .` across root, `docs/`, `.github/`
- `find docs -name 'todo_*.md'` — should be empty, or only contain files deliberately left as placeholders (e.g. deployment runbook with no infra yet — that one stays even when "filled," just marked provisional)
- `grep -ril "discussions"` — every hit should be intentional given the Discussions decision, not a leftover default
- Confirm `docs/README.md`'s grid has no link to a file that was deleted or renamed
