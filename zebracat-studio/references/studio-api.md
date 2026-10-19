# Studio API — reference

Full details for `zebracat-studio`. The always-current versions:
https://api.zebracat.ai/docs/guides/studio.md (guide) and
https://api.zebracat.ai/docs/reference/studio.md (every field, generated from the schema).

Base: `https://api.zebracat.ai/api/v1/public`. Auth: `X-API-KEY: sk-…` (API dollars) or
`Authorization: Bearer <oauth-token>` (plan credits).

## Endpoints

| Call | Body | Answer |
|------|------|--------|
| `GET /studio/hooks/options` | — | languages, styles |
| `POST /studio/hooks` | `{script \| topic, language?, …}` | `{hooks: [...], hooked_scripts?}` (at once) |
| `POST /studio/hooks/variations` | the same + the hook to vary | more hooks |
| `GET /studio/voices/options` | — | voices, languages, price per length, length limits |
| `POST /studio/voices` | `{script, voice_id, language?, tone?, speed?, dry_run?}` | `202 {job_id}`; `dry_run` → `{quote}` |
| `GET /studio/voices/{job_id}` | — | `{status, audio_url, asset_id, …}` |
| `GET /studio/voices` | `?limit=&cursor=` | `{data, next_cursor}` |
| `GET /studio/media/models` | — | image and clip models, with prices |
| `POST /studio/images` | `{prompt, model?, aspect?, count?, reference_urls?}` | `202 {job_id}` |
| `POST /studio/clips` | `{prompt, model?, seconds, aspect?, image_url?, dry_run?}` | `202 {job_id}`; `dry_run` → `{quote}` |
| `GET /studio/media/{job_id}` | — | `{status, result: {urls…, asset_id}}` |

Every POST that creates a job takes an `Idempotency-Key` header: a retry with the same key returns
the same job.

## Examples

```bash
# a voice-over, priced first
curl -sS -X POST https://api.zebracat.ai/api/v1/public/studio/voices \
  -H "X-API-KEY: $ZEBRACAT_API_KEY" -H "Content-Type: application/json" \
  -d '{"script":"Octopuses have three hearts.","voice_id":"21m00Tcm4TlvDq8ikWAM","dry_run":true}'

# a 5-second clip, priced first
curl -sS -X POST https://api.zebracat.ai/api/v1/public/studio/clips \
  -H "X-API-KEY: $ZEBRACAT_API_KEY" -H "Content-Type: application/json" \
  -d '{"prompt":"An octopus opening a jar underwater, macro shot","seconds":5,"aspect":"vertical","dry_run":true}'
```

## Errors

| `code` | Meaning | Action |
|--------|---------|--------|
| `api_key_billing_pending` (402) | Paid Studio calls with an API key are not live yet | Use MCP/OAuth (plan credits), or quote only. |
| `insufficient_funds` (402) | Not enough credits / dollars | Show the quote; point to billing. |
| `studio_allowance` (429) | Hourly/daily allowance used | Wait `retry_after_s`. |
| 404 on every `/studio/*` | Studio is not open on this server | Offer zebracat-video / zebracat-image. |

## Webhooks

Jobs started through the API fire `studio.job.completed` / `studio.job.failed` with
`{job_id, tool, result | error}` to a registered webhook.
