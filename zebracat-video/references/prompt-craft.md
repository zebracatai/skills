# Prompt & Script Craft Reference

How to turn an idea into a brief and script that produce a strong Zebracat video. Load this when the user wants a polished result, scene control, or a specific narrative voice.

---

## The brief vs the script

- **Brief** — the instruction to Zebracat: video type, style, mood, duration, aspect, audience, key message. Goes into the entry call.
- **Script** — the narration the viewer hears. Either the user's own (use the `script` entry) or generated via `generate_script(...)`.

Keep them separate. The brief is in English (API directive); the script is in the video language.

## Anatomy of a strong brief

```
PURPOSE:   what this video is for (ad / explainer / social / story) + one goal
AUDIENCE:  who it's for
DURATION:  15 | 30 | 60 | 120 | 180 seconds
ASPECT:    vertical | square | horizontal (from the platform)
TONE:      the emotional register ("confident and warm", "high-energy")
STYLE:     visual_style id (+ brand hex codes if any)
KEY MESSAGE: the one thing they must remember
CTA:       what to do next (if any)
```

## Writing the script

1. **Hook in the first 3 seconds.** Lead with the payoff, the question, or the bold claim. Never warm up.
2. **One idea per video.** If the topic forks, recommend splitting into two videos.
3. **Write for the ear.** Short sentences. Active voice. Contractions. If you wouldn't say it out loud, rewrite it.
4. **Voice-over is spoken words ONLY.** No stage directions, no "[upbeat music]", no scene labels in the narration field — those leak into the voice track. Put visual direction in the brief, not the script.
5. **Pace to duration.** ~2.5 words per second. A 30s video ≈ 70–80 spoken words. Don't oversize the duration for a short script, or the pacing pads.
6. **End on the CTA.** One clear action. "Try it free", "Link in bio", "Subscribe".

## Script structure by purpose

| Purpose | Structure |
|---------|-----------|
| Product / ad | Hook → problem → product → CTA |
| Explainer | Context → core idea → takeaway |
| Tutorial | What you'll learn → steps → recap |
| Social / hook | Bold open → 2–3 fast beats → CTA |
| Brand story | Character → tension → resolution → brand |

## Generating a script

```
generate_script(
  idea="<the idea>",
  language="english",
  duration=30,
  mood="<mood>",
  prompt_style="<optional narrative style id>"
)
```
Show the result with word count + estimated duration and get approval before generating the video. If the user supplied a script, prefer the `script` entry and keep their words — light cleanup only (remove directives, fix obvious typos).

## On-screen text

If specific text must appear exactly (prices, stats, handles, URLs, CTAs), call it out in the brief so the pipeline renders it literally instead of paraphrasing:

```
ON-SCREEN TEXT (show literally):
- "$19/mo"
- "@zebracat.ai"
- "Try free → zebracat.ai"
```

## Mood

Mood drives music, pacing, and voice delivery. Be specific: "calm and reassuring", "fast and hype", "playful", "serious and authoritative". Pass as `mood=` / `--mood`. Match the mood to the style — a hype mood with a soft Ghibli style fights itself.

## Language separation (non-English videos)

- **Script / narration / on-screen text** → in the video language.
- **Brief, mood, style ids, video_type, aspect** → English (pipeline directives).

A Spanish video still uses `video_type=ai_video`, `aspect_ratio=vertical`, `mood="energetic"` — only the spoken/visible words are Spanish.

## What doesn't work

- **Stage directions in the voice-over field** → they get read aloud. Keep them in the brief.
- **Oversized duration for a short script** → padding, dead air. Right-size duration to word count.
- **Multi-topic scripts** → diluted, low-retention videos. Split them.
- **Vague briefs** → generic output. State purpose, audience, and one key message at minimum.
- **Stylized look on `stock_footage`** → ignored; stock is real footage. Switch to `ai_video` for stylization.
