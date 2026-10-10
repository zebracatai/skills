# Troubleshooting & Known Issues — zebracat-video

Error → cause → action. Covers all three transports (MCP, CLI, REST).

---

## Transport & auth

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Skill can't reach Zebracat at all | No transport detected | Connect MCP (`https://mcp.zebracat.ai/mcp/`) or install the CLI + `zebracat auth login` with an API key. |
| Using CLI/REST when the user wanted plan credits | `ZEBRACAT_API_KEY` is set, which forces the API-key path | `unset ZEBRACAT_API_KEY`, reconnect MCP, re-detect. |
| Using MCP when the user wanted pay-as-you-go | No `ZEBRACAT_API_KEY` set | `export ZEBRACAT_API_KEY=sk-…` and ensure the CLI is installed. |
| MCP tools listed but auth fails | OAuth consent not completed | Trigger any MCP call to open the browser consent flow, then retry. |
| CLI: `zebracat auth status` shows `"authenticated": false` | No key saved or set | `zebracat auth login` (paste your API key) or `export ZEBRACAT_API_KEY=sk-…`. |

> Hard rule: `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP. See [CLAUDE.md](../CLAUDE.md).

## REST equivalents (REST mode only)

When neither MCP nor CLI is present, POST to the public API. The body mirrors the MCP tool arguments.

```bash
curl -sS https://api.zebracat.ai/api/v1/public/videos/from-idea \
  -H "X-API-KEY: sk-…" \
  -H "Content-Type: application/json" \
  -d '{"idea":"…","video_type":"ai_video","duration":30,"language":"english","aspect_ratio":"vertical","should_render":true}'
```
Account-credit auth instead of a key: `-H "Authorization: Bearer <oauth-token>"`. Poll status: `GET …/public/videos/<task_id>`. Use the exact endpoint paths from the API docs; the bodies match the MCP tool fields.

## Generation errors

| Symptom | Likely cause | Action |
|---------|--------------|--------|
| `402` / insufficient credits | Plan out of credits (MCP/OAuth) or balance empty (API key) | Tell the user; check `get_balance()` / `zebracat account usage`. Point to billing. |
| `401` / `403` | Bad or missing key / not your resource | Re-check `ZEBRACAT_API_KEY` or re-auth; confirm the `task_id` belongs to this account. |
| `400` blog/audio "not accessible" | URL is auth-walled, 404, or wrong MIME | Ask for a public URL, or download → use a different entry. Never fabricate content from an unreachable source. |
| Status `failed` early | Bad brief (empty idea, unsupported combo) | Re-check the entry args; retry once with a corrected brief. Don't resubmit the identical payload. |
| Video generated but wrong language | `language` not set / mismatched voice | Set `language=<lang>` and a `voice_id` that speaks it. Regenerate. |
| Stylized look ignored | `visual_style` set on `stock_footage` | Switch `video_type` to `ai_video`; stock is real footage. |
| Avatar video has no presenter / wrong face | Missing or stale `avatar_id` | Read fresh ids from `AVATAR-<NAME>.md`; if absent, run zebracat-avatar. |

## Polling & stuck jobs

Status flow: `queued` → `processing` → `rendering` → `completed` | `failed`.

Cadence when not using `--wait`:

| Age of job | Poll interval |
|------------|---------------|
| 0–1 min | every 30s |
| 1–5 min | every 60s |
| > 5 min | one "taking longer than usual" note, keep polling at 60s |
| > ~20 min stuck at same status | surface to the user; offer `cancel_video` / `zebracat video cancel <id>` |

Prefer `--wait` (CLI) — it blocks and returns the final result, or a resumable `task_id` on timeout. Never re-submit a job that's still running; resume polling instead.

## should_render / draft vs final

- `should_render=false` (or omitting `--render`) returns an **editable draft** — faster, cheaper, no final MP4 yet.
- `should_render=true` / `--render` renders the final MP4.
- Default: draft first for review, then render after approval — unless the user said "just make it."

## Delivery

- No output URL on a `completed` job → re-fetch status; if still missing, use `zebracat video download <task_id>`.
- Inline playback wanted → download the MP4 to `/tmp/zebracat/` and attach it, then clean up after sending.

## Quality checklist (before blaming the engine)

1. Hook in the first 3 seconds?
2. One topic only?
3. Duration right-sized to the script (~2.5 words/sec)?
4. Aspect matches the target platform?
5. Voice-over field free of stage directions?
6. Style compatible with the chosen video_type?

Most "bad video" reports trace back to one of these, not the pipeline.
