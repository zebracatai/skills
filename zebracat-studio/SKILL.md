---
version: 1.2.0
name: zebracat-studio
description: |
  Zebracat Studio's single-purpose tools, one at a time: hooks (scroll-stopping opening lines
  for a script), a voice-over from text in any voice, an AI image, or a short AI video clip.
  The same tools, prices and limits as the dashboard's Studio.
  Use when: (1) "write me hooks / a better opening line for this script"; (2) "make a
  voice-over of this text", "read this in <voice>", "an MP3 of this script"; (3) "a clip of X",
  "a 5-second shot of …", "animate this picture"; (4) "an image of X" on the Studio models.
  Chain signal: a full video with a story → zebracat-video; the words first → zebracat-script;
  a cloned voice → zebracat-voice first, then come back with the voice_id.
  NOT for: whole videos (zebracat-video), script writing (zebracat-script), voice cloning
  (zebracat-voice), translating a video (zebracat-translate).
argument-hint: "[hooks|voice|image|clip] [text or prompt]"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Studio 🦓

Four quick tools. Each is one call (plus a status poll), lands in the user's asset library, and
can be used in a video later.

**Docs for agents:** https://api.zebracat.ai/docs/guides/studio.md

## Skill Announcement

> 🦓 **Using: zebracat-studio** — <hooks | voice-over | image | clip>

## UX Rules

1. **Price before spending.** Voice-overs and clips cost credits: show the quote (`dry_run`) and
   wait for a yes. Hooks and images are free (within allowances).
2. **Be concise.** Give the result (hooks as a list, an audio/image/clip link), not payloads.
3. **Polling is silent.** Speak on the result or a failure.
4. **One transport, picked silently** (ladder in [CLAUDE.md](../CLAUDE.md); hard rule:
   `ZEBRACAT_API_KEY` set ⇒ CLI/REST, unset ⇒ MCP OAuth).
5. **Studio may be closed on a server** (answers 404): say the tool is not available yet and offer
   zebracat-video / zebracat-image instead.

## Which tool

| The user wants | Tool | MCP | CLI | Cost |
|----------------|------|-----|-----|------|
| better opening lines for a script | hooks | `write_hooks` | `zebracat studio hooks --script <file>` | free |
| a voice-over (audio) of a text | voice | `generate_voice` | `zebracat studio voice --text <file> --voice <id>` | voice credits by length |
| a still image | image | `generate_image` | `zebracat studio image "<prompt>"` | 0 credits, daily cap |
| a short video clip, or a still animated | clip | `generate_clip` | `zebracat studio clip "<prompt>" --seconds N` | the model's credits per started 5 s |

Status: `get_studio_job(tool, job_id)` / `zebracat studio job <tool> <job_id>`.

## Hooks

Send the script (or the topic). Show the hooks as a short numbered list; the answer also carries
each hook's rewritten script (`hooked_scripts`). Offer "more like #2" (`variations`) and hand the
chosen hooked script to zebracat-video or to the voice tool.

## Voice-over

1. A `voice_id`: `list_voices(language=…)` / `zebracat voice list`, or a cloned voice from
   zebracat-voice. Match the voice to the text's language.
2. Quote: `generate_voice(script, voice_id, language)` without `confirmed` (MCP) /
   `--dry-run` (CLI) / `"dry_run": true` (REST). Tell the user the price.
3. On yes: `confirmed: true` / drop `--dry-run`. Poll; deliver `audio_url` (CLI `-o out.mp3`).

Text = spoken words only: no stage directions, no speaker labels.

## Image

`generate_image(prompt, model?, aspect?, count?, reference_urls?)`. `GET /studio/media/models`
(`list_media_models` if exposed) lists the models. Show the image link(s).

## Clip

1. `prompt` (one shot: subject, action, camera), `seconds`, `aspect`, optional `image_url` to
   animate a still, optional `model`.
2. Quote first (`dry_run` / no `confirmed`), then generate on yes.
3. Poll every 10-20 s; deliver the clip URL. A failed clip releases its credits.

📖 **Fields, shapes, errors, REST examples → [references/studio-api.md](references/studio-api.md)**

## Chaining

- Hooks → the chosen hooked script → **zebracat-video** (`input_kind: "voiceover_script"`).
- Voice-over → the user's own video edit, or **zebracat-video** with the same `voice_id`.
- Image → `uploads: [{url, kind: "style" | "product" | "person"}]` in **zebracat-video**, or a clip.
