# Voice Cloning Reference

How to clone the user's own voice into a reusable Zebracat `voice_id`.

---

## Consent first (non-negotiable)

Only clone a voice that the user **owns** or has explicit rights to use. Before cloning:

- Confirm the sample is the user's **own** voice (or a voice they're authorized to clone).
- If there's any doubt it's their voice, decline and offer a catalog voice instead.

This is an ethics + policy line, not a soft guideline. Never clone a third party's voice from a random clip.

## A good sample

| Requirement | Why |
|-------------|-----|
| 30–60 seconds | Enough range for the clone to capture timbre and cadence |
| Single speaker | Multiple voices confuse the clone |
| Clean audio | Background noise, music, and echo degrade the result |
| Natural speech | Conversational reading beats robotic word-lists |
| Consistent mic/room | Avoid switching devices or rooms mid-sample |

A phone voice-memo in a quiet room usually works. A noisy café recording usually doesn't.

## Submitting the clone

**MCP:** use the voice-clone tool, providing the sample audio in the input format your transport expects (URL, asset, or inline).

**CLI:**
```bash
zebracat voice clone --help   # confirm the exact flags first
zebracat voice clone --file /path/to/sample.wav --name "My Voice"
```

Cloning is asynchronous — it may take a short while. Confirm the clone is ready, then preview it before using it in a video.

## After cloning

- Preview the cloned voice and confirm it sounds right.
- Treat the returned `voice_id` like any catalog voice — pass it to zebracat-video or save it into an `AVATAR-<NAME>.md`.
- If the user clones once, reuse the `voice_id` for every future video — don't re-clone each time.

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Clone sounds robotic / off | Poor sample (noise, too short, multi-speaker) | Re-record per the sample requirements; resubmit. |
| Upload fails | Auth-walled URL, wrong format, too large | Use a clean local file in a supported audio format; retry. |
| Clone "not ready" | Asynchronous processing | Wait for it to finish; confirm readiness before generating. |
| Wrong language output | Voice cloned from one language, used for another | Cloned voices speak best in the sample's language; for other languages, use a catalog voice that speaks it. |
| `402` insufficient credits | Plan/balance empty | Check `get_balance()` / `zebracat account usage`; point to billing. |

## When to clone vs pick a catalog voice

- **Clone** when the brand IS the person (founder-led content, personal creators, a signature spokesperson).
- **Pick a catalog voice** for speed, for multi-language needs, or when no specific person's voice is required. Catalog (Runware) voices are instant and cover many languages and tones.
