# Script Craft — reference

Full details for `zebracat-script`. Read this when you need the exact fields, enums, or
request/response shapes.

## Endpoint (REST)

`POST https://api.zebracat.ai/api/v1/public/script_generator`

**Synchronous** — the script is returned in the response body; there is no task to poll.

### Request body

| Field | Required | Type | Default | Notes |
|-------|----------|------|---------|-------|
| `idea` | ✅ | string | — | The idea/prompt to write a script about. |
| `language` | — | string | `english` | e.g. `english`, `spanish`, `german`. |
| `duration` | — | int | `30` | Target spoken length in seconds. One of `15, 30, 60, 120, 180`. Controls script length. |
| `mood` | — | string | `happy` | Tone of the script (see moods below). |
| `prompt_style` | — | string | auto | Narration style. Browse `GET /api/public/video/prompt_styles`. |

### Response

```json
{ "script": "Ever feel like the day disappears? Here are three tips to take it back. First, ..." }
```

Feed the returned `script` straight into `POST /api/public/video/script` (that's what
zebracat-video does) to turn it into a video.

### Example (REST)

```bash
curl -sS https://api.zebracat.ai/api/v1/public/script_generator \
  -H "X-API-KEY: $ZEBRACAT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"idea":"3 productivity tips for remote engineers","duration":30,"mood":"happy"}'
```

## Duration → shape

| Duration | Best for | Rough word count (≈2.5 words/sec) |
|----------|----------|-----------------------------------|
| 15s | Hooks, teasers, single-point social posts | ~35–40 |
| 30s | Standard social / ad / promo | ~70–80 |
| 60s | Explainers, product overviews | ~140–160 |
| 120s | Tutorials, deeper stories | ~280–320 |
| 180s | Long-form education | ~420–470 |

The API enforces the enum — don't send arbitrary seconds. If the user wants "about 45 seconds",
pick the nearest valid value (30 or 60) and say so.

## Moods

Common moods: `happy`, `calm`, `serious`, `energetic`, `inspirational`, `dramatic`,
`professional`. The API exposes the authoritative list; if a mood is rejected, fall back to
`happy` and mention the adjustment.

## Prompt styles (narration voice)

`prompt_style` shapes *how* the script is written — e.g. `storytime` (narrative arc),
news/anchor (factual, punchy), conversational (casual, direct). Browse the live list:

```bash
curl -sS https://api.zebracat.ai/api/v1/public/video/prompt_styles -H "X-API-KEY: $ZEBRACAT_API_KEY"
```

Leave `prompt_style` unset to let Zebracat auto-pick from the idea and mood.

## Transport notes

- **MCP:** `generate_script(idea, language?, duration?, mood?, prompt_style?)` — returns the script text.
- **CLI:** `zebracat script "<idea>" [--duration N] [--mood M] [--language L]` — see `--help` for exact flags.
- **REST:** as above. Auth via `X-API-KEY` (pay-as-you-go) or `Authorization: Bearer` (account credit).

## Errors

| Status | Meaning | Fix |
|--------|---------|-----|
| 400 | Validation (missing `idea`, invalid `duration`/`mood`) | Fix the field; `idea` is mandatory, `duration` must be in the enum. |
| 401 | Invalid/missing API key | Check `ZEBRACAT_API_KEY` or the MCP OAuth session. |
| 402 | Insufficient balance | Script generation costs a small amount; top up or use plan credits via MCP. |
