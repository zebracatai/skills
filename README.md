# Zebracat Skills 🦓

AI agent skills for making video. Describe an idea — your agent writes the script, picks the style and voice, generates the footage, and hands back a finished video. AI Video, Moving AI Images, AI Avatar presenters, Stock Footage, and viral Brainrot, plus voice cloning and dubbing into 25+ languages.

Works with Claude Code, OpenClaw, Codex, Cursor, and other AI coding agents.

```
"Make a 30-second vertical video about our product launch — energetic, cinematic.
 Use zebracat-video and ask me anything before you start."
→ figures out the platform + aspect → drafts a script → picks a style and voice
→ generates the video → polls quietly → delivers the share link
```

## Install

**Paste this into your agent.** It does the rest — installs the skills, detects how to reach Zebracat, and ends with a working video.

```
Read https://raw.githubusercontent.com/zebracatai/skills/main/INSTALL_FOR_AGENTS.md and follow it.
Connect the Zebracat MCP server, or give me a Zebracat API key if you have one.
```

That's it. The agent fetches [INSTALL_FOR_AGENTS.md](./INSTALL_FOR_AGENTS.md) and walks the rest. Same prompt forever — the install spec lives in the repo, not in your clipboard.

Want to install manually instead? Pick the path that matches your tooling.

### Option A — `npx skills` (easiest, no clone)

