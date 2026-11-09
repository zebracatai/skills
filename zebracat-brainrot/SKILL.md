---
version: 1.2.2
name: zebracat-brainrot
description: |
  Create viral, high-retention short-form "brainrot" videos with Zebracat — vertical clips with
  a gameplay or chaotic background, fast captions, and a punchy voice-over. Formats: subway-
  surfers, minecraft-parkour, italian-brainrot, and general viral.
  Use when: (1) "make a brainrot video", "subway surfers video", "minecraft parkour with a
  story", "italian brainrot", "make this go viral on TikTok"; (2) the user wants the chaotic,
  bottom-caption, gameplay-background TikTok/Reels/Shorts style specifically; (3) "turn this
  fact/script into a viral short".
  Returns a vertical short-form video task. Builds on zebracat-video with brainrot-specific
  defaults (vertical, fast pacing, the right background).
  Chain signal: if the user wants a normal cinematic/explainer/avatar video, use zebracat-video
  instead. If they want to localize a finished short, use zebracat-translate.
  NOT for: standard video types (use zebracat-video), avatars (use zebracat-avatar), voice
  cloning (use zebracat-voice), or translation (use zebracat-translate).
argument-hint: "[topic] [--format subway|minecraft|italian|general]"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Brainrot 🦓

Make scroll-stopping vertical short-form: a gameplay/chaotic background, a punchy hook, fast captions, and a tight voice-over. This is `create_video` with a brainrot preset and opinionated defaults tuned for retention.

## Skill Announcement

> 🦓 **Using: zebracat-brainrot** — cooking up a viral short

## Files & Paths

| Operation | Path | Purpose |
|-----------|------|---------|
| Read | `AVATAR-<NAME>.md` | Only if the user wants a presenter (rare for brainrot) |
| Write | `zebracat-video-log.jsonl` | Append one JSON line per finished video |
| Temp write | `/tmp/zebracat/` | Downloaded MP4, deleted after the session |

## UX Rules

1. **Be concise and fast.** Brainrot is a fast lane — don't over-interview. A topic + a format is usually enough.
2. **No internal jargon / no transport narration.**
3. **Polling is silent.** Surface on completion, hard failure, or one >5-min note.
4. **Default to vertical.** Brainrot is 9:16 unless the user insists otherwise.
5. **Append a JSONL log line** per finished video.

## Language Awareness

Detect the user's language; reply in it. Write captions/voice-over in the video language. Keep `preset`, `aspect`, and other technical args in English.

## Transport Detection (pick one silently)

Same ladder as the suite — full version in [CLAUDE.md](../CLAUDE.md):

1. **CLI (API key)** → 2. **REST (API key)** → 3. **MCP (OAuth, preferred)** → 4. **CLI (saved API key)** → 5. tell the user how to connect.

> **Hard rule:** `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP OAuth.

## Workflow

### Phase 1 — Format + topic (one quick exchange)

Pick the **format** (the background/vibe) and the **topic** (what the video is about):

| Format | Background / vibe | Best for |
|--------|-------------------|----------|
| `subway` | Subway-surfers-style endless-runner gameplay | Fast facts, hooks, storytime |
| `minecraft` | Minecraft parkour gameplay | Gaming audience, listicles, "did you know" |
| `italian` | Italian-brainrot (absurd, meme-chaotic) | Comedy, meme content, gen-z humor |
| `general` | Generic fast-cut viral b-roll | Anything not tied to a gameplay aesthetic |

If the user didn't say, ask one line: *"Which vibe — subway surfers, minecraft parkour, italian brainrot, or general?"* Then get the **topic / script** (a fact, a hook, a short script).

📖 **Format details, hook patterns, caption style, retention rules → [references/formats.md](references/formats.md)**

### Phase 2 — Brainrot defaults

Apply these unless the user overrides:

- the format's **preset** (table below): it sets the gameplay background and the brainrot story shape
- `aspect="vertical"`
- `seconds=15` or `30` (short and punchy; rarely longer)
- the energy (high-energy, or comedic for `italian`) and a strong **hook in the first 1–2 seconds**,
  said in the brief in the user's own words
- fast, bold captions (the plan has them on by default)

| Format | `preset` |
|--------|----------|
| `subway` | `subway-surfers-video-generator` |
| `minecraft` | `minecraft-parkour-generator` |
| `italian` | `italian-brainrot-generator` |
| `general` | `brainrot-video-generator` |

### Phase 3 — Plan, price, generate

Same v2 flow as **zebracat-video**: plan → show the price → generate on the user's yes.

**MCP:**
```
create_video(
  brief="<the user's words: the topic, fact or script>",
  preset="subway-surfers-video-generator",
  aspect="vertical",
  seconds=30,
  idempotency_key="<uuid>"
)
```
For a user-supplied script add `input_kind="script"` (spoken word for word). It plans only
(nothing is spent). Poll `get_video(task_id)` until `phase` is `plan_ready` (or `needs_input`:
ask the engine's question, then `answer_video_question`). Show a short summary and the price
from `quote_video(task_id)`, then on the user's yes: `generate_video(task_id, confirmed=true)`.

**CLI:**
```bash
zebracat video create --brief "<topic>" --preset subway-surfers-video-generator \
  --aspect vertical --seconds 30 --plan-only --wait
zebracat video quote <task_id>
zebracat video generate <task_id> --yes --wait
```

### Phase 4 — Poll + deliver

Silent poll (`get_video(task_id)` / `zebracat video status <task_id>`), then deliver the vertical video with a one-line summary and append the JSONL log line. Offer next steps: *"Want this in other languages?"* → **zebracat-translate**; *"Want a normal cinematic version?"* → **zebracat-video**.

## Best Practices

- **Hook first.** The first 1–2 seconds make or break a brainrot video. Lead with the wildest claim or the question.
- **One fact / one beat.** Brainrot thrives on a single punchy idea, not a thesis.
- **Keep it short.** 15–30s. Longer kills retention.
- **Captions are the content.** Bold, fast, synced. Voice-over carries; captions reinforce.
- **Match format to audience.** Gaming → minecraft; meme/comedy → italian; mass-appeal facts → subway; everything else → general.
- **Don't over-produce.** Brainrot is fast and raw by design — when unsure, use the `brainrot-video-generator` preset.
