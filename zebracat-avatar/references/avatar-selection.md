# Avatar Selection & Customization Reference

How to pick, customize, and reuse Zebracat avatars for presenter-led videos.

---

## Two modes

| Mode | What it is | Best for |
|------|-----------|----------|
| **stock** | A ready-made presenter from Zebracat's avatar catalog | Fast setup, brand spokespeople, most use cases |
| **custom** | A presenter customized from your description or a reference photo | A specific look, a real-person likeness, a unique brand character |

Default to **stock** unless the user wants a specific or real-person look. Stock avatars are instant and reliable; custom avatars take longer to set up but are reusable forever once saved.

## Browsing stock avatars

**MCP:** `list_avatars(mode=<optional>)`
**CLI:** `zebracat avatar list --human`

For each candidate the catalog returns a preview image, a name/id, and look attributes. **Always show preview images** — users pick faces by sight, not by id. Narrow to 3–5 that match the brief before presenting:

- **Match the audience.** B2B/finance → polished, professional. Lifestyle/DTC → warm, casual. Youth/gaming → energetic.
- **Match the wardrobe to the topic.** Suit for corporate, casual for a vlog-style explainer.
- **Match aspect.** Confirm the avatar reads well in the target aspect (vertical for social, horizontal for YouTube/LinkedIn).

## Customizing / named characters

When the user wants a specific look or a named character:

1. Gather appearance traits conversationally — age range, gender presentation, hair, wardrobe, vibe — one or two at a time, not a form.
2. If the user offers a **reference photo**, record its path/URL in the AVATAR file's `Appearance → Reference` field. A clear, front-facing, well-lit headshot gives the best likeness.
3. Run the customization through Zebracat's avatar pipeline (the create path exposed by your transport). Custom avatars are asynchronous — they may take a short while to become usable; confirm readiness before generating a video.

## Reference photo guidance

Good source photo = good avatar. Nudge the user toward:

- Front-facing, eyes to camera
- Even, soft lighting (no harsh shadows, no backlight)
- Face clearly visible (no sunglasses, no heavy occlusion)
- Reasonable resolution (a crisp headshot, not a tiny thumbnail)

If the photo is poor, expect a weaker likeness — offer to use a stock avatar instead.

## Avatar layout in videos

When zebracat-video generates an `ai_avatar` video, the presenter can appear as:

- **Full-frame** — presenter fills the frame (default, most direct).
- **Split-screen** — presenter beside b-roll / supporting visuals.
- **Mixed** — alternates between presenter shots and b-roll scenes.

State the preference in the video brief, not here. This skill just sets up the reusable identity (who the presenter is + their voice).

## Reuse across videos

The whole point of saving `AVATAR-<NAME>.md` is reuse:

- zebracat-video reads `Avatar ID` + `Voice ID` automatically for any presenter video.
- One file per character — `AVATAR-CLEO.md`, `AVATAR-BRAND.md`, etc.
- Update the file (new look, new voice) rather than creating duplicates.

## When NOT to use an avatar

If the video is footage-led (ads, b-roll, story), the user may not need a presenter at all. `ai_video`, `moving_ai_images`, and `stock_footage` types work without an avatar. Only set up an avatar when the user wants a face delivering the message to camera.
