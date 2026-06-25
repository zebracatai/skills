# Changelog

All notable changes to the Zebracat Skills are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
