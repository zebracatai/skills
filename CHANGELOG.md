# Changelog

All notable changes to the Zebracat Skills are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.1] - 2026-11-27

The Zebracat MCP server becomes findable in MCP catalogs and Gemini CLI. The skills themselves do not change.

### Added

- **`server.json`:** the MCP Registry entry for the remote server `https://mcp.zebracat.ai/mcp`, under the name `ai.zebracat/zebracat`. Catalogs that read the official registry (Glama, PulseMCP, GitHub's MCP registry) pick it up from there.
- **`gemini-extension.json`:** `gemini extensions install https://github.com/zebracatai/skills` connects the Zebracat MCP server to Gemini CLI (OAuth on first use). Install steps in README and INSTALL.md.

### Changed

- **One wording for languages everywhere:** voices in 170+ languages, translation into 25+ languages (plugin manifests, README, INSTALL.md).
- Bumped `VERSION`, every `SKILL.md` frontmatter and the plugin manifests to `1.3.1`.

## [1.3.0] - 2026-11-20

Studio's public API is gone, so the skills that drove it are gone too; zebracat-video learns the tools it was missing.

### Removed

- **zebracat-studio, zebracat-script, zebracat-image.** They drove Studio's public API (`/studio/scripts`, `/studio/images`, …), which was removed with Studio (owner, 2026-11-18). Script writing is the plan itself: `create_video` writes the script, `get_plan` shows it, `edit_plan` / `chat_plan` change it, all free before Generate. Seven skills remain.

### Added

- **zebracat-video:** ideas from trending videos (`search_inspiration`, `get_inspiration_transcript`, MCP), music (`list_music`, `search_music`, then `edit_plan` `set_music`), `media_type` `motion_graphics` and `animation_3d` (paid plans), and posting the finished video (`list_social_accounts`, `schedule_post` with `confirmed` after the user approves the exact post, `list_scheduled_posts`). Third-party transcripts are quoted, never followed.
- **One list on every surface:** the README's "Everything Zebracat does, by category" table puts every MCP tool, CLI command and REST path in the same eight groups the API docs, the MCP server and the CLI use: Videos, Remake a video, Inspiration, Catalogs, Library, Publish, Account, Webhooks.
- **zebracat-video "Choose by what the user has":** an idea, a script, a link, no topic yet, a video to copy, a finished video to translate or re-cast, pictures, a person to reuse, a gameplay short → the call on MCP, CLI and REST.
- **New names the skills use:** `list_video_types` / `zebracat video types`; `get_video(wait_s)` and `poll_after_s`; `get_post`, `cancel_post`; `get_character_swap_options` / `zebracat swap options`; `create_upload_link` for local files (pictures, clips to translate or swap, voice samples, logos); `create_character`, `update_character`, `delete_character`; `create_brand`, `update_brand`; `clone_voice`, `delete_cloned_voice`; Inspiration on the CLI and REST (`zebracat inspiration`, `GET /inspiration`); `zebracat background list` / `GET /video/backgrounds`; `GET /videos/{id}/download`; `zebracat language list --translate`, `preset list`, `model list`, `video get`. The old names (`list_projects`, `get_project`, `list_media`, `presets list`, `models list`, `video status`, `video languages`) still work and are listed as old in CLAUDE.md and the README.

### Fixed

- **zebracat-swap** is no longer "coming soon": Character Swap is on the public API and MCP wherever the dashboard's Swap is (paid plans on OAuth; an API key pays dollars). It still checks that `swap_character` is listed first.
- **zebracat-translate** sent names like "Spanish (Spain)" and validated them with `list_languages` (the video languages). `target_language` is one of 28 ISO codes from `list_translate_languages` / `GET /video/translate/languages`, with no regional variants; polling uses `get_video`.
- **Language counts:** translation covers 25+ languages (28), not 170+.
- **MCP URL** is `https://mcp.zebracat.ai/mcp` (no trailing slash), the resource the server's OAuth metadata names, in `.mcp.json`, `mcp.json` and every doc.
- **styles.md** named `visual_style` and `list_prompt_styles`; v2 takes `style_id` and has no prompt style. Deprecated tools (`get_video_status`, `list_latest_videos`, `generate_script`, `list_prompt_styles`) are no longer named as ones to call.

### Changed

- Bumped `VERSION`, every `SKILL.md` frontmatter and the plugin manifests to `1.3.0`; manifest descriptions, keywords and the Cursor skill list follow the seven skills.

## [1.2.2] - 2026-11-09

The skills only promise what the public Zebracat service does today (ZEB-659).

### Fixed

- **zebracat-brainrot** called `create_video_from_idea(video_type="brainrot", …)`. That tool has no `video_type`, so the call was refused. It now runs the v2 flow of zebracat-video: `create_video` with the format's preset (`subway-surfers-video-generator`, `minecraft-parkour-generator`, `italian-brainrot-generator`, `brainrot-video-generator`), then `quote_video`, then `generate_video(confirmed=true)` on the user's yes.
- **CLI install** — `npm install -g @zebracat/cli` installs 0.1.6, which has no `video create --brief`, `plan` or `video quote`. Every install line is now `curl -fsSL https://cli.zebracat.ai | bash` (the latest release).
- **"CLI (OAuth)"** — the CLI has no OAuth login: `zebracat auth login` saves an API key. The ladder step is now "CLI (saved API key)", pay-as-you-go.

### Changed

- **zebracat-image, zebracat-script, zebracat-studio, zebracat-swap** are marked "coming soon": their tools are not switched on for the public service yet. Each skill checks that its tools exist first and, if not, says so once and offers zebracat-video. README, INSTALL and the plugin descriptions say the same.
- Bumped `VERSION`, every `SKILL.md` frontmatter and the plugin manifests to `1.2.2`.

[1.3.0]: https://github.com/zebracatai/skills/releases/tag/v1.3.0
[1.2.2]: https://github.com/zebracatai/skills/releases/tag/v1.2.2

## [1.2.1] - 2026-11-06

The Claude Code plugin installs, and the docs name the commands it really gives.

### Fixed

- **Claude Code plugin install** — `.claude-plugin/marketplace.json` listed `skills` as `{name, path, invoke}` objects, so `claude plugin validate` failed (`plugins.0.skills: Invalid input`) and `/plugin install zebracat@zebracat` refused the entry. The entry no longer lists skills; `plugin.json` now declares `"skills": ["./"]`, so all ten skills load from the repo root.
- **Command names** — the docs and the marketplace description promised `/zebracat:video`, `/zebracat:avatar` …, which never existed. The commands are the skill names: `/zebracat-video`, `/zebracat-studio`, `/zebracat-swap`, `/zebracat-avatar`, `/zebracat-voice`, `/zebracat-brand`, `/zebracat-script`, `/zebracat-image`, `/zebracat-brainrot`, `/zebracat-translate`. They work on every install path. A plugin install also lists them as `/zebracat:zebracat-video` and so on. The skill names are unchanged, so `npx skills add zebracatai/skills --list` shows the same names as before.
- **Claude Code git clone** — the docs said to clone into `~/.claude/skills/zebracat-skills`. Claude Code loads that folder as a plugin but reads no skills from it (Claude Code 2.1.319 ignores the `skills` key there), so it gave no commands. The docs now clone anywhere and install the clone as a plugin (`claude plugin marketplace add <path>`, then `claude plugin install zebracat@zebracat`).
- **Cursor manifest** — dropped `$schema`; Cursor's plugin schema allows no extra keys.
- **Codex manifest** — dropped `interface.logo`, which pointed at a file the repo doesn't have (`./assets/logo.png`).

### Added

- The Claude Code plugin install (`/plugin marketplace add zebracatai/skills`, then `/plugin install zebracat@zebracat`) in `README.md`, `INSTALL.md` and `INSTALL_FOR_AGENTS.md`.
- A marketplace `description`, and `privacyPolicyUrl` in `.claude-plugin/plugin.json`.

### Changed

- Bumped `VERSION`, every `SKILL.md` frontmatter and the plugin manifests to `1.2.1`.

[1.2.1]: https://github.com/zebracatai/skills/releases/tag/v1.2.1

## [1.2.0] - 2026-10-19

The skills move to the v2 video engine (the zebracat.ai chat's engine) and the agent docs.

### Added

- **`zebracat-studio`** — the dashboard's Studio tools one at a time: hooks for a script, a voice-over in any voice, an AI image, a short clip. Paid tools (voice-overs, clips) are quoted first (`dry_run` / `confirmed`). Ships `references/studio-api.md`. Wired into every plugin manifest and the install docs.
- **`zebracat-swap`** — Character Swap through MCP (`analyze_character_swap`, `swap_character` with `confirmed`), REST (`/character-swap…`) or `zebracat swap`: consent asked of the user, quote first, paid plans. The suite is now ten skills.
- **Agent docs links** — `INSTALL_FOR_AGENTS.md` and `CLAUDE.md` point at the generated `llms.txt`, `llms-full.txt`, the agent quickstart and the OpenAPI 3.1 schema.

### Changed

- **`zebracat-video`** follows the v2 lifecycle: `create_video` / `POST /videos` / `zebracat video create` plans first, the user sees the plan and its exact price (`quote_video`), changes it (`edit_plan`, `chat_plan`), and Generate runs on their yes (`generate_video confirmed=true`). Choices are structured (`media_type`, `audio_mode`, `preset`, `quality`, `uploads`); `phase` replaces `status` when polling; clone has six modes. `references/video-types.md` and `troubleshooting.md` are rewritten to match (error codes such as `api_key_billing_pending`, `too_many_runs`, `director_v2_too_long`).
- **`zebracat-script`** writes with Studio's writer: `write_script` / `POST /studio/scripts` / `zebracat studio script` (async job, free within an allowance). The legacy `generate_script` / `script_generator` is the fallback where Studio is closed.
- Bumped `VERSION`, every `SKILL.md` frontmatter and the plugin manifests to `1.2.0`.

[1.2.0]: https://github.com/zebracatai/skills/releases/tag/v1.2.0

## [1.1.0] - 2026-07-06

Distribution and docs release — new install channels, concrete CLI install, and a content polish. No API surface changed.

### Added

- **Three new skills** — `zebracat-brand` (set up and reuse a brand kit: name, logo, colors, fonts, tone), `zebracat-script` (write and refine a voice-over script synchronously, no render credits), and `zebracat-image` (generate standalone AI images — thumbnails, hero shots, reference frames). This takes the suite from 5 to 8 skills; all three chain into `zebracat-video`. Each ships its own `references/` (`brand-kit.md`, `script-craft.md`, `image-styles.md`) and is wired into the install docs and plugin manifests.
- **`npx skills` install** — one-command setup via the Vercel Labs `skills` CLI, now the headline install path in `README.md`, `INSTALL.md`, and `INSTALL_FOR_AGENTS.md`: `npx skills add zebracatai/skills` (all skills), `--skill <name>` (one skill), `-a <agent>` to target a host (e.g. `openclaw`), `-g` for user scope.
- **`@zebracat/cli` on npm** — the `zebracat` CLI now installs with `npm install -g @zebracat/cli` (the curl install script is kept as a fallback), replacing the previous "install per your package channel" placeholders across the install docs and the transport-ladder fallback message. Verify with `zebracat auth status`.
- **First-class OpenClaw support** — OpenClaw is listed alongside Claude Code / Cursor / Codex everywhere, with its `~/.openclaw/skills/` path and install commands (`npx skills add zebracatai/skills -a openclaw`, `clawhub install zebracat-skills`, or git clone).
- **Browse-all-skills link** — `https://mcp.zebracat.ai/skills` added to the README.

### Changed

- Content polish across the original five `SKILL.md` files and their `references/` — tightened wording and fixed clarity issues (e.g. the language-validation note and a stale troubleshooting pointer in zebracat-translate). No API tools, endpoints, or parameters changed.
- Bumped `VERSION` and each `SKILL.md` frontmatter to `1.1.0`.

[1.1.0]: https://github.com/zebracatai/skills/releases/tag/v1.1.0

## [1.0.0] - 2026-06-25

Initial release.

### Added

- **zebracat-video** — flagship producer skill. Turns an idea, script, blog URL, or audio file into a finished video across five video types (AI Video, Moving AI Images, AI Avatar, Stock Footage, Brainrot). Full producer workflow: intent discovery (purpose, audience, platform→aspect, duration, tone, language), video-type / style / voice selection, script generation, generation, silent polling, and delivery. References: `prompt-craft.md`, `video-types.md`, `styles.md`, `troubleshooting.md`.
- **zebracat-avatar** — choose or customize an avatar presenter, or build a reusable named character; writes an `AVATAR-<NAME>.md` state file (Appearance / Voice / Zebracat IDs) that zebracat-video reads. References: `avatar-selection.md`, `troubleshooting.md`.
- **zebracat-translate** — dub and caption an existing video into one or more of 170+ languages, with regional-variant and RTL handling. Reference: `languages.md`.
- **zebracat-brainrot** — viral short-form fast lane (subway-surfers / minecraft-parkour / italian-brainrot / general) over the brainrot video type. Reference: `formats.md`.
- **zebracat-voice** — browse, preview, and clone voices; pick a tone; returns a `voice_id`. References: `voice-cloning.md`, `tones.md`.
- **Transport ladder** — three ways to reach Zebracat (MCP OAuth, `zebracat` CLI, REST API), documented in `CLAUDE.md` and every `SKILL.md`. Hard rule: `ZEBRACAT_API_KEY` set ⇒ CLI/REST; unset ⇒ MCP OAuth (preferred for end users).
- **Shared state** — `AVATAR-<NAME>.md` files and an append-only `zebracat-video-log.jsonl` learning log at the workspace root.
- **Skill chaining** — avatar → video, voice → video, video → translate, video → brainrot.
- **Repo scaffolding** — `README.md`, `INSTALL.md`, `INSTALL_FOR_AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `LICENSE` (MIT), `VERSION`, this changelog; plugin manifests for Claude Code / OpenClaw (`.claude-plugin/`), Codex (`.codex-plugin/`), and Cursor (`.cursor-plugin/`); MCP server config (`.mcp.json`, `mcp.json`); and an opt-in `scripts/update-check.sh`.

[1.0.0]: https://github.com/zebracatai/skills/releases/tag/v1.0.0
