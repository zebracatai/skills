#!/usr/bin/env bash
# zebracat-skills update-check — opt-in version check for the Zebracat Skills.
#
# Compares the local VERSION against the latest published on GitHub. Read-only,
# transmits nothing, and is safe to run (or skip) at any time. It is NOT run
# automatically on skill invocation — call it manually when you want to check.
#
# Output (one line, or nothing):
#   UP_TO_DATE <version>            — local matches remote
#   UPGRADE_AVAILABLE <old> <new>   — remote VERSION differs from local
#   (nothing)                       — disabled, snoozed, offline, or no VERSION found
#
# Env overrides (for testing):
#   ZEBRACAT_SKILL_DIR    — override auto-detected repo root
#   ZEBRACAT_SKILLS_STATE — override ~/.zebracat-skills state directory
#   ZEBRACAT_REMOTE_URL   — override remote VERSION URL
set -euo pipefail

SKILL_DIR="${ZEBRACAT_SKILL_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
STATE_DIR="${ZEBRACAT_SKILLS_STATE:-$HOME/.zebracat-skills}"
CACHE_FILE="$STATE_DIR/last-update-check"
VERSION_FILE="$SKILL_DIR/VERSION"
LOCAL_SKILL_MD="$SKILL_DIR/SKILL.md"
REMOTE_URL="${ZEBRACAT_REMOTE_URL:-https://raw.githubusercontent.com/zebracatai/skills/main/VERSION}"

# --force busts the cache.
if [ "${1:-}" = "--force" ]; then
  rm -f "$CACHE_FILE"
fi

# Disabled? Stay silent.
if [ -f "$STATE_DIR/update-check-disabled" ]; then
  exit 0
fi

# --- Read local version -------------------------------------------------------
LOCAL=""
if [ -f "$VERSION_FILE" ]; then
  LOCAL="$(tr -d '[:space:]' < "$VERSION_FILE" 2>/dev/null || true)"
fi
# Fallback: read version: from a SKILL.md frontmatter (subdir-only installs).
if [ -z "$LOCAL" ] && [ -f "$LOCAL_SKILL_MD" ]; then
  LOCAL="$(awk '/^---/{c++; next} c==1 && /^version:/{gsub(/^version:[[:space:]]*/,""); gsub(/[[:space:]]*#.*$/,""); gsub(/[[:space:]]/,""); print; exit}' "$LOCAL_SKILL_MD" 2>/dev/null || true)"
fi
if [ -z "$LOCAL" ]; then
  exit 0  # No VERSION → skip silently.
fi

# --- Cache freshness (60 min TTL) --------------------------------------------
if [ -f "$CACHE_FILE" ]; then
  FRESH="$(find "$CACHE_FILE" -mmin -60 2>/dev/null || true)"
  if [ -n "$FRESH" ]; then
    CACHED="$(cat "$CACHE_FILE" 2>/dev/null || true)"
    case "$CACHED" in
      "UP_TO_DATE $LOCAL") exit 0 ;;
      "UPGRADE_AVAILABLE $LOCAL "*) echo "$CACHED"; exit 0 ;;
    esac
  fi
fi

# --- Fetch remote version -----------------------------------------------------
mkdir -p "$STATE_DIR"
REMOTE="$(curl -sf --max-time 5 "$REMOTE_URL" 2>/dev/null | tr -d '[:space:]' || true)"

# Reject anything that isn't a version number (e.g. an HTML error page) → silent.
if ! printf '%s' "$REMOTE" | grep -qE '^[0-9]+\.[0-9.]+$'; then
  exit 0
fi

if [ "$LOCAL" = "$REMOTE" ]; then
  echo "UP_TO_DATE $LOCAL" > "$CACHE_FILE"
  exit 0
fi

echo "UPGRADE_AVAILABLE $LOCAL $REMOTE" > "$CACHE_FILE"
echo "UPGRADE_AVAILABLE $LOCAL $REMOTE"
