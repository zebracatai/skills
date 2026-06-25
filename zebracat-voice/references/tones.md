# Tone & Voice Selection Reference

How to pick a voice that fits the video — by language first, then tone, energy, and timbre.

---

## Selection order

1. **Language** — the voice must speak the video's language. Filter `list_voices(language=<lang>)` before anything else. A great tone in the wrong language is useless.
2. **Gender / age feel** — match the brand and audience.
3. **Tone** — the emotional register (below).
4. **Energy / pace** — calm and slow vs fast and punchy.
5. **Timbre** — warm vs bright, deep vs light. Decide by ear, not by label — preview.

## Tone vocabulary

| Tone | Feels like | Good for |
|------|-----------|----------|
| Calm / reassuring | A trusted guide | Wellness, healthcare, education, meditation |
| Warm / friendly | A helpful friend | DTC, lifestyle, onboarding, explainers |
| Energetic / upbeat | A hype host | Ads, social, product launches, promos |
| Authoritative / confident | An expert | Finance, B2B, news, thought leadership |
| Playful / quirky | A fun creator | Comedy, youth brands, casual social |
| Cinematic / dramatic | A movie trailer | Brand films, story-driven, premium ads |

Pass the chosen tone through to the video brief as `mood` so the delivery, music, and pacing line up.

## Matching tone to content

- **Don't fight the style.** A hype tone over a soft Ghibli look clashes — align tone, style, and mood.
- **Match the platform.** Social/short-form leans energetic; LinkedIn/B2B leans authoritative; wellness leans calm.
- **One tone per video.** Switching registers mid-video feels off unless it's a deliberate beat.

## Previewing

Always preview 2–3 candidates before the user commits:

- Download each preview to `/tmp/zebracat/` and play it inline, or share the preview URLs.
- Present them by description ("Option 1: warm, mid-energy female; Option 2: deeper, calm male"), not by id.
- ⛔ Wait for the user to pick. Never auto-select.

## Filters

`list_voices` supports filtering — at minimum `language` and `gender`. Use them to narrow a large catalog down to a relevant shortlist instead of dumping the whole library. For a specific feel (age, energy), narrow further by listening and discarding mismatches.

## Defaults

Default to Zebracat's standard (Runware) voices — they're instant, multilingual, and cover every tone above. Reach for a **cloned** voice only when the user wants their own voice (see voice-cloning.md). Reserve premium/specialty voices for when the user explicitly asks.
