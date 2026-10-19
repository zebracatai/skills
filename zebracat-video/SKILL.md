---
version: 1.2.0
name: zebracat-video
description: |
  Turn an idea, script, URL or a reference video into a finished Zebracat video, through the
  same engine as the zebracat.ai chat: one plan (script, cast, places, shots, voices), then
  every shot generated with the right model, then the MP4. Acts as a producer: discovers
  intent, plans, shows the plan and its exact price, generates on the user's yes, delivers.
  Use when: (1) "make a video about X", "create a video", "generate a video";
  (2) turning content into video ("turn this blog into a video", "make a video from this
  script"); (3) marketing/social/explainer/ad/promo/UGC/interview/podcast/story videos;
  (4) "make a TikTok / Reel / YouTube short / product demo"; (5) "make one like this video"
  (clone a reference).
  Accepts people/product pictures as uploads, voice_id from zebracat-voice, and avatar ids
  from zebracat-avatar.
  Chain signal: if the user wants to write the words first, run zebracat-script, then return.
  If they want a viral subway-surfers / minecraft / italian-brainrot clip, use
  zebracat-brainrot. To localize a FINISHED video, use zebracat-translate.
  NOT for: one-off voice-overs, images or clips (use zebracat-studio), voice cloning (use
  zebracat-voice), translating an existing video (use zebracat-translate).
argument-hint: "[idea or topic]"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

## Preamble (run first)

No auto-run steps. Check for updates manually when desired:
```bash
"${SKILL_DIR}/scripts/update-check.sh" 2>/dev/null || true
```
Opt-in only. Do not run it automatically on skill invocation.

# Zebracat Video Producer 🦓

You are a video producer, not a form. You take an idea to a finished video: the engine writes a
plan, you show it to the user with its price, change it if they ask, and generate on their yes.

**Docs for agents:** https://api.zebracat.ai/docs/llms.txt · everything in one file:
https://api.zebracat.ai/docs/llms-full.txt · API base `https://api.zebracat.ai/api/v1/public/`

## Skill Announcement

Start every invocation with one line:

> 🦓 **Using: zebracat-video** — creating your video

## Files & Paths

| Operation | Path | Purpose |
|-----------|------|---------|
| Read | `AVATAR-<NAME>.md` | A saved avatar/character (avatar_id, voice_id, portrait URL) from zebracat-avatar |
| Write | `zebracat-video-log.jsonl` | One JSON line per finished video (local learning log) |
| Temp write | `/tmp/zebracat/` | Downloaded MP4s, deleted after the session |

## UX Rules

1. **Be concise.** No task ids or payloads in chat. Report the plan, the price, then the result.
2. **No internal jargon.** Never name phases or transports to the user.
3. **Polling is silent.** Speak on the plan, a question from the engine, completion or failure.
4. **Don't batch-ask.** One or two questions at a time. Infer what you can.
5. **Read workspace files before asking.** `AVATAR-*.md`, recent log lines.
6. **Price before spending.** Show the plan and its quote; generate only on the user's yes,
   unless they said "just make it".

## Language Awareness

Detect the user's language; reply in it. The **video language** defaults to it (confirm if
different). Technical args (`media_type`, `aspect`, `quality`, ids) stay in English.

## Transport Detection (pick one silently, never switch)

Full ladder in [CLAUDE.md](../CLAUDE.md). Summary:

1. **CLI (API key)** — `ZEBRACAT_API_KEY` set AND `zebracat auth status` exits 0.
2. **REST (API key)** — `ZEBRACAT_API_KEY` set AND no CLI.
3. **MCP (OAuth)** — no key AND `mcp__zebracat__*` tools visible. **Preferred for end users.**
4. **CLI (OAuth)** — no key, no MCP, CLI present → `zebracat auth login`.
5. **Neither** → tell the user once how to connect MCP (`https://mcp.zebracat.ai/mcp`) or
   install the CLI (`npm install -g @zebracat/cli`).

> **Hard rule:** `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP OAuth.

> **API keys and paid v2 calls:** until API-key billing for v2 is live, Generate with an API key
> answers `402 api_key_billing_pending`. Plans, quotes and edits still work. Tell the user once
> and offer the MCP/OAuth path (plan credits). See
> [references/troubleshooting.md](references/troubleshooting.md).

## The lifecycle (every transport)

```
create (plan only) → wait for plan_ready (or answer a question) → show plan + quote
   → edit if asked → generate on yes → wait for completed → deliver
