---
version: 1.1.0
name: zebracat-image
description: |
  Generate standalone AI images from a text prompt with Zebracat — thumbnails, hero shots,
  reference frames, social graphics, or assets. Pick a visual style and aspect, get image URLs back.
  Use when: (1) "generate an image of X", "make a thumbnail", "create a hero image", "AI image
  of ..."; (2) "I need a 9:16 / 16:9 / square graphic"; (3) producing a still asset rather than
  a video; (4) a reference frame to steer a later video.
  Returns one or more image URLs. Chain signal: if the user actually wants a moving clip, use
  zebracat-video (Moving AI Images / AI Video). If they want a presenter face, use zebracat-avatar.
  NOT for: generating videos (use zebracat-video), avatars/faces (use zebracat-avatar), or
  editing an existing video.
argument-hint: "[prompt] [aspect] [style]"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Image 🦓

Generate a still image from a prompt — a fast, single-call way to make thumbnails, hero shots,
social graphics, or reference frames. Not a video: the output is image URLs.

## Skill Announcement

> 🦓 **Using: zebracat-image** — generating your image

## Files & Paths

| Operation | Path | Purpose |
|-----------|------|---------|
| Temp write | `/tmp/zebracat/` | Download generated images for local preview |
| Write | workspace root | Save a chosen image only when the user asks |

## UX Rules

1. **One subject per image.** Multiple subjects → multiple prompts.
2. **Confirm aspect early.** Square (1:1), landscape (16:9), or portrait (9:16) changes composition.
3. **Show the result, offer variations.** If they want tweaks, adjust the prompt or style and regenerate.
4. **Be concise / no transport narration.**

## Language Awareness

Detect the user's language and reply in it. Write the image `prompt` in **English** for the best
model results unless the user needs on-image text in another language — describe the visual, not
narration.

## Transport Detection (pick one silently)

Same ladder as the suite — full version in [CLAUDE.md](../CLAUDE.md):

1. **CLI (API key)** → 2. **REST (API key)** → 3. **MCP (OAuth, preferred)** → 4. **CLI (OAuth)** → 5. tell the user how to connect.

> **Hard rule:** `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP OAuth. Image generation is
> exposed on the CLI and REST; if your MCP toolset has no image tool, use the CLI/REST path.

## Workflow

### Phase 1 — Prompt + aspect + style

- **prompt** (required) — a vivid description of the image. Concrete subject, setting, lighting, mood.
- **aspect** → pixel size:
  - Square `1024×1024` (default) · Landscape `1024×576` (16:9) · Portrait `576×1024` (9:16)
- **style_id** (optional) — a visual style. Browse styles and pick one that matches the vibe.

### Phase 2 — Generate

**CLI:** `zebracat image "<prompt>" --width 1024 --height 1024 [--style <id>]` (see `zebracat image --help`)
**REST:** `POST /api/public/generate_image` with `{ "prompt": "...", "width": 1024, "height": 1024, "style_id": <id?> }`
**MCP:** if an image-generation tool is present in `mcp__zebracat__*`, use it; otherwise use CLI/REST.

Returns image URL(s). Download to `/tmp/zebracat/` to preview inline.

📖 **Aspect presets, style browsing, prompt patterns, attaching to a project → [references/image-styles.md](references/image-styles.md)**

### Phase 3 — Review & iterate

Show the image. Offer quick variations: change style, adjust lighting/composition wording, or
switch aspect. Regenerate on request — each generation is a single fast call.

### Phase 4 — Hand off

Offer the natural next step:
- *"Want this to move?"* → **zebracat-video** (Moving AI Images animates a still).
- *"Use it as a reference for a video?"* → pass the image into zebracat-video as a reference.

## Best Practices

- **Be specific.** "A minimalist purple product shot on a matte black surface, soft rim light,
  centered" beats "a nice product image."
- **Match aspect to destination.** 9:16 for TikTok/Reels/Shorts, 16:9 for YouTube/landing pages, 1:1 for feed posts.
- **Style before re-prompting.** Often a style change fixes the look faster than rewording.
- **Keep text out of prompts** unless you truly need baked-in words — AI text can render imperfectly.
