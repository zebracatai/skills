#!/usr/bin/env bash
# Fails if the shipped docs/prompts describe the zebracat CLI's auth wrongly.
# The CLI is API-key only (zebracat-cli ce60f18): `zebracat auth login` saves an
# API key billed pay-as-you-go, and `zebracat auth status` exits 0 even when not
# signed in. Run from anywhere: scripts/check-cli-auth-docs.sh
set -uo pipefail
cd "$(dirname "$0")/.."

stale=(
  'CLI \(OAuth\)'
  'auth login[^|.]*(OAuth|browser|account credit|plan credit)'
  'auth status` exits 0'
  'auth status` non-zero'
  'static\.zebracat\.ai/cli'
)
fail=0
for pat in "${stale[@]}"; do
  if grep -rnE --include='*.md' --exclude='CHANGELOG.md' "$pat" . ; then
    fail=1
  fi
done
if [ "$fail" -ne 0 ]; then
  echo "FAIL: stale CLI auth wording above" >&2
  exit 1
fi
echo "OK: CLI auth wording"