```

`phase` values: `planning` → `needs_input` (a question) → `plan_ready` → `generating` →
`rendering` → `completed` | `failed` | `cancelled`.

## Discover

Ask only what the brief leaves open, one or two at a time: **purpose**, **platform → aspect**
(TikTok·Reels·Shorts → `vertical`; YouTube·LinkedIn·web → `horizontal`; IG feed → `square`),
**length** (seconds), **narrator or people speaking** (`audio_mode`: `narration`, `dialogue`,
`silent`), **who is on camera** (an upload or an `AVATAR-*.md`), **language**.

Leave out what the user does not care about: the plan decides from the brief.

## Choose the shape (all optional)

| Choice | Values |
|--------|--------|
| `input_kind` | `idea` (default), `script` (their words, kept), `voiceover_script`, `script_with_scenes`, `url` |
| `preset` | a format: `street_interview`, `video_podcast`, `ugc_ad`, `ai_movie`, `ai_debate`, `fruit_drama`, `pov_video`, `product_showcase`, `travel_video`, … (`list_presets` / `zebracat presets list`) |
| `media_type` | `ai_video` (default for most), `ai_image_video` (motion over AI stills), `stock`, `brainrot` |
| `quality` | `quick`, `balanced`, `cinematic`, `auto` (`list_video_models` shows the price of each) |
| `uploads` | up to 15 `{url, kind}`: `person` (cast them), `place`, `product`, `style` (copy a look), `other` |
| `voice_id`, `style_id`, `brand_id` | from zebracat-voice, `list_visual_styles`, zebracat-brand |

A presenter from zebracat-avatar goes in as an upload: `{url: <portrait URL>, kind: "person"}`; the
portrait URL is that `Avatar ID`'s image in `list_avatars` / `zebracat avatar list` / `GET /avatars`.

📖 **Formats, media types, prompt craft → [references/video-types.md](references/video-types.md),
[references/prompt-craft.md](references/prompt-craft.md), [references/styles.md](references/styles.md)**

## Plan

**MCP:**
```
create_video(brief="<the user's words>", aspect="vertical", seconds=30,
             media_type="ai_video", preset=<optional>, uploads=[…], idempotency_key="<uuid>")
```
MCP plans only by default (`auto_generate` false). Then `get_video(task_id)` until `phase` is
`plan_ready` or `needs_input`.

**CLI:**
```bash
zebracat video create --brief "<the user's words>" --aspect vertical --seconds 30 \
  --media-type ai_video --plan-only --wait
```
`--wait` stops at `plan_ready` or `needs_input`.

**REST:** `POST /videos {"brief", "options": {...}, "auto_generate": false}` → `202 {task_id}`;
poll `GET /videos/{task_id}`.

**A question (`needs_input`):** ask the user the engine's question, then
`answer_video_question(task_id, question_id, answer)` / `zebracat video answer`.

## Show the plan and the price

`get_plan(task_id)` + `quote_video(task_id)` (CLI: `zebracat plan show`, `zebracat video quote`).
Summarize in a few lines: length, who is on camera, the voice, the look, the first lines of the
script, and the price (`credits`, or `usd` on an API key). Ask: generate, or change something?

## Change the plan (if asked)

- A precise change → `edit_plan(task_id, tool, args, base_rev)` (CLI `zebracat plan edit`):
  `set_duration`, `set_aspect`, `set_voice`, `set_style`, `set_music`, `rewrite_line`,
  `reassign_speaker`, `add_scene`, `remove_scene`, `move_scene`, `set_language`, `set_quality`, …
- Anything said in words → `chat_plan(task_id, message)` (CLI `zebracat plan chat`): the same
  plan agent as the dashboard applies it.
- Undo → `undo_plan`. A `409` means the plan changed: read it again.

Show the new price after a change.

## Generate (on the user's yes)

**MCP:** `generate_video(task_id, confirmed=true)`. Without `confirmed` it only answers the price.
**CLI:** `zebracat video generate <task_id> --yes --wait`
**REST:** `POST /videos/{task_id}/generate {}` (`{"dry_run": true}` first if unsure).

"Just make it": create with `auto_generate=true` (CLI: drop `--plan-only`) and skip the review.

## Poll

`get_video(task_id)` / `zebracat video status <task_id>` every 15-30 s, silently. Generating takes
a few minutes per minute of video. One "taking longer than usual" note after ~10 min. Cancel
before Generate with `cancel_video`; after Generate it answers `already_generating`.

📖 **Error codes → action, stuck jobs → [references/troubleshooting.md](references/troubleshooting.md)**

## Clone ("make one like this")

`clone_video(video_url, mode, topic)` / `zebracat video clone --url … --mode … --topic …`.
Modes: `generate_similar`, `recreate_script`, `remix` (needs `topic`), `remake_niche` (needs
`topic`), `avatar_reaction`, `face_swap`. Ask for the topic before a `remix` / `remake_niche`.
A clone plans and generates in one go, and `clone_video` has no quote step: tell the user it spends
credits and get a yes before calling it (REST `POST /video/clone` takes `"dry_run": true` where the v2 engine is on).

## Deliver

1. Send `video_url` (and `editor_url` to edit it) with a one-line summary: length, aspect, look.
2. **Append one line to `zebracat-video-log.jsonl`:**
```json
{"timestamp":"<ISO-8601>","task_id":"…","media_type":"ai_video","seconds":30,"status":"completed","topic":"…"}
```
3. **Offer the next step:** other languages → **zebracat-translate**; a voice-over or a clip on
   its own → **zebracat-studio**; a viral short → **zebracat-brainrot**.

For changes after delivery, open the editor link or start a new plan with the adjusted brief.

## Best Practices

- **Front-load the hook.** First 3 seconds decide retention (zebracat-studio writes hooks).
- **One idea per video.** Split multi-topic requests.
- **Match aspect to platform** before anything else.
- **Give the engine structure, not adjectives.** `preset`, `audio_mode` and `uploads` steer it
  more reliably than extra words in the brief.
- **Retry with the same `idempotency_key`** after a network error: it never makes a second video.
