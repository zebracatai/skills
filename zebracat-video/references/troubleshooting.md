# Troubleshooting & Known Issues — zebracat-video

Error → cause → action. Covers all three transports (MCP, CLI, REST).

---

## Transport & auth

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Skill can't reach Zebracat at all | No transport detected | Connect MCP (`https://mcp.zebracat.ai/mcp/`) or install the CLI + `zebracat auth login`. |
| Using CLI/REST when the user wanted plan credits | `ZEBRACAT_API_KEY` is set, which forces the API-key path | `unset ZEBRACAT_API_KEY`, reconnect MCP, re-detect. |
| Using MCP when the user wanted pay-as-you-go | No `ZEBRACAT_API_KEY` set | `export ZEBRACAT_API_KEY=sk-…` and ensure the CLI is installed. |
| MCP tools listed but auth fails | OAuth consent not completed | Trigger any MCP call to open the browser consent flow, then retry. |
| CLI: `zebracat auth status` non-zero | No login / expired / no key | `zebracat auth login` (OAuth) or `export ZEBRACAT_API_KEY=sk-…`. |

> Hard rule: `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP. See [CLAUDE.md](../CLAUDE.md).

## REST equivalents (REST mode only)

When neither MCP nor CLI is present, call the public API. Full guide:
https://api.zebracat.ai/docs/guides/video-lifecycle.md

```bash
# plan only
curl -sS -X POST https://api.zebracat.ai/api/v1/public/videos \
  -H "X-API-KEY: sk-…" -H "Content-Type: application/json" -H "Idempotency-Key: <uuid>" \
  -d '{"brief":"…","options":{"aspect":"vertical","seconds":30},"auto_generate":false}'
# → 202 {"task_id": "…", "phase": "planning", …}

curl -sS https://api.zebracat.ai/api/v1/public/videos/<task_id> -H "X-API-KEY: sk-…"        # phase
curl -sS https://api.zebracat.ai/api/v1/public/videos/<task_id>/plan -H "X-API-KEY: sk-…"   # the plan
curl -sS https://api.zebracat.ai/api/v1/public/videos/<task_id>/quote -H "X-API-KEY: sk-…"  # the price
curl -sS -X POST https://api.zebracat.ai/api/v1/public/videos/<task_id>/generate \
  -H "X-API-KEY: sk-…" -H "Content-Type: application/json" -d '{}'
```
Account-credit auth instead of a key: `-H "Authorization: Bearer <oauth-token>"`.

## Error codes

Every error is `{"error", "code", "type", "retryable", "hint", …}`. Branch on `code`; the full list
is https://api.zebracat.ai/docs/guides/errors.md.

| `code` | Action |
|--------|--------|
| `api_key_billing_pending` | API-key billing for paid v2 calls is not live yet. Plans and quotes work; to generate, use MCP/OAuth (plan credits). Tell the user once. |
| any 402 with `type: insufficient_funds` (`insufficient_credits`, `insufficient_balance`, …) | Out of credits or dollars. Show the quote and point to billing. |
| `rev_conflict` (409) | The plan changed since you read it: `get_plan`, then retry with the new `rev`. |
| `plan_not_ready` (409) | Still planning: keep polling `get_video`. |
| `too_many_runs` (429) | Too many plans in progress. Wait for one to reach `plan_ready`, then retry. |
| `concurrency_limit` / `daily_limit` (429) | Wait `Retry-After` seconds. |
| `studio_allowance` (429) | Plan-chat allowance used up; wait `retry_after_s`, or use `edit_plan`. |
| `director_v2_too_long` | The plan is longer than the account may generate: `set_duration` to the `shorten_to` seconds. |
| `director_v2_replan` | An old AI Avatar plan: ask `chat_plan` to make it an AI video with the presenter speaking. |
| `clone_topic_required` | A `remix` / `remake_niche` clone needs `topic`: ask the user what their video is about. |
| `already_generating` (409) | Cancel came too late: the video is being generated. |
| `401` / `403` | Bad key, expired login, or another account's task. |

## Generation problems

| Symptom | Likely cause | Action |
|---------|--------------|--------|
| `phase: failed` | `error.code` says which step | Act on the code above; don't resubmit the identical brief. |
| Wrong language | `language` not set / voice in another language | Set `language` and a matching `voice_id`. |
| Wrong person on camera | no `person` upload | Pass the portrait as `uploads: [{url, kind: "person"}]`. |
| Blog/URL "not accessible" | auth-walled or 404 | Ask for a public URL; never invent content from an unreachable source. |

## Polling & stuck jobs

`phase` flow: `planning` → (`needs_input`) → `plan_ready` → `generating` → `rendering` → `completed` | `failed`.

| Phase | Poll interval |
|-------|---------------|
| `planning` | every 5-15 s (a plan takes ~20-60 s) |
| `generating` / `rendering` | every 15-30 s |
| > ~20 min in one phase | surface to the user |

Prefer `--wait` (CLI). Never resubmit a job that is still running; resume polling. Webhooks
(`video.plan_ready`, `video.completed`, …) replace polling for servers.

## should_render

- `should_render: true` (default on `POST /videos`) renders the final MP4.
- `false` stops when the shots are generated; the project stays editable in the editor.

## Delivery

- No output URL on a `completed` job → re-fetch status; if still missing, use `zebracat video download <task_id>`.
- Inline playback wanted → download the MP4 to `/tmp/zebracat/` and attach it, then clean up after sending.

## Quality checklist (before blaming the engine)

1. Hook in the first 3 seconds?
2. One topic only?
3. Duration right-sized to the script (~2.5 words/sec)?
4. Aspect matches the target platform?
5. Voice-over field free of stage directions?
6. `media_type` fits the look (stock is real footage; a drawn style needs `ai_video` or `ai_image_video`)?

Most "bad video" reports trace back to one of these, not the pipeline.
