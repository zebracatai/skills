# Architecture — Zebracat Skills

This repo has no code. Each `zebracat-*/SKILL.md` is a prompt an agent loads; its
`references/*.md` are the longer prompt material it reads on demand. The skills call
Zebracat through one transport (MCP, CLI or REST — see `CLAUDE.md` → *Transport Ladder*)
and never run generation themselves.

## Skill map (the prompt index)

| Skill | Prompt files | Zebracat operations (MCP tool names) | Hands off to / consumes |
|---|---|---|---|
| `zebracat-video` | `SKILL.md`, `references/{prompt-craft,video-types,styles,troubleshooting}.md` | `create_agentic_video`, `create_video_from_{idea,script,blog,audio}`, `generate_script`, `get_video_status`, `list_voices`, `list_visual_styles`, `list_prompt_styles`, `get_balance` | reads `AVATAR-<NAME>.md`; writes `zebracat-video-log.jsonl` |
| `zebracat-avatar` | `SKILL.md`, `references/{avatar-selection,troubleshooting}.md` | `list_avatars`, `list_voices`, `get_balance` | writes `AVATAR-<NAME>.md` for zebracat-video |
| `zebracat-voice` | `SKILL.md`, `references/{voice-cloning,tones}.md` | `list_voices`, `get_balance` | returns a `voice_id` to video/avatar |
| `zebracat-brand` | `SKILL.md`, `references/brand-kit.md` | `list_brands` | brand kit reused by zebracat-video |
| `zebracat-script` | `SKILL.md`, `references/script-craft.md` | `generate_script` | approved script → zebracat-video |
| `zebracat-image` | `SKILL.md`, `references/image-styles.md` | `generate_image`, `list_visual_styles` | image URLs |
| `zebracat-brainrot` | `SKILL.md`, `references/formats.md` | `create_agentic_video`, `create_video_from_{idea,script}`, `get_video_status` | fast lane over zebracat-video |
| `zebracat-translate` | `SKILL.md`, `references/languages.md` | `translate_video`, `list_languages`, `get_video_status`, `get_balance` | independent |

CLI and REST equivalents are listed in each SKILL.md's operation blocks. The MCP server is
`https://mcp.zebracat.ai/mcp/` (`mcp.json`, `.mcp.json`); REST is `/api/v1/public/` on the backend;
the CLI is `zebracatai/zebracat-cli`.

## Trace: "make a 30-second video about X"

1. The agent matches the request against each skill's frontmatter `description` → loads `zebracat-video/SKILL.md`.
2. Transport detection (once per session): API key → CLI/REST; otherwise MCP if `mcp__zebracat__*` tools exist.
3. Discovery questions → plan (reads `references/video-types.md`, `styles.md` as needed) → user approves.
4. Submit (`create_agentic_video` or a `create_video_from_*`) → silent polling with `get_video_status`.
5. Deliver the link; append one line to `zebracat-video-log.jsonl`.

## Trace: failure

- Submission or status errors → the skill follows `references/troubleshooting.md` (credits via `get_balance`,
  OAuth consent, or one retry with a corrected brief — never the identical payload). It never switches transport mid-session.
- No transport available → the one-line install hint from `CLAUDE.md`.

## Packaging

`.claude-plugin/`, `.codex-plugin/`, `.cursor-plugin/` hold the plugin manifests; `npx skills`, `gh skill
install` and ClawHub install the skill folders directly (`INSTALL.md`, `INSTALL_FOR_AGENTS.md`).
`VERSION` + `CHANGELOG.md` version the suite; `scripts/update-check.sh` is an opt-in version check.
