---
version: 1.0.0
name: zebracat-voice
description: |
  Browse, preview, and pick a Zebracat voice — or clone a voice from a sample — and choose its
  tone, for use in Zebracat videos and avatars.
  Use when: (1) "what voices are available", "preview voices", "pick a voice for my video";
  (2) "clone my voice", "use my own voice", "make a voice from this recording/sample";
  (3) "I want a <calm/energetic/deep> voice", "choose a tone"; (4) selecting a voice_id before
  generating a video.
  Returns a voice_id (and tone) — pass it to zebracat-video (voice_id) or save it into an
  AVATAR-<NAME>.md via zebracat-avatar.
  Chain signal: after picking/cloning a voice, offer to make a video (zebracat-video) or attach
  it to an avatar (zebracat-avatar).
  NOT for: generating videos (use zebracat-video), avatar selection (use zebracat-avatar), or
  translating videos (use zebracat-translate).
argument-hint: "[tone or 'clone']"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Voice 🦓

Find the right voice for a video: browse and preview Zebracat's voice library, pick a tone, or clone the user's own voice from a sample. The output is a `voice_id` that zebracat-video and zebracat-avatar consume.

## Skill Announcement

> 🦓 **Using: zebracat-voice** — finding your voice

## Files & Paths

| Operation | Path | Purpose |
|-----------|------|---------|
| Read/Write | `AVATAR-<NAME>.md` | Save a chosen/cloned `voice_id` into a character (optional) |
| Temp write | `/tmp/zebracat/` | Voice preview audio + the clone sample, deleted after the session |
| Remote upload | Zebracat (clone) | The user's voice sample, uploaded only when they provide it |

## UX Rules

1. **Be concise.** No voice IDs or payloads in chat — describe the voices ("a warm, calm female voice").
2. **No internal jargon / no transport narration.**
3. **Preview before choosing.** Play 2–3 candidates; never auto-pick.
4. **Stop at the choice.** Wait for the user to pick.
5. **Cloning needs explicit consent + a real sample** — never clone without the user actively providing their own voice and confirming it's theirs to use.

## Language Awareness

Detect the user's language; reply in it. When listing voices, filter by the target **video language** so candidates actually speak it. Tone words map to natural language; keep `voice_id` values as-is.

## Transport Detection (pick one silently)

Same ladder as the suite — full version in [CLAUDE.md](../CLAUDE.md):

1. **CLI (API key)** → 2. **REST (API key)** → 3. **MCP (OAuth, preferred)** → 4. **CLI (OAuth)** → 5. tell the user how to connect.

> **Hard rule:** `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP OAuth.

## Workflow

### Phase 0 — Browse or clone?

- **Browse / pick** (default) → Phase 1.
- **Clone** ("use my own voice", "clone this recording") → Phase 2.

### Phase 1 — Browse & preview

List voices, filtered to the target language and (if stated) gender/tone:

**MCP:** `list_voices(language=<lang>, gender=<optional>)`
**CLI:** `zebracat voice list --human`

1. Read the desired tone from the user (or infer from the video brief).
2. Narrow to 2–3 strong candidates that match tone + language.
3. **Preview each** — download the preview audio to `/tmp/zebracat/` and play it inline (or share the preview URLs).
4. ⛔ **STOP.** Wait for the user to pick. Don't auto-select.

Default to Zebracat (Runware) voices. Only auto-suggest a cloned/premium voice if the user asked for it.

📖 **Tone vocabulary, gender/age/energy filters, language matching → [references/tones.md](references/tones.md)**

### Phase 2 — Clone a voice

Clone the user's own voice from a sample.

1. **Consent + sample.** Ask the user to provide a clean recording of **their own** voice and confirm they have the right to use it. A good sample is 30–60s, clear, single speaker, minimal background noise.
2. **Submit the clone:**

**MCP:** the voice-clone tool (provide the sample audio per your transport's input format).
**CLI:** `zebracat voice clone` — pass the sample file; follow `zebracat voice clone --help` for the exact flags.

3. **Confirm + preview** the cloned voice, then treat it like any other `voice_id`.

📖 **Sample requirements, quality tips, consent, troubleshooting → [references/voice-cloning.md](references/voice-cloning.md)**

### Phase 3 — Pick tone

Tone shapes delivery (pace, warmth, energy). Confirm the tone alongside the voice — e.g. "calm and reassuring", "energetic and upbeat", "authoritative". Pass tone through to the video brief (`mood`) so the delivery matches. Some voices read better in some tones; preview before committing.

### Phase 4 — Hand off

Return the `voice_id` (and tone). Then offer:
- *"Want to make a video with this voice?"* → **zebracat-video** (`voice_id=<id>`).
- *"Want to attach it to a presenter?"* → **zebracat-avatar** (save into `AVATAR-<NAME>.md`).

If the user is mid-way through a video and just needed a voice, hand the `voice_id` straight back to zebracat-video.

## Best Practices

- **Preview, never assume.** Two voices that read similar on paper sound very different.
- **Match the language first**, then tone — a perfect tone in the wrong language is useless.
- **Clone responsibly.** Own-voice + consent + a clean sample. Decline if the sample isn't the user's own voice.
- **Tone follows content.** Calm for wellness/education, high-energy for ads/social, authoritative for finance/B2B.
- **Default Runware.** Use Zebracat's standard voices unless the user explicitly wants their own.
