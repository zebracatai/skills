# Script Craft — reference

Full details for `zebracat-script`. Read this when you need the exact fields or shapes. The
authoritative, always-current version: https://api.zebracat.ai/docs/guides/studio.md and
https://api.zebracat.ai/docs/reference/studio.md.

## Endpoints (REST)

| Call | What |
|------|------|
| `GET /api/v1/public/studio/scripts/options` | languages, tones, formats, the length rules for this account |
| `POST /api/v1/public/studio/scripts` | start a script → `202 {job_id, status}` |
| `GET /api/v1/public/studio/scripts/{job_id}` | the job; when `status` is `done`, `result` holds the script |

Writing takes a few seconds: poll every 2-3 s.

### Request body

| Field | Required | Notes |
|-------|----------|-------|
| `idea` | ✅ | What the script is about: a topic, a brief, or rough notes. |
| `seconds` | — | Target spoken length. The options call gives the account's maximum. |
| `language` | — | A value from the options' languages (default: English). |
| `tone` | — | A tone id from the options, or `auto`. |
| `format` | — | A format id from the options, or `auto` (narrated, dialogue, …). |

### Result

```json
{
  "status": "done",
  "result": {
    "title": "Three hearts, nine brains",
    "script_view": {"logline": "…", "beats": [{"n": 1, "kind": "opener", "seconds": 4, "lines": [{"speaker": "Narrator", "text": "…"}]}]},
    "plain_text": "…the script with speaker names…",
    "narration_text": "…only the words to be spoken…"
  }
}
```

- `narration_text` is what a voice reads: hand it to `zebracat-studio` (voice-over) or to
  zebracat-video as `input_kind: "voiceover_script"`.
- `plain_text` keeps who says what: hand it to zebracat-video as `input_kind: "script"` for a
  video where people speak.

### Example (REST)

```bash
curl -sS -X POST https://api.zebracat.ai/api/v1/public/studio/scripts \
  -H "X-API-KEY: $ZEBRACAT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"idea":"3 productivity tips for remote engineers","seconds":30}'
# → {"job_id": "…", "status": "writing", …}
curl -sS https://api.zebracat.ai/api/v1/public/studio/scripts/<job_id> -H "X-API-KEY: $ZEBRACAT_API_KEY"
```

## Seconds → shape

| Seconds | Best for | Rough word count (≈2.5 words/sec) |
|---------|----------|-----------------------------------|
| 15 | Hooks, teasers, single-point social posts | ~35–40 |
| 30 | Standard social / ad / promo | ~70–80 |
| 60 | Explainers, product overviews | ~140–160 |
| 120 | Tutorials, deeper stories | ~280–320 |
| 180 | Long-form education | ~420–470 |

## Hooks

For a stronger opening line, `POST /api/v1/public/studio/hooks` with the script answers several
hooks, each with the script rewritten to open on it (MCP `write_hooks`, CLI `zebracat studio hooks`).
See zebracat-studio.

## Transport notes

- **MCP:** `write_script(idea, seconds?, language?)` → `get_script(job_id)`.
- **CLI:** `zebracat studio script "<idea>" [--seconds N] [--language L] --wait`.
- **REST:** as above. Auth via `X-API-KEY` (API dollars) or `Authorization: Bearer` (account).
- Scripts are free, within an allowance per account (hourly and daily); over it the API answers
  `429 studio_allowance` with `retry_after_s`.

## Legacy

`POST /api/v1/public/script_generator` (`{idea, duration, mood, prompt_style}` → `{script}`,
MCP `generate_script`, CLI `zebracat script`) still works and, on the v2 engine, runs the same
writer. Prefer `/studio/scripts` for new work.

## Errors

| Status | Meaning | Fix |
|--------|---------|-----|
| 400 | Validation (missing `idea`, a value not in the options) | Fix the field; read the options call. |
| 404 | Studio is not open on this server | Use the legacy `script_generator`. |
| 429 `studio_allowance` | Allowance used up | Wait `retry_after_s`. |
