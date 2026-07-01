# FAQ

Frequently asked questions about developing in this project.

---

## General

**Q: Where do I start?**
See [Getting Started](../getting-started/README.md) for the full setup guide.

**Q: I found a bug. How do I report it?**
Open a [Bug Report issue](../../../issues/new/choose) using the provided template.

**Q: I want to add a feature. Where do I begin?**
Open a [Feature Request issue](../../../issues/new/choose) first to discuss the idea before writing code.

---

## Development

**Q: Tests are failing locally but passing in CI (or vice versa).**
- Make sure your `.env` matches the values expected by the test suite
- Reinstall dependencies from the lockfile to rule out a local drift
  <!-- e.g. npm ci / pip install -r requirements.txt --no-deps / go mod tidy -->

**Q: How do I run a single test file?**
```bash
# Replace with your test runner's single-file invocation
# e.g. npm test -- path/to/file.test.ts / pytest path/to/test_file.py / go test ./path/...
```

**Q: The build fails with errors I didn't introduce.**
Pull the latest `main` and reinstall dependencies — one may have been updated since you last built.

---

## Contributing

**Q: How large should a PR be?**
Aim for PRs that can be reviewed in under 30 minutes. Split larger changes into multiple PRs if possible.

**Q: Do I need to write tests for every change?**
Yes for new features and bug fixes. Documentation-only PRs are exempt.

**Q: Who merges PRs?**
Maintainers merge PRs once they have one approving review and all CI checks are green.

---

Still stuck? Open a [Discussion](../../../discussions).
