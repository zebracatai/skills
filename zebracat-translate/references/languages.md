# Languages & Locale Reference

Zebracat translates and dubs into 25+ languages (28 today). Always validate the user's input against the live supported list before submitting.

**MCP:** `list_translate_languages()`
**CLI:** `zebracat video translate --to <name>` validates on submit; list supported names where the CLI exposes them.

---

## Matching user input to a code

`target_language` is an ISO 639-1 code from the live list: `ar bg cs da de el en es fi fr hi hr id it ja ko ms nl pl
pt ro ru sk sv ta tr uk zh` today. Map the user's words to the code ("Spanish" → `es`, "Mandarin" → `zh`, "Brazilian
Portuguese" → `pt`). There are no regional variants: one code per language. When the language is not in the list,
say so and offer the 2–3 closest supported ones.

## Right-to-left (RTL) languages

Arabic, Hebrew, Urdu, and Persian render captions right-to-left. If the source video has burned-in lower-third graphics or on-screen text, RTL captions can collide with them. For RTL targets with busy on-screen layouts, warn the user and consider captions off (audio dub only).

## Duration / pacing across languages

Languages expand and compress. Roughly:

- **Compress (run shorter):** English → Chinese / Japanese / Korean.
- **Expand (run longer):** German → English, Japanese → English; English → Arabic / Spanish.

The engine fits the translated speech to the video. On high-compression or high-expansion pairs, pacing may feel slightly off; this is inherent to dubbing, not a defect. Flag it for sensitive content.

## Captions

`enable_caption=true` / `--render` with captions burns subtitles into the dubbed video. Pros: plays anywhere, no sidecar file. Cons: fixed style, can collide with existing on-screen text. Default ON for talking-head and corporate; consider OFF when the source already has heavy on-screen text or for RTL targets with busy layouts.

## Batching

Submit one job per language and deliver each as it finishes. Quote the cost as source-minutes × language count in Phase 1. For first-time users or long videos, suggest translating one language first as a quality check before committing the whole batch.

## What translation does NOT do

- It does not re-edit or restructure the video — visuals and timing are preserved.
- It does not improve source quality (muffled audio, low res carry over).
- It does not create new content — for a new video in another language, use **zebracat-video** with a script written in that language instead.
