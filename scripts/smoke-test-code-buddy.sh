#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREFIX="$(brew --prefix)"
TAP_NAME="local/code-buddy-smoke"

cleanup() {
  brew uninstall --force code-buddy >/dev/null 2>&1 || true
  brew untap "$TAP_NAME" >/dev/null 2>&1 || true
}

trap cleanup EXIT

cleanup
brew tap-new "$TAP_NAME" >/dev/null
TAP_REPO="$(brew --repo "$TAP_NAME")"

mkdir -p "$TAP_REPO/Formula"
cp "$ROOT_DIR/Formula/code-buddy.rb" "$TAP_REPO/Formula/code-buddy.rb"

brew uninstall --force code-buddy >/dev/null 2>&1 || true
HOMEBREW_NO_AUTO_UPDATE=1 brew install --build-from-source "$TAP_NAME/code-buddy"

test -x "$PREFIX/bin/code-buddy"
"$PREFIX/bin/code-buddy" --help | grep -q doctor
