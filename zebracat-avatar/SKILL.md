---
version: 1.0.0
name: zebracat-avatar
description: |
  Choose or customize a Zebracat AI avatar presenter, or build a reusable named character,
  and save it to an AVATAR-<NAME>.md state file (Appearance / Voice / Zebracat IDs) that
  zebracat-video reads to generate presenter-led videos.
  Use when: (1) "set up an avatar", "pick a presenter", "give my videos a face",
  "I want a spokesperson"; (2) "create a character called X", "design a presenter named Y";
  (3) establishing a reusable presenter BEFORE making avatar videos — the correct first step
  when no avatar exists yet; (4) "use my own avatar", "customize the avatar's look/voice".
  Returns avatar_id + voice_id, saved to AVATAR-<NAME>.md — pass directly to zebracat-video
  (video_type=ai_avatar).
  Chain signal: if the user says an avatar/identity action AND a video action in one request
  ("set up an avatar AND make a video", "design a presenter then record"), run zebracat-avatar
  first, then zebracat-video.
  NOT for: generating videos (use zebracat-video), cloning a voice from a sample
  (use zebracat-voice), or translating videos (use zebracat-translate).
argument-hint: "[name or description]"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Avatar Designer 🦓

Choose, customize, and save Zebracat avatar presenters and named characters. Handles selection, voice pairing, and writes everything to `AVATAR-<NAME>.md` for consistent reuse across videos.

## Skill Announcement

> 🦓 **Using: zebracat-avatar** — setting up your presenter

## Files & Paths

| Operation | Path | Purpose |
|-----------|------|---------|
| Read | `AVATAR-<NAME>.md` | Load an existing avatar/character to reuse or update |
| Write | `AVATAR-<NAME>.md` | Save the avatar identity (Appearance / Voice / Zebracat IDs) |
| Temp write | `/tmp/zebracat/` | Voice/avatar preview assets, deleted after the session |

Assets are uploaded to Zebracat only when the user explicitly provides them (e.g. a reference photo for a custom avatar).

## UX Rules

1. **Be concise.** No avatar IDs or raw payloads in chat — report "your presenter is ready", not the plumbing.
2. **No internal jargon.** Never name phases or transports to the user.
3. **One or two questions per phase.** Walk the phases in order; don't batch a form.
4. **Read workspace files before asking.** Check `AVATAR-*.md` first; only ask for what's missing.
5. **Stop at checkpoints.** Wait for explicit approval before saving an avatar and before picking a voice.
6. **Never narrate transport choice.** MCP vs CLI vs REST is internal.

## Language Awareness

Detect the user's language; communicate in it. When pairing a voice, specify the target language so the catalog returns voices that speak it. Enum/id values (avatar mode, voice ids) stay in English.

## Transport Detection (pick one silently)

Same ladder as the rest of the suite — full version in [CLAUDE.md](../CLAUDE.md):

1. **CLI (API key)** — `ZEBRACAT_API_KEY` set + CLI works.
2. **REST (API key)** — key set, no CLI.
3. **MCP (OAuth)** — no key + `mcp__zebracat__*` visible. **Preferred for end users.**
4. **CLI (OAuth)** — no key, no MCP, CLI present (`zebracat auth login`).
5. **Neither** → tell the user once how to connect MCP or the CLI.

> **Hard rule:** `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP OAuth.

## AVATAR File Convention

Every avatar/character gets one file: `AVATAR-<NAME>.md` at the workspace root.

```markdown
# Avatar: <Name>

## Appearance
- Age / Gender / Ethnicity: <natural language>
- Hair / Build / Features: <natural language>
- Style / Wardrobe: <natural language>
- Reference: <optional workspace-relative path or URL to a photo>

## Voice
- Tone: <natural language>
- Accent / Language: <natural language>
- Energy: <natural language>

## Zebracat
- Avatar ID: <stable presenter id>
- Avatar Mode: <stock | custom>
- Voice ID: <paired voice id>
- Voice Name: <human-readable>
- Aspect Looks: vertical=<ok>, horizontal=<ok>, square=<ok>
- Last Synced: <ISO timestamp>
```

**Top sections (Appearance, Voice)** are portable natural language. **The Zebracat section** is runtime config — zebracat-video reads `Avatar ID` + `Voice ID` from here.

## Workflow

Walk the phases in order. Ask at most one or two things per phase.

### Phase 0 — Who are we setting up?

Routing signals:
1. **Reuse / update** — an `AVATAR-<NAME>.md` already exists. Read it. "You already have <Name>. Reuse, update the look, or start fresh?" Wait.
2. **Named character** — "create a character called Cleo" → use the given name.
3. **Presenter for the user / brand** (default) — "set up an avatar", "give my videos a face" → pick a name (ask if not obvious).

### Phase 1 — Pick or describe the avatar

Two paths:

**Path A — Pick a stock avatar (default, fastest).** Browse Zebracat's avatar catalog and show previews:

**MCP:** `list_avatars(mode=<optional>)`
**CLI:** `zebracat avatar list --human`

Filter by the desired look (gender, age, vibe), show 3–5 options **with preview images**, and let the user choose. Never just list names.

**Path B — Customize / named character.** If the user wants a specific look or a real-person likeness, gather appearance traits conversationally (one or two at a time) and, if they offer a reference photo, note its path in the Appearance → Reference field. Custom-avatar creation runs through Zebracat's avatar pipeline.

📖 **Selection criteria, customization options, reference-photo handling, mode tradeoffs → [references/avatar-selection.md](references/avatar-selection.md)**

⛔ **STOP.** Show the chosen avatar (preview + a one-line description) and wait for approval before saving.

### Phase 2 — Pair a voice

Match a voice to the character's tone and language:

**MCP:** `list_voices(language=<lang>, gender=<optional>)`
**CLI:** `zebracat voice list --human`

Default to a Zebracat (Runware) voice. Present 2–3 candidates with previews. If the user wants their **own** voice, hand off to **zebracat-voice** to clone one, then return with the `voice_id`.

⛔ **STOP.** Wait for the user to pick a voice. Don't auto-select.

### Phase 3 — Save to the AVATAR file

Write `AVATAR-<NAME>.md` with Appearance, Voice, and the Zebracat section (Avatar ID, Voice ID, mode, timestamp). Confirm it's saved and that zebracat-video will pick it up automatically.

### Phase 4 — Make a video (optional)

If the user wants to see the presenter in action, hand off to **zebracat-video** with `video_type=ai_avatar` and the new `Avatar ID` + `Voice ID`. Offer a short test clip first.

## Iteration

- **"Different look"** → back to Phase 1, keep the name and voice.
- **"Different voice"** → back to Phase 2.
- **"Start over"** → new character, overwrite the Zebracat section.

The AVATAR file is always the source of truth. Each iteration updates it.

## Error Handling

- No catalog results for the filter → widen the filter or switch to a custom avatar.
- Voice match poor → browse the full voice list, or hand off to zebracat-voice.
- Reference photo upload fails → skip it, use a stock or prompt-based avatar.
- Stale ids in an existing AVATAR file → offer to refresh by re-listing avatars/voices.

📖 **Known issues, retry patterns, error → action mapping → [references/troubleshooting.md](references/troubleshooting.md)**