The [Vercel Labs `skills` CLI](https://github.com/vercel-labs/skills) installs straight from GitHub — no clone, no config. All seven skills:

```bash
npx skills add zebracatai/skills
```

Just one skill:

```bash
npx skills add zebracatai/skills --skill zebracat-video
```

Target a specific agent with `-a` (e.g. `claude-code`, `openclaw`), or install globally (user scope, every project) with `-g`:

```bash
npx skills add zebracatai/skills -a openclaw     # install for OpenClaw
npx skills add zebracatai/skills -g              # user scope, every project
```

### Option B — `gh skill install` (works across 12+ agents)

Requires [GitHub CLI](https://cli.github.com) v2.90+. Writes to the right directory for your agent automatically (Claude Code, Cursor, Codex, Gemini CLI, Copilot, and more — [agentskills.io](https://agentskills.io)):

```bash
gh skill install zebracatai/skills zebracat-video
gh skill install zebracatai/skills zebracat-avatar
gh skill install zebracatai/skills zebracat-voice
gh skill install zebracatai/skills zebracat-brand
gh skill install zebracatai/skills zebracat-swap
gh skill install zebracatai/skills zebracat-brainrot
gh skill install zebracatai/skills zebracat-translate
```

### Option C — ClawHub (OpenClaw marketplace)

```bash
clawhub install zebracat-skills
```

Installs all seven skills to your agent's default skills directory.

### Option D — Git clone

Clone into your agent's skills directory:

```bash
# Claude Code: clone anywhere, then install the clone as a plugin
git clone https://github.com/zebracatai/skills.git ~/zebracat-skills
claude plugin marketplace add ~/zebracat-skills && claude plugin install zebracat@zebracat
# OpenClaw
git clone https://github.com/zebracatai/skills.git ~/.openclaw/skills/zebracat-skills
```

Claude Code loads only skills one folder deep in `~/.claude/skills/`, so a clone there gives no commands; install the clone as a plugin as shown. After cloning, all seven skills are at `zebracat-video/SKILL.md`, `zebracat-avatar/SKILL.md`, `zebracat-voice/SKILL.md`, `zebracat-brand/SKILL.md`, `zebracat-swap/SKILL.md`, `zebracat-brainrot/SKILL.md`, and `zebracat-translate/SKILL.md`.

> Not sure where your skills directory is? Ask your agent: *"Where is your skills directory?"*

### Option E — Claude Code plugin

Installs all seven skills and connects the Zebracat MCP server in one step. Inside Claude Code:

```
/plugin marketplace add zebracatai/skills
/plugin install zebracat@zebracat
```

Or from your shell: `claude plugin marketplace add zebracatai/skills && claude plugin install zebracat@zebracat`. Run `/mcp` once to sign in to Zebracat (OAuth, your plan credits).

## What's Included

Seven skills that work standalone or chain together:

| Skill | What it does | Invoke |
|-------|--------------|--------|
| **zebracat-video** | Idea / script / URL / reference video → a plan with its price → finished video, including motion graphics and 3D animation; ideas from trending videos, music, and posting to your social accounts. The flagship producer. | `/zebracat-video` |
| **zebracat-avatar** | Choose or customize a presenter, build reusable characters → `AVATAR-<NAME>.md`. | `/zebracat-avatar` |
| **zebracat-voice** | Browse, preview, and clone voices; pick a tone → `voice_id`. | `/zebracat-voice` |
| **zebracat-brand** | Set up and reuse a brand kit — name, logo, colors, fonts, tone. | `/zebracat-brand` |
| **zebracat-swap** | Character Swap: put your character in place of the person in a clip (paid plans). | `/zebracat-swap` |
| **zebracat-brainrot** | Viral short-form: subway-surfers / minecraft-parkour / italian-brainrot / general. | `/zebracat-brainrot` |
| **zebracat-translate** | Existing video → dubbed + captioned version in 25+ languages. | `/zebracat-translate` |

Type the command, or just ask ("make a 30-second video about …") and your agent picks the skill. In Claude Code the commands above work on every install path. A plugin install (Option E) also lists them under the plugin's name, as `/zebracat:zebracat-video` and so on; both forms run the same skill.

## Everything Zebracat does, by category

The same eight groups on every surface: the MCP server, the `zebracat` CLI, the REST API (paths under `https://api.zebracat.ai/api/v1/public`) and these skills.

| Category | What | MCP tools | CLI | REST | Skill |
|----------|------|-----------|-----|------|-------|
| **Videos** | Plan from an idea, a script or a link; change the plan; quote; generate; read, list, cancel, download | `create_video`, `plan_video`, `get_plan`, `edit_plan`, `chat_plan`, `undo_plan`, `answer_video_question`, `quote_video`, `generate_video`, `get_video`, `list_videos`, `cancel_video` | `video create`, `plan show\|edit\|chat\|undo`, `video answer\|quote\|generate`, `video get\|list\|cancel\|download` | `POST /videos`, `/videos/{id}/plan`, `/plan/edit`, `/plan/chat`, `/plan/undo`, `/answer`, `/quote`, `/generate`, `GET /videos`, `/videos/{id}`, `/cancel`, `/download` | zebracat-video, zebracat-brainrot |
| **Remake a video** | Start from an existing video: clone it, translate it, swap a character into it | `clone_video`, `translate_video`, `get_character_swap_options`, `analyze_character_swap`, `swap_character`, `get_character_swap` | `video clone`, `video translate`, `swap`, `swap options`, `swap status` | `POST /video/clone`, `POST /video/translate`, `/character-swap`, `/character-swap/options`, `/analyze`, `/{job_id}` | zebracat-video, zebracat-translate, zebracat-swap |
| **Inspiration** | Find viral videos in a niche; read what one says | `search_inspiration`, `get_inspiration_transcript` | `inspiration search\|transcript` | `GET /inspiration`, `GET /inspiration/{video_id}/transcript` | zebracat-video |
| **Catalogs** | Public pick-lists: video types, qualities and models, presets, voices, languages, visual styles, music, backgrounds, templates, stock avatars | `list_video_types`, `list_video_models`, `list_presets`, `list_voices`, `list_languages`, `list_translate_languages`, `list_visual_styles`, `list_music`, `search_music`, `list_brainrot_backgrounds`, `list_templates`, `resolve_template`, `list_avatars` | `video types`, `model list`, `preset list`, `voice list`, `language list [--translate]`, `style list`, `music list\|search`, `background list`, `template list`, `avatar list` | `GET /video/types`, `/video/models`, `/video/presets`, `/voices`, `/video/languages`, `/video/translate/languages`, `/visual_styles`, `POST /music`, `/music/search`, `GET /video/backgrounds`, `/templates`, `/avatars` | zebracat-video, zebracat-voice, zebracat-avatar |
| **Library** | Your own things: uploads, characters, brand kits, cloned voices, avatars from a photo | `list_uploads`, `create_upload_link`, `list_characters`, `create_character`, `update_character`, `delete_character`, `list_brands`, `create_brand`, `update_brand`, `list_cloned_voices`, `clone_voice`, `delete_cloned_voice`, `create_avatar_from_image` | `upload`, `upload list`, `character list\|create\|update\|delete\|suggest`, `brand list\|create\|update\|delete`, `voice clone\|get\|delete`, `avatar clone` | `POST /uploads`, `GET /uploads`, `POST /uploads/link`, `/characters`, `/brands`, `/voice/clone`, `POST /avatars/clone` | zebracat-avatar, zebracat-brand, zebracat-voice |
| **Publish** | Connected social accounts; post now or schedule | `list_social_accounts`, `schedule_post`, `list_scheduled_posts`, `get_post`, `cancel_post` | `post …` | `/scheduling/connected`, `/scheduling/posts`, `/scheduling/posts/list`, `/scheduling/posts/{id}` | zebracat-video |
| **Account** | Who you are, balance, prices, usage | `get_balance`, `get_pricing`, `get_usage` | `account show\|pricing\|usage` | `GET /account`, `/pricing`, `/credit/usage` | – |
| **Webhooks** | Signed callbacks when a job finishes | – | `webhook list\|create\|update\|delete\|test` | `/webhooks`, `/webhooks/{id}`, `POST /webhooks/{id}/test`; per video: `webhook_url` | – |

Old names keep working for a while and the skills never call them: MCP `list_projects` (now `list_videos`), `get_project` (now `get_video`), `list_media` (now `list_uploads`), `get_video_status`, `list_latest_videos`, `generate_script`, `list_prompt_styles`; CLI `presets list`, `models list`, `video status`, `video languages`. API keys and top-ups live in your Zebracat account (dashboard). The first-generation calls (MCP `create_video_from_idea`, `create_video_from_script`, `create_video_from_blog`, `create_video_from_audio`, `create_agentic_video`; REST `/video/idea`, `/video/script`, `/video/blog`, `/video/audio`, `/video/agentic`, `/script_generator`, `/generate_image`) still answer and sit under **Legacy** in the docs; new work uses **Videos**.

**Which call?** It depends on what you have: an idea, a script, a link, a video to copy, a finished video to translate or re-cast, pictures, or a person to reuse. The table in [zebracat-video](zebracat-video/SKILL.md#choose-by-what-the-user-has) picks the call on every surface.

## How It Works

```
Idea / script / URL / audio        Reusable state              Finished video
        ↓                              ↓                            ↓
  zebracat-avatar  →  AVATAR-NAME.md (face + voice)  →  zebracat-video  →  zebracat-translate
  zebracat-voice   →  voice_id                          (script + render)    (localize)
```

Skills share plain-text state at the workspace root: `AVATAR-<NAME>.md` (written by zebracat-avatar, read by zebracat-video) and an append-only `zebracat-video-log.jsonl` (one line per finished video).

## Authentication — three ways to reach Zebracat

The skills auto-detect a transport. Detailed ladder in [CLAUDE.md](./CLAUDE.md).

| Priority | Mode | Trigger | Billing | Best for |
|----------|------|---------|---------|----------|
| 1 | **CLI / REST (API key)** | `ZEBRACAT_API_KEY` is set | Pay-as-you-go | Agents, CI, scripts |
| 2 | **MCP (OAuth)** | MCP tools visible AND no API key | Your Zebracat plan credits | Users on a Zebracat plan |

**The rule:** if `ZEBRACAT_API_KEY` is set, the skills use the CLI (or REST) with it. Otherwise they use MCP via OAuth — no key handling, bills your plan credits.

- **MCP (zero-setup if on a plan):** connect `https://mcp.zebracat.ai/mcp` to your agent. First call triggers OAuth in your browser.
- **API key (pay-as-you-go):** get a key from your Zebracat account, then `export ZEBRACAT_API_KEY=sk-…`.
- **CLI (`zebracat`):** `curl -fsSL https://cli.zebracat.ai | bash`, then `zebracat auth login` (paste your API key) or `export ZEBRACAT_API_KEY=sk-…`. Verify with `zebracat auth status`.

## Things to Try

| Prompt | What happens |
|--------|--------------|
| "Make a 30-second cinematic AI video about our launch. Ask me what you need." | Producer flow: intent → style → voice → render → link. |
| "Turn this blog post into a 60-second explainer: [URL]" | Fetches the article, scripts it, generates the video. |
| "Set up an AI avatar presenter, then record a 30s intro." | zebracat-avatar → `AVATAR-NAME.md` → zebracat-video. |
| "Make a subway-surfers brainrot short about this fact." | zebracat-brainrot: vertical, fast captions, gameplay background. |
| "Clone my voice from this recording and use it in a video." | zebracat-voice → `voice_id` → zebracat-video. |
| "Translate this video into Spanish, German, and Japanese." | zebracat-translate: one dubbed + captioned video per language. |
| "Find what's trending in skincare and make one like the best." | zebracat-video: Inspiration search → plan → video. |
| "Post it to TikTok tomorrow at 9am." | zebracat-video: shows the exact post, schedules it on your yes. |

## Requirements

- A Zebracat account — sign in via MCP (OAuth) or use an API key for the CLI / REST path.
- An AI agent that supports skills (Claude Code, OpenClaw, Codex, Cursor, or similar).
- No runtime dependencies. No packages. No build step.

## Security

One optional shell script:

- **`scripts/update-check.sh`** — compares your local `VERSION` against the latest on GitHub. Read-only, opt-in, transmits nothing.

Data only leaves your machine through MCP / the `zebracat` CLI / the REST API (video generation) and optionally `raw.githubusercontent.com` (the version check).

## Links

- [Zebracat](https://zebracat.ai)
- [Repository](https://github.com/zebracatai/skills)
- [Browse all skills](https://mcp.zebracat.ai/skills)
- [Installation guide](INSTALL.md) · [For agents](INSTALL_FOR_AGENTS.md)
- [Contributing](CONTRIBUTING.md) · [Changelog](CHANGELOG.md)

## License

MIT
