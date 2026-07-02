#!/usr/bin/env bash
# Wrapper around `terraform -chdir=terraform` that sources GITHUB_TOKEN from
# your existing `gh` login when possible, falling back to an interactive
# prompt. Usage: ./terraform/setup.sh plan | ./terraform/setup.sh apply
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  GITHUB_TOKEN="$(gh auth token)"
  export GITHUB_TOKEN
  echo "Using GitHub token from 'gh auth token'."
else
  read -rsp "GitHub token (repo admin scope, fine-grained or classic PAT): " GITHUB_TOKEN
  echo
  export GITHUB_TOKEN
fi

terraform -chdir="$SCRIPT_DIR" "$@"
