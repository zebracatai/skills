# Video Types Reference

On the v2 engine a video is described by three independent choices, all optional: the **media
type** (what the pictures are made of), the **audio mode** (who speaks), and a **preset** (a
proven format). Leave out what the user does not care about; the plan decides from the brief.

The live lists: `list_presets` / `zebracat presets list` / `GET /video/presets`, and
`list_video_models` / `zebracat models list` / `GET /video/models` (qualities, models, prices).

---

## Media types (`media_type`)

| Value | Pictures | Best for | Tradeoffs |
|-------|----------|----------|-----------|
| `ai_video` | generated video clips, people can speak on camera with lip-sync | ads, stories, UGC, interviews, podcasts, presenters | highest cost; the default for most briefs |
| `ai_image_video` | AI stills with motion | calm explainers, long narration, budget work | less kinetic |
| `stock` | real b-roll | corporate, how-to, authentic footage | no stylized look |
| `brainrot` | viral gameplay backgrounds (subway surfers, minecraft…) | viral shorts → use **zebracat-brainrot** | needs a background (`background_video`) |

**Presenters and avatars:** there is no separate "AI Avatar" type any more. A presenter is an
`ai_video` with that person on camera: pass their portrait as `uploads: [{url, kind: "person"}]`
(zebracat-avatar stores the URL in `AVATAR-<NAME>.md`). The old `video_type: ai_avatar` on the v1
endpoints maps to exactly that.

## Audio modes (`audio_mode`)

| Value | Who speaks |
|-------|------------|
| `narration` | one voice-over over the pictures |
| `dialogue` | the people on camera speak their lines (interviews, podcasts, sketches, UGC) |
| `silent` | no voice; music only |

## Quality (`quality`)

`quick`, `balanced`, `cinematic`, or `auto` (the plan picks per shot). Higher quality uses stronger
video models and costs more; `list_video_models` prints the credits per 5 s for each.

## Presets (`preset`)

A preset pre-fills the format (cast slots, beat shape, defaults); the user's own choices still win.

| Preset | What it makes |
|--------|---------------|
| `street_interview` | an interviewer asks one question; passers-by answer on camera |
| `video_podcast` | host and guest at a podcast desk, trading turns |
| `ugc_ad` | a creator talks to the phone camera: hook, problem, product, result, call to action |
| `ai_movie` | a short story that ends |
| `ai_debate` | a moderated debate |
| `fruit_drama` | a mini-drama between 3D fruit characters |
| `pov_video` | through the viewer's eyes, narrated |
| `product_showcase` | the product as the hero of every shot |
| `travel_video` | places, one per beat |

The creator pages (`ai-cartoon-video-generator`, `ai-anime-video-generator`, `ghibli-ai`, …) are
presets too; `list_presets` has them all.

## Input kinds (`input_kind`)

| Value | The brief is |
|-------|--------------|
| `idea` | an idea or topic (default): the engine writes the script |
| `script` | the user's script: their words are kept |
| `voiceover_script` | a narration script: kept, read by one voice |
| `script_with_scenes` | a script with scene directions |
| `url` | a page to make the video from (blog, product page) |
