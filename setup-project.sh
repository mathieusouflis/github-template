#!/usr/bin/env bash
# One-time local setup for contributors: activates the Git hooks and creates
# a local .env from the example. Safe to re-run — every step is idempotent.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

##### GIT HOOKS #####
if [ "$(git config --local --get core.hooksPath || true)" = ".githooks" ]; then
  echo "Git hooks already activated."
else
  git config core.hooksPath .githooks
  echo "Activated Git hooks (core.hooksPath = .githooks)."
fi

##### ENV FILE #####
if [ -f .env ]; then
  echo ".env already exists, leaving it alone."
else
  cp .env.example .env
  echo "Created .env from .env.example — fill in the values before running the project."
fi

##### NEXT STEPS #####
cat <<'EOF'

Setup complete. Next steps:
  - Fill in .env with real values.
  - Full setup guide: docs/product-code/tutorials/getting-started.md

If you're a repository admin configuring GitHub settings (branch
protection, collaborators, etc.), see terraform/README.md — that's a
separate, admin-only step, not part of everyday contributor setup.
EOF
