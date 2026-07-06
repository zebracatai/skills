# Brand Kit — reference

Full details for `zebracat-brand`. Read this for exact endpoints, fields, and multipart examples.

## Endpoints (REST)

Base: `https://api.zebracat.ai/api/v1/public/brands`

| Method | Purpose | Body |
|--------|---------|------|
| `GET` | List the user's brand kits | — |
| `POST` | Create a brand kit | multipart form |
| `PUT` / `PATCH` | Update a brand kit (`PATCH` = partial) | multipart form incl. `id` |
| `DELETE` | Delete a brand kit | `id` |

A brand kit includes: **name, logo(s), colors, fonts, voice/tone**, and other brand identity assets.

## List brands

```bash
curl -sS https://api.zebracat.ai/api/v1/public/brands -H "X-API-KEY: $ZEBRACAT_API_KEY"
```

MCP: `list_brands()`. CLI: `zebracat brand list --human`.

Always list first and reuse a matching brand instead of creating a duplicate.

## Create a brand (multipart)

```bash
curl -sS -X POST https://api.zebracat.ai/api/v1/public/brands \
  -H "X-API-KEY: $ZEBRACAT_API_KEY" \
  -F "name=Acme" \
  -F "colors=#7C3AED,#111111" \
  -F "fonts=Inter" \
  -F "voice=confident, warm, concise" \
  -F "logo=@/path/to/logo.png"
```

- **name** — required; the brand name.
- **logo** — file upload (send the file with `-F "logo=@path"`). Multiple logos may be supported.
- **colors** — brand colors as hex; primary first.
- **fonts** — font name(s) or font file(s).
- **voice** — the brand's tone of voice, described in a short phrase.

Field names can vary slightly by account — if a create call 400s on a field, list an existing
brand (`GET`) to see the exact serialized shape, then mirror it.

## Update a brand (multipart)

```bash
curl -sS -X PATCH https://api.zebracat.ai/api/v1/public/brands \
  -H "X-API-KEY: $ZEBRACAT_API_KEY" \
  -F "id=123" \
  -F "colors=#7C3AED,#F5F5F5"
```

`PUT` replaces, `PATCH` updates only the provided fields. Always pass `id`.

## Delete a brand

```bash
curl -sS -X DELETE https://api.zebracat.ai/api/v1/public/brands \
  -H "X-API-KEY: $ZEBRACAT_API_KEY" -F "id=123"
```

## Reusing a brand in a video

Once a brand exists, hand its id to zebracat-video so the video inherits the brand's colors,
logo, fonts, and tone. Save a `BRAND-<NAME>.md` at the workspace root for cross-session reuse:

```
# BRAND-Acme
Brand ID: 123
Colors: #7C3AED (primary), #111111 (secondary)
Fonts: Inter
Voice: confident, warm, concise
```

## Conventions

- **Colors** — always hex, comma-separated, primary first.
- **Assets** — only upload files the user provides and owns.
- **Voice/tone** — one short phrase (e.g. "confident, warm, concise"); carries into the video `mood`.

## Errors

| Status | Meaning | Fix |
|--------|---------|-----|
| 400 | Missing/invalid field (e.g. no `name`, bad `id`) | Fix the field; `GET` an existing brand to see the exact shape. |
| 401 | Invalid/missing API key | Check `ZEBRACAT_API_KEY` or the MCP OAuth session. |
| 404 | Brand not found (update/delete) | Verify the `id` via `GET /brands`. |
