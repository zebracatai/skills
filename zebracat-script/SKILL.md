---
version: 1.1.0
name: zebracat-script
description: |
  Write and refine a voice-over script for a Zebracat video from an idea — no render credits
  spent. A fast, synchronous way to draft, tune, and approve the words before generating.
  Use when: (1) "write a script about X", "draft a voice-over", "give me a 30-second script";
  (2) "I want to see/approve the script first", "just the words, not the video yet";
  (3) tuning length, language, tone, or narration style before committing to a render.
  Returns a ready-to-use script string — hand it straight to zebracat-video (video_type=script)
  to turn it into a finished video.
  Chain signal: once the user approves the script, offer to make the video (zebracat-video).
  If they already know they want the video now, skip this and use zebracat-video directly.
  NOT for: generating the video itself (use zebracat-video), translating a script or video
  (use zebracat-translate), or picking a voice (use zebracat-voice).
argument-hint: "[idea] [duration] [tone]"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Script 🦓

Draft the voice-over **before** spending render credits. Script generation is synchronous —
the words come back immediately, so you can iterate on length, tone, and style until the user
approves, then hand the final script to zebracat-video.

## Skill Announcement

> 🦓 **Using: zebracat-script** — drafting your voice-over

## UX Rules

1. **Show the script, get approval, iterate.** This is the cheap, fast loop — use it freely.
2. **Be concise.** Present the script cleanly; no task IDs or payloads.
3. **One idea per script.** Multi-topic requests become multiple scripts.
4. **Never auto-render.** This skill stops at an approved script. Rendering is zebracat-video.
5. **No internal jargon / no transport narration.**

## Language Awareness

Detect the user's language and write the script in the requested **video language** (default
english). Reply to the user in their language; keep `mood` / `prompt_style` enums in English —
they are API directives.

## Transport Detection (pick one silently)

Same ladder as the suite — full version in [CLAUDE.md](../CLAUDE.md):

1. **CLI (API key)** → 2. **REST (API key)** → 3. **MCP (OAuth, preferred)** → 4. **CLI (OAuth)** → 5. tell the user how to connect.

> **Hard rule:** `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP OAuth.

## Workflow

### Phase 1 — Gather just enough

You need only an **idea**. Infer the rest from the brief; ask at most one or two questions:
- **duration** — target spoken length in seconds: `15 / 30 / 60 / 120 / 180` (default `30`).
- **mood/tone** — e.g. calm, energetic, authoritative (default `happy`).
- **prompt_style** — narration style (e.g. `storytime`); browse options if the user cares, else auto.

"A 30-second energetic script about our launch" already carries idea + duration + mood — don't re-ask.

### Phase 2 — Generate (synchronous)

**MCP:** `generate_script(idea=<idea>, language=<lang>, duration=<sec>, mood=<mood>, prompt_style=<style>)`
**CLI:** `zebracat script "<idea>" --duration 30 --mood happy` (see `zebracat script --help`)
**REST:** `POST /api/public/script_generator` with `{ "idea": "...", "duration": 30, "mood": "happy" }` → `{ "script": "..." }`

Only `idea` is required; everything else has a sensible default.

📖 **Field reference, mood/style enums, length tuning, examples → [references/script-craft.md](references/script-craft.md)**

### Phase 3 — Review & refine

Show the script. Then loop cheaply on the user's feedback:
- "shorter / longer" → adjust `duration` and regenerate.
- "more energetic / more serious" → adjust `mood`.
- "tell it like a story / like a news anchor" → adjust `prompt_style`.
- Small wording tweaks → edit the text directly; no need to regenerate.

⛔ **STOP** here until the user approves. This skill never renders on its own.

### Phase 4 — Hand off

Once approved, offer: *"Want me to turn this into a video?"* → **zebracat-video** with the
approved script (`video_type=script`, pass the script text). If they picked a voice via
zebracat-voice, carry the `voice_id` through.

## Best Practices

- **Iterate here, not in render.** Every render costs credits; script tuning is free and instant.
- **Match length to platform.** 15–30s for social hooks, 60s for explainers, 120–180s for deep dives.
- **Tone follows content.** Calm for wellness/education, high-energy for ads/social, authoritative for finance/B2B.
- **Voice-over is spoken words only.** No stage directions, camera notes, or "[pause]" markers — those aren't read aloud.
- **Hand off clean.** The script string is the deliverable; zebracat-video takes it verbatim.
