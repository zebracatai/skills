# Image Generation — reference

Full details for `zebracat-image`. Read this for exact fields, aspect presets, and style browsing.

## Endpoint (REST)

`POST https://api.zebracat.ai/api/v1/public/generate_image`
(alias: `POST https://api.zebracat.ai/api/v1/public/images/generate` — identical behavior)

### Request body

| Field | Required | Type | Default | Notes |
|-------|----------|------|---------|-------|
| `prompt` | ✅ | string | — | Text description of the image to generate. |
| `style_id` | — | int/string | — | ID of a visual style to apply. Browse the style list first. |
| `width` | — | int | `1024` | Image width in pixels (used when no project). |
| `height` | — | int | `1024` | Image height in pixels (used when no project). |
| `for_project` | — | id | — | Attach the image into an existing project instead of a standalone still. |
| `duration` | — | number | — | Required only when `for_project` is provided (slot duration in the video). |

### Response

Returns the generated image URL(s). Download to `/tmp/zebracat/` for inline preview.

### Example (REST)

```bash
curl -sS https://api.zebracat.ai/api/v1/public/generate_image \
  -H "X-API-KEY: $ZEBRACAT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"A minimalist purple product shot on matte black, soft rim light, centered","width":1024,"height":1024}'
```

## Aspect presets

The API maps aspect to pixel dimensions. Use these standard sizes:

| Aspect | Size | Use for |
|--------|------|---------|
| Square 1:1 | `1024×1024` | Feed posts, avatars, generic assets (default) |
| Landscape 16:9 | `1024×576` | YouTube thumbnails, landing pages, slides |
| Portrait 9:16 | `576×1024` | TikTok / Reels / Shorts covers, stories |

Pass `width`/`height` explicitly to control the aspect. Pick the destination first, then the size.

## Browsing styles

`style_id` applies one of Zebracat's visual styles (cinematic, anime, 3D, watercolor, etc.).
List the available styles and match one to the requested vibe:

```bash
curl -sS https://api.zebracat.ai/api/v1/public/video/styles -H "X-API-KEY: $ZEBRACAT_API_KEY"
```

(MCP: `list_visual_styles`. CLI: `zebracat style list --human`.) Leave `style_id` unset for a
sensible default look.

## Prompt patterns that work

- **Subject + setting + light + framing:** "A red running shoe on wet asphalt at dawn, dramatic
  side light, low-angle close-up."
- **Product shots:** name the surface, background color, and lighting; add "studio, centered".
- **Backgrounds/hero:** describe mood and negative space so text can overlay later.
- **Consistency:** reuse the same descriptive anchors across images meant to look like a set.

## Attaching to a project

To place a generated image directly into a video project, pass `for_project=<project_id>` and a
`duration`. Without `for_project`, you get a standalone still you can download or hand to
zebracat-video as a reference.

## Errors

| Status | Meaning | Fix |
|--------|---------|-----|
| 400 | Missing `prompt`, or missing `duration` when `for_project` is set | Provide the required field. |
| 401 | Invalid/missing API key | Check `ZEBRACAT_API_KEY` or the MCP OAuth session. |
| 402 | Insufficient balance | Top up or use plan credits via MCP. |
| 404 | Project or style not found | Verify `for_project` / `style_id`. |
