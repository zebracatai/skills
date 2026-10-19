---
version: 1.2.0
name: zebracat-script
description: |
  Write and refine a video script from an idea with Zebracat Studio's writer (the same as the
  dashboard's Studio → Script) — free, no render credits. Draft, tune and approve the words
  before generating.
  Use when: (1) "write a script about X", "draft a voice-over", "give me a 30-second script";
  (2) "I want to see/approve the script first", "just the words, not the video yet";
  (3) tuning length, language, tone, or narration style before committing to a render.
  Returns the script (who says what) and the narration text — hand it to zebracat-video
  (input_kind=script / voiceover_script) or to zebracat-studio for a voice-over.
  Chain signal: once the user approves the script, offer to make the video (zebracat-video).
  If they already know they want the video now, skip this and use zebracat-video directly.
  NOT for: generating the video itself (use zebracat-video), translating a script or video
  (use zebracat-translate), or picking a voice (use zebracat-voice).
argument-hint: "[idea] [seconds] [tone]"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Script 🦓

Draft the words **before** spending render credits. A script takes a few seconds and costs
nothing (within an hourly/daily allowance), so iterate on length, tone and format until the user
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
english). Reply to the user in their language; keep `tone` / `format` ids in English — they are
API directives.

## Transport Detection (pick one silently)

Same ladder as the suite — full version in [CLAUDE.md](../CLAUDE.md):

1. **CLI (API key)** → 2. **REST (API key)** → 3. **MCP (OAuth, preferred)** → 4. **CLI (OAuth)** → 5. tell the user how to connect.

> **Hard rule:** `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP OAuth.

## Workflow

### Phase 1 — Gather just enough

You need only an **idea**. Infer the rest from the brief; ask at most one or two questions:
- **seconds** — target spoken length (default from the account; 15-30 for social, 60 for explainers).
- **tone** and **format** — ids from the options call (`auto` lets the writer pick).
- **language** — the video language.

"A 30-second energetic script about our launch" already carries idea + length + tone — don't re-ask.

### Phase 2 — Write

**MCP:** `write_script(idea=<idea>, seconds=<n>, language=<lang>)` → `get_script(job_id)` until done.
**CLI:** `zebracat studio script "<idea>" --seconds 30 --wait`
**REST:** `POST /api/v1/public/studio/scripts` `{ "idea": "...", "seconds": 30 }` → `202 {job_id}`, then
`GET /api/v1/public/studio/scripts/{job_id}` until `status` is `done`; `result.plain_text` /
`result.narration_text`.

Only `idea` is required. If the server answers 404 (Studio not open there), fall back to the legacy
`generate_script` / `POST /script_generator` (`{idea, duration, mood}` → `{script}`).

📖 **Fields, result shape, length tuning, examples → [references/script-craft.md](references/script-craft.md)**

### Phase 3 — Review & refine

Show the script. Then loop cheaply on the user's feedback:
- "shorter / longer" → adjust `seconds` and write again.
- "more energetic / more serious" → another `tone`.
- "make it a conversation / an interview" → another `format`.
- Small wording tweaks → edit the text directly; no need to regenerate.
- A stronger opening → **zebracat-studio** hooks.

⛔ **STOP** here until the user approves. This skill never renders on its own.

### Phase 4 — Hand off

Once approved, offer: *"Want me to turn this into a video?"* → **zebracat-video** with the
approved script (`input_kind: "script"` with `plain_text` when people speak, or
`"voiceover_script"` with `narration_text` for one narrator). If they picked a voice via
zebracat-voice, carry the `voice_id` through. For only the audio, hand `narration_text` to
**zebracat-studio** (voice-over).

## Best Practices

- **Iterate here, not in render.** Every render costs credits; script tuning is free and fast.
- **Match length to platform.** 15–30s for social hooks, 60s for explainers, 120–180s for deep dives.
- **Tone follows content.** Calm for wellness/education, high-energy for ads/social, authoritative for finance/B2B.
- **Voice-over is spoken words only.** No stage directions, camera notes, or "[pause]" markers — those aren't read aloud.
- **Hand off clean.** The script string is the deliverable; zebracat-video takes it verbatim.
