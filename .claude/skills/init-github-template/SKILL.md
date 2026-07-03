---
name: init-github-template
description: Turn a freshly cloned copy of the domain×type github-template scaffold (README, CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, LICENSE, the docs/ grid, and .github/ CI+issue+dependabot config) into real, project-specific documentation. Use when the user wants to initialize/fill in a new repo cloned from that template, mentions filling in docs/*.md, todo_-prefixed doc files, or setting up CI/dependabot/issue templates for a freshly scaffolded repo.
---

# Init github-template

Fills in a template repo's documentation and GitHub config for the real project it now hosts. Four phases — don't skip the interview by guessing; wrong defaults propagate into a dozen cross-linked files.

## 1. Explore

Read before asking anything:

- Root: `README.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `LICENSE`, `CHANGELOG.md`, `.env.example`
- `docs/README.md` (the domain×type grid) and every file it links to
- `.github/` (workflows, ISSUE_TEMPLATE, dependabot.yml, CODEOWNERS, SUPPORT.md, PULL_REQUEST_TEMPLATE.md) and `.githooks/`
- Detect the stack from what's actually in the repo (`Cargo.toml`, `package.json`, `go.mod`, `pyproject.toml`/`requirements.txt`, `pom.xml`/`build.gradle`, `Gemfile`, `composer.json`) — never ask what language a question can answer by looking.
- `git remote -v` for the repo's GitHub path, if already set.

See [REFERENCE.md](REFERENCE.md) for the full file manifest (what's fixed-path template scaffolding, what's `todo_`-prefixed and needs a real-content rename, what's optional to delete).

## 2. Interview

One or two `AskUserQuestion` calls at a time, each option led by a recommended default with its reasoning — this is a grill-me-style interview, not a form dump. Walk the branches in dependency order: team size gates almost everything downstream (organizational docs scope, PR review process, Discussions, Code of Conduct). Don't ask something the Explore step already answered.

Full question bank with recommended defaults and why each branch matters: [REFERENCE.md](REFERENCE.md#interview-question-bank).

Before writing anything, summarize the consolidated decisions back to the user and get a go-ahead — this touches a lot of interlinked files and is expensive to redo.

## 3. Write

- Fill root `.md` files with real content matching the decisions.
- Rename `todo_`-prefixed docs once filled (drop `todo_`; decision records also get a sequence number scoped to their domain's `decisions/` folder: `0001-slug.md`, `0002-slug.md`, ...). Delete docs that don't apply given the interview answers (e.g. a role-charter for a solo project) and update `docs/README.md`'s grid to match — no dangling links, no stale 🚧 markers on files that now have real content.
- Fix every cross-reference so nothing points at a deleted file or a disabled feature (e.g. GitHub Discussions links, if Discussions was declined).
- Fill in `.github/`: `SUPPORT.md`, `ISSUE_TEMPLATE/config.yml` and templates, `workflows/ci.yml` (real setup-language action + install/lint/test/build commands for the detected stack), `dependabot.yml` (uncomment the matching ecosystem, drop the irrelevant commented ones), and wire `.githooks/pre-push` to run the fast subset of the validation suite (formatting/lint — leave slow or DB-dependent steps to CI).
- Stay in scope: this is documentation and GitHub config, not application code. Don't invent a `Dockerfile`, add framework dependencies to a manifest, or scaffold infra-as-code unless the user asks for that separately — note them as explicit follow-ups instead.

## 4. Verify

- Actually run the commands you just wrote into CI / the code-style doc, locally, against the current code — don't just assert they'd pass. Fix real issues you find (e.g. a formatter violation) rather than documenting around them.
- Grep for leftover placeholders: `your-org`, `your-repo`, `your-username`, `[YEAR]`, `[SECURITY_EMAIL]`, `todo_`, `owner: <!--`, and any stale references to a feature you just turned off (e.g. `discussions` if declined).
- Summarize what's filled in vs. what's an intentional follow-up (app code, Dockerfile, infra-as-code).
