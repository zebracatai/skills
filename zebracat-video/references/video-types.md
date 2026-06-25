# Video Types Reference

Zebracat produces five video types. Pick by purpose first, budget second. When in doubt, use the agentic entry (`create_agentic_video` / `--from agentic`) and let the planner choose.

---

## ai_video — Cinematic AI footage

Fully AI-generated, motion-rich footage. The most "produced" look.

- **Best for:** ads, brand films, product launches, story-driven content, anything that needs a premium, cinematic feel.
- **Strengths:** dynamic camera moves, custom scenes stock can't cover, strong stylization (works beautifully with Ghibli / Anime / Cartoon / cinematic styles).
- **Tradeoffs:** highest render cost and time of the footage types.
- **Pair with:** a defined `visual_style`, a clear mood, and a tight script. Cinematic styles shine here.

## moving_ai_images — Subtle motion over AI stills

AI-generated still images with gentle parallax / pan-and-zoom motion.

- **Best for:** calm explainers, educational content, budget-conscious projects, narration-led videos where the visuals support rather than star.
- **Strengths:** cheaper and faster than `ai_video`, very consistent look, great for long-form narration.
- **Tradeoffs:** less kinetic than `ai_video`; not ideal for high-energy ads.
- **Pair with:** a strong voice-over and clear scene-by-scene script.

## ai_avatar — Talking presenter

A presenter avatar delivers the message to camera. Requires an `avatar_id` (and a `voice_id`).

- **Best for:** spokesperson videos, course intros, personalized outreach, announcements, anything that benefits from a human face.
- **Strengths:** direct, trustworthy, repeatable brand presenter. Reusable across videos.
- **Tradeoffs:** needs an avatar set up first.
- **Flow:** if no `AVATAR-<NAME>.md` exists, hand off to **zebracat-avatar** to design one, then return and generate with `video_type=ai_avatar`. Read `Avatar ID` + `Voice ID` from the file.
- **Layout note:** avatars can be full-frame, split-screen with b-roll, or mixed. State the preference in the brief; the default is a clean presenter framing.

## stock_footage — Real-world b-roll

Curated real stock clips selected to match the script (semantic search).

- **Best for:** corporate, how-to, authentic/real-world subjects, testimonials-style content, anything where real people and places matter.
- **Strengths:** authentic, no "AI look", fast, reliable for common subjects (offices, cities, nature, people).
- **Tradeoffs:** limited for abstract or fantastical concepts (stock may not exist).
- **Pair with:** concrete, real-world scripts. Avoid for surreal/abstract topics — use `ai_video` there.

## brainrot — Viral short-form

High-retention vertical short-form: gameplay background (subway-surfers, minecraft-parkour), italian-brainrot, or general fast-cut viral style.

- **Best for:** TikTok / Reels / Shorts virality, hooks, listicles, "did you know" content.
- **Flow:** **hand off to the zebracat-brainrot skill** — it owns the formats, background selection, and caption styling. See `zebracat-brainrot/references/formats.md`.

---

## footage_type vs video_type

The `from_idea` / `from_script` / `from_blog` / `from_audio` entries accept a `footage_type` (a.k.a. `video_type`) knob with the same five values above. The agentic entry omits it and lets the planner choose. CLI exposes it as `--type ai_video|moving_ai_images|ai_avatar|stock_footage|brainrot`.

## Quick decision matrix

| The user wants… | Use |
|---|---|
| A premium, cinematic ad or brand film | `ai_video` |
| A fantastical / stylized look (Ghibli, anime) | `ai_video` |
| A calm narrated explainer, on a budget | `moving_ai_images` |
| A spokesperson / presenter on camera | `ai_avatar` (+ zebracat-avatar) |
| Real offices, cities, people, products | `stock_footage` |
| A viral TikTok/Reel/Short | `brainrot` (→ zebracat-brainrot) |
| "Just make something good" | agentic entry |

## Aspect ratio by platform

| Platform | aspect_ratio / `--aspect` |
|----------|---------------------------|
| TikTok, Reels, Shorts, Stories | `vertical` (9:16) |
| YouTube, LinkedIn, website, email | `horizontal` (16:9) |
| Instagram feed, square ads | `square` (1:1) |

Set aspect before anything else — it shapes framing, composition, and pacing.

## Duration guidance

Allowed: `15`, `30`, `60`, `120`, `180` seconds.

- **15–30s:** social hooks, ads, teasers. One idea, one CTA.
- **60s:** explainers, product overviews, the sweet spot for most marketing.
- **120–180s:** tutorials, deep explainers, story-driven brand films.

Duration should follow the script length — roughly 2.5 words/second of narration. Don't request 180s for a 40-word script; it pads.
