# Visual Styles Reference

Zebracat applies a `visual_style` across every scene so the video looks consistent. Always browse the live list before choosing — the catalog evolves.

**MCP:** `list_visual_styles()` and `list_prompt_styles()`
**CLI:** `zebracat style list --human`

Pass the chosen id as `visual_style=<id>` (MCP) or `--style <id>` (CLI).

---

## How to pick: mood first, content second

Ask the user: *"What should the viewer FEEL?"* Match the style to the feeling, then sanity-check it against the subject. Show 3–5 options with previews and let the user choose — don't pick silently.

| Content feels… | Reach for… |
|---|---|
| Whimsical, warm, hand-drawn | **Ghibli**, **Cartoon** |
| Stylized, dramatic, character-driven | **Anime** |
| Premium, sleek, high-end | Cinematic / Realistic |
| Clean, corporate, trustworthy | Minimal / Flat |
| Bold, loud, social-native | Vibrant / High-contrast |
| Calm, educational | Soft / Muted |

## Signature styles

These are the most-requested looks. Availability and exact ids come from `list_visual_styles()`.

- **Ghibli** — soft, painterly, warm light, hand-drawn animation feel. Great for storytelling, brand fables, heartfelt explainers. Pairs best with `ai_video` or `moving_ai_images`.
- **Anime** — crisp linework, dramatic lighting, expressive characters. Great for character-driven stories, gaming, youth brands. Pairs with `ai_video`.
- **Cartoon** — playful, rounded, bright. Great for education, kids, lighthearted product explainers.
- **Cinematic / Realistic** — filmic color, depth, dramatic lighting. Default premium look for ads and brand films.
- **Minimal / Flat** — clean shapes, generous negative space. Default for SaaS / corporate / tech.

> Style names are technical directives to the Zebracat pipeline. Keep `visual_style` ids in English even when the script is in another language.

## Brand colors

When the user has a brand, state hex codes and (where supported) typography in the brief so visuals stay on-brand scene to scene:

```
Brand: primary #7c3aed (purple), background #0a0a0a, text #ffffff.
Keep accents purple; avoid competing colors.
```

Zebracat's own brand: purple **#7c3aed**, zebra mascot 🦓. Use it for Zebracat-themed demos.

## Style + video type pairings that work

| Style | Strong with | Weak with |
|-------|-------------|-----------|
| Ghibli | `ai_video`, `moving_ai_images` | `stock_footage` (clash) |
| Anime | `ai_video` | `stock_footage` |
| Cartoon | `ai_video`, `moving_ai_images` | `stock_footage` |
| Cinematic/Realistic | `ai_video`, `stock_footage` | — |
| Minimal/Flat | `moving_ai_images`, `ai_video` | — |

Stylized styles (Ghibli/Anime/Cartoon) do not apply to `stock_footage` — stock is real footage. If the user wants a stylized look, switch the type to `ai_video`.

## Prompt styles

Some entries accept a `prompt_style` (narrative voice/structure of the script) separate from `visual_style` (the look). List with `list_prompt_styles()`. Use `prompt_style` to shape tone of the writing (e.g. punchy, storytelling, educational) and `visual_style` to shape the imagery. They're independent — set both for full control.
