---
version: 1.1.0
name: zebracat-brand
description: |
  Set up and manage a Zebracat brand kit — name, logo, colors, fonts, and voice/tone — so every
  video comes out on-brand. Browse existing brands, create a new one, or update one, then reuse it.
  Use when: (1) "set up my brand", "create a brand kit", "add our logo and colors", "make videos
  on-brand"; (2) "what brands do I have", "update my brand colors/font/logo"; (3) establishing a
  reusable brand identity BEFORE making branded videos.
  Returns a brand (id + identity assets) that zebracat-video reuses so footage, colors, and tone
  match the brand. Chain signal: after a brand is ready, offer to make an on-brand video
  (zebracat-video). If the user says a brand action AND a video action in one request, set up the
  brand first, then hand off.
  NOT for: generating videos (use zebracat-video), designing a presenter/character
  (use zebracat-avatar), or cloning a voice (use zebracat-voice).
argument-hint: "[brand name or 'list']"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Brand 🦓

Give videos a consistent identity. A brand kit bundles the name, logo, colors, fonts, and
voice/tone; zebracat-video reuses it so every video looks and sounds on-brand. Set it up once,
reuse it forever.

## Skill Announcement

> 🦓 **Using: zebracat-brand** — setting up your brand kit

## Files & Paths

| Operation | Path | Purpose |
|-----------|------|---------|
| Read | provided logo/asset paths | Files the user points to for upload (multipart) |
| Write | `BRAND-<NAME>.md` (optional) | Save the brand id + summary for reuse across sessions |

## UX Rules

1. **Reuse before recreate.** Always list existing brands first — don't create a duplicate.
2. **Confirm the essentials, infer the rest.** Name + colors + logo are the core; ask for what's missing.
3. **Assets are the user's.** Only upload logos/fonts the user provides and has the right to use.
4. **Be concise / no transport narration.**

## Language Awareness

Detect the user's language and reply in it. Keep brand values (hex colors, font names, the brand
`name`) verbatim — they are identity data, not translatable copy. Voice/tone can be described in
the user's language but stored as the API expects.

## Transport Detection (pick one silently)

Same ladder as the suite — full version in [CLAUDE.md](../CLAUDE.md):

1. **CLI (API key)** → 2. **REST (API key)** → 3. **MCP (OAuth, preferred)** → 4. **CLI (OAuth)** → 5. tell the user how to connect.

> **Hard rule:** `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP OAuth. Listing brands is exposed
> on MCP (`list_brands`); create/update use the CLI or REST (multipart form).

## Workflow

### Phase 0 — List first

Always start by listing the user's brands:

**MCP:** `list_brands()` · **CLI:** `zebracat brand list --human` · **REST:** `GET /api/public/brands`

- If a matching brand exists → confirm and reuse it (jump to Phase 3).
- If none / the user wants a new one → Phase 1.

### Phase 1 — Gather the kit

Collect the identity pieces (ask for what's missing, one or two at a time):
- **name** (required) — the brand name.
- **logo(s)** — image file(s) the user provides.
- **colors** — primary/secondary as hex (e.g. `#7C3AED`).
- **fonts** — font name(s) or font file(s).
- **voice/tone** — how the brand should sound (e.g. "confident, warm, concise").

### Phase 2 — Create / update

Brand create + update are **multipart form** (files + fields):

**REST (create):** `POST /api/public/brands` (multipart) with `name`, `colors`, `fonts`, logo file(s), `voice`
**REST (update):** `PUT` or `PATCH /api/public/brands` (multipart) with `id` + changed fields
**CLI:** `zebracat brand ...` — see `zebracat brand --help` for create/update flags
**Delete:** `DELETE /api/public/brands` with `id`

📖 **Exact fields, multipart examples, color/font conventions → [references/brand-kit.md](references/brand-kit.md)**

Optionally write a `BRAND-<NAME>.md` at the workspace root (brand id + a one-line summary) so
future sessions reuse it without re-listing.

### Phase 3 — Hand off

With a brand ready, offer: *"Want to make an on-brand video?"* → **zebracat-video**, reusing the
brand so colors, logo, and tone carry through. If the user is mid-way through a video and just
needed the brand, hand the brand id straight back.

## Best Practices

- **One brand, many videos.** Set it up once; never recreate per video.
- **Colors as hex, logos as files.** Keep values precise so renders match exactly.
- **Tone is part of the brand.** A consistent voice/tone matters as much as the logo.
- **Update in place.** When the brand evolves, `PATCH` the existing brand rather than making a new one.
