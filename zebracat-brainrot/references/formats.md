# Brainrot Formats Reference

The four brainrot formats, their backgrounds, and the retention mechanics that make short-form go viral.

---

## The formats

### subway — Subway-surfers style
Endless-runner gameplay (the iconic subway-surfers look) scrolls underneath bold captions and a fast voice-over.
- **Audience:** broad, mass-appeal. The default brainrot format.
- **Best for:** fast facts, "things you didn't know", storytime, hooks, mini-explainers.
- **Brief directive:** `"subway surfers gameplay background, fast captions"`.

### minecraft — Minecraft parkour
Minecraft parkour gameplay runs in the background.
- **Audience:** gaming, younger / gen-z, Minecraft-native viewers.
- **Best for:** listicles, gaming facts, "did you know", ranked content.
- **Brief directive:** `"minecraft parkour gameplay background, fast captions"`.

### italian — Italian brainrot
The absurd, meme-chaotic "italian brainrot" aesthetic (surreal characters, chaotic edits, meme energy).
- **Audience:** meme / comedy / gen-z humor.
- **Best for:** comedy, satire, absurd takes, meme formats.
- **Brief directive:** `"italian brainrot style, chaotic meme energy"`.
- **Mood:** comedic / absurd rather than straight high-energy.

### general — Generic viral
Fast-cut viral b-roll with no specific gameplay aesthetic.
- **Audience:** anyone; topics that don't fit a gameplay vibe.
- **Best for:** brand-safe shorts that still want the fast-caption brainrot pacing.
- **Brief directive:** `"fast-cut viral b-roll, bold captions"`.

---

## Retention mechanics (why brainrot works)

1. **The hook owns the first 1–2 seconds.** Open with the wildest claim, the question, or the number. No intro, no "hey guys". If the first line isn't a hook, rewrite it.
2. **Background motion never stops.** The gameplay/chaos background keeps the eye busy so the viewer doesn't scroll. This is the whole point of the format.
3. **Captions ARE the content.** Bold, large, word-by-word or phrase-by-phrase, synced tightly to the voice-over. Most viewers watch muted — captions carry the message.
4. **One beat.** One fact, one story, one punchline. Brainrot collapses under a multi-part thesis.
5. **Pace fast.** ~2.5–3 words/sec narration, quick cuts. 15–30s total. Longer = lower completion rate.
6. **End on a loop or a CTA.** A question that invites a rewatch, or "follow for more".

## Hook patterns that work

- *"You've been [doing X] wrong your whole life."*
- *"Nobody talks about this, but…"*
- *"This [thing] is illegal in [place]. Here's why."*
- *"99% of people don't know that…"*
- *"POV: you just found out…"*

Lead with one, then deliver the single payoff fast.

## Defaults cheat-sheet

| Knob | Brainrot default |
|------|------------------|
| `video_type` | `brainrot` |
| `aspect_ratio` | `vertical` |
| `duration` | `15` or `30` |
| `mood` | high-energy (comedic for `italian`) |
| captions | on, bold, fast |
| hook | first 1–2 seconds, non-negotiable |

## Picking a format fast

| The topic is… | Format |
|---------------|--------|
| A broad fact / story for everyone | `subway` |
| Gaming, or aimed at a young gaming audience | `minecraft` |
| Comedy / meme / absurd | `italian` |
| Brand content that wants brainrot pacing without gameplay | `general` |

When the user just says "make it viral" with no format preference, default to `subway` (broadest appeal) or use the agentic entry with `video_type=brainrot`.
