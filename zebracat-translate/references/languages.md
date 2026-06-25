# Languages & Locale Reference

Zebracat translates and dubs into 170+ languages. Always validate the user's input against the live supported list before submitting.

**MCP:** `list_languages()`
**CLI:** `zebracat video translate --to <name>` validates on submit; list supported names where the CLI exposes them.

---

## Matching user input to a canonical name

Users say "Spanish"; the engine wants an exact canonical string (often with a region). Map loosely, then confirm when ambiguous:

| User says | Default canonical | Confirm if… |
|-----------|-------------------|-------------|
| Spanish | Spanish (Spain) | audience is Latin America → Spanish (Mexico) / (Latin America) |
| Portuguese | Portuguese (Portugal) | audience is Brazil → Portuguese (Brazil) |
| Chinese | Chinese (Mandarin, Simplified) | Hong Kong → Cantonese (Traditional); Taiwan → Taiwanese Mandarin (Traditional) |
| French | French (France) | Canada → French (Canada) |
| Arabic | Arabic (Modern Standard) | a specific country variant is requested |
| English | English (US) | UK/AU audience → the matching variant |

When no canonical match is found, present the 2–3 closest supported names and let the user pick.

## Regional variants matter

Spanish (Spain) vs Spanish (Mexico), Portuguese (Portugal) vs (Brazil), and the Chinese variants are **not** interchangeable — vocabulary, intonation, and rhythm differ, and audiences notice. Default to the user's stated audience region; if unspecified for these languages, ask once.

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
