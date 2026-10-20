---
version: 1.2.0
name: zebracat-translate
description: |
  Translate and dub an existing video into another language with optional captions, powered
  by Zebracat video translation. The voice is re-spoken in the target language and the video
  is re-rendered — viewers watch the same video speaking their language.
  Use when: (1) "translate this video to Spanish", "dub this into Japanese", "make this in
  French and German", "I need this in 10 languages"; (2) the user has a FINISHED video (URL)
  and wants it localized; (3) "subtitle and dub", "make a multilingual version", "add captions
  in <language>".
  Returns one translated video URL per target language.
  Chain signal: if the user wants to CREATE a new video in another language (no source video
  exists yet), route to zebracat-video and write the script in the target language — do not use
  zebracat-translate. Use this skill only when there is an existing source video to localize.
  NOT for: creating new videos (use zebracat-video), avatar creation (use zebracat-avatar),
  voice cloning (use zebracat-voice), or text-only translation.
argument-hint: "[video_url] [--to language]"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Video Translation 🦓

Localize a finished video into one or more languages. You provide a source video URL and target language(s); the engine handles transcription, translation, re-voicing, and (optionally) captions, then re-renders. This is **not** new-video generation — the source's visuals and performance are preserved.

## Skill Announcement

> 🦓 **Using: zebracat-translate** — translating your video

## Files & Paths

| Operation | Path | Purpose |
|-----------|------|---------|
| Write | `zebracat-video-log.jsonl` | Append one JSON line per finished translation |
| Temp write | `/tmp/zebracat/` | Downloaded source / result MP4s, deleted after the session |

## UX Rules

1. **Be concise.** No translation IDs or status JSON in chat — report "Spanish version ready: <link>".
2. **No internal jargon.** Don't say "polling", "task_id", "endpoint". Say "translating", "almost done".
3. **Polling is silent.** Background long jobs; surface only on per-language completion, hard failure, or a single >5-min note.
4. **One result, one message.** Deliver each language as it finishes with a one-line summary.
5. **Never narrate transport choice.** MCP vs CLI vs REST is internal.
6. **Reply in the user's language.** Detect from their first message; keep technical language names canonical.

## Transport Detection (pick one silently)

Same ladder as the suite — full version in [CLAUDE.md](../CLAUDE.md):

1. **CLI (API key)** — `ZEBRACAT_API_KEY` set + CLI works.
2. **REST (API key)** — key set, no CLI.
3. **MCP (OAuth)** — no key + `mcp__zebracat__*` visible. **Preferred for end users.**
4. **CLI (OAuth)** — no key, no MCP, CLI present.
5. **Neither** → tell the user once how to connect MCP or the CLI.

> **Hard rule:** `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP OAuth.

## Workflow

Four phases. Phase 1 is the only place you ask questions. Phases 2–3 are silent. Phase 4 is one short message per language.

```
Phase 1 — Discover     gather source video + target language(s)
Phase 2 — Pre-flight   validate language, check source reachability, set flags (silent)
Phase 3 — Submit+Poll  kick off, background poll, surface only on done/fail
Phase 4 — Deliver      post each result with a one-line summary
```

### Phase 1 — Discover

Ask only what you don't already have. One or two questions per turn.

**Required:**
1. **Source video.** A public URL (or a Zebracat task_id / output from a prior step). If missing: *"What's the source video — a public link?"*
2. **Target language(s).** Ask open-ended: *"Which language(s) should I translate it into?"* Accept one or many; validate in Phase 2.

**Important (smart defaults, ask only if relevant):**
3. **Captions.** Default ON for talking-head/corporate. Mention it if you flip the default.
4. **Render now?** `should_render` / `--render` — default to rendering the final dubbed video; offer a draft if the user wants to review first.

📖 **Language list, regional variants, RTL + locale gotchas → [references/languages.md](references/languages.md)**

### Phase 2 — Pre-flight (silent)

- **Validate the language** against the supported list: `list_languages()` (MCP); the CLI validates on submit (`zebracat video translate --to <lang>`). Map loose input to a canonical name ("Spanish" → "Spanish (Spain)", "Chinese" → "Chinese (Mandarin, Simplified)"). If no match, ask the user to pick the closest.
- **Check the source is reachable.** A public HTTPS URL returning a video works directly. Auth-walled / 403 / 404 / HTML → ask for a public URL.
- **Regional variants matter.** If the user says "Spanish" without a region and the audience is unclear, confirm Spain vs Latin America once.

### Phase 3 — Submit + Poll (silent)

Submit one job per target language.

**MCP:**
```
translate_video(
  video_url="https://…/source.mp4",
  target_language="Spanish (Spain)",
  enable_caption=true,
  should_render=true
)
```

**CLI:**
```bash
zebracat video translate --url "https://…/source.mp4" --to "Spanish (Spain)" --render --wait
```
For multiple languages, submit one job each and capture every `task_id`. `--wait` blocks per job; for batches, drop `--wait` and poll each.

**Poll** (background): `get_video_status(task_id)` / `zebracat video status <id>`. Cadence: 30s for the first 3 min, then 60s. Most finish in a few minutes; long sources take longer. Deliver each language as it completes — don't wait for all.

### Phase 4 — Deliver

One message per completed language:

> ✅ Spanish (Spain) — <video_url> · captions on

Append a line to `zebracat-video-log.jsonl` per finished translation (`video_type:"translation"`, `topic:"<source> → <lang>"`). If a language fails, give one short line with the likely cause (unreachable source URL, unsupported language, or insufficient credits) and move on.

## Source Quality

Translation can't improve on the source. If the source has muffled audio, heavy background music, or very low resolution, the dub inherits it. Warn the user **upfront** in Phase 2 — not after a weak result. For a first-time user or a long video, suggest testing one language first before batching many.

## Cost & time awareness

Translation bills by source duration × language count. A 3-minute video in 5 languages ≈ 15 billable minutes. Surface the math in Phase 1 for batches: *"That's 5 languages × 3 minutes — want me to do all five?"* Don't quote dollar figures (varies by plan); quote source-minutes × languages and an honest time range. Check `get_balance()` / `zebracat account usage` if credits look low.

## Best Practices

1. **Validate the language string** before submitting.
2. **Confirm the regional variant** when the user is vague (Spanish, Portuguese, Chinese, Arabic, French).
3. **Source quality is the ceiling** — say it upfront.
4. **Suggest a test language** for new users or long videos.
5. **Deliver per-language** as each finishes.
6. **Never narrate transport.**
