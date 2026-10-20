# Changelog

All notable changes to the Zebracat Skills are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
