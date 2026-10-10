# CLAUDE.md — Zebracat Skills

## What This Is

The Zebracat Skills. Eight independent, self-contained skills for AI video generation:

- **zebracat-video** — idea / script / blog URL / audio → finished video. The flagship producer. Consumes avatars and characters from zebracat-avatar and voices from zebracat-voice.
- **zebracat-avatar** — design a reusable AI avatar presenter or named character. Output (an `AVATAR-<NAME>.md` state file) is reused by zebracat-video.
- **zebracat-voice** — browse, preview, and clone voices; pick a tone. Output (a `voice_id`) is reused by zebracat-video and zebracat-avatar.
- **zebracat-brand** — set up and manage a reusable brand kit (name, logo, colors, fonts, tone). Reused by zebracat-video so videos come out on-brand.
- **zebracat-script** — write and refine a voice-over script synchronously (no render credits). Hands the approved script to zebracat-video.
- **zebracat-image** — generate standalone AI images (thumbnails, hero shots, reference frames) in 9:16 / 16:9 / 1:1. Returns image URLs.
- **zebracat-brainrot** — viral short-form (subway-surfers / minecraft-parkour / italian-brainrot / general). A specialized fast lane over zebracat-video.
- **zebracat-translate** — existing video → dubbed video in another language with captions. Independent of the others.

Each skill ships its own bundle of references so it installs cleanly via `npx skills`, `gh skill install`, ClawHub, a plugin manifest, or direct git clone.

## Architecture

Skill → prompt files → Zebracat operations index, and a request trace: `docs/ARCHITECTURE.md`.

```
zebracat-skills/
├── CLAUDE.md                   # This file. Runtime contract, transport ladder, hard rules.
├── INSTALL.md                  # Human-facing installation guide
├── INSTALL_FOR_AGENTS.md       # Canonical agent-driven install spec
├── README.md                   # Public-facing description
├── CONTRIBUTING.md             # PR workflow
├── CHANGELOG.md
├── LICENSE
├── VERSION
├── .mcp.json + mcp.json        # MCP server config (root-level, used by plugin manifests)
├── .claude-plugin/             # Claude Code / OpenClaw plugin manifest + marketplace
├── .codex-plugin/              # Codex plugin manifest
├── .cursor-plugin/             # Cursor plugin manifest
├── scripts/
│   └── update-check.sh         # Opt-in version-check shell script
├── zebracat-video/             # Flagship producer skill
│   ├── SKILL.md
│   └── references/
│       ├── prompt-craft.md
│       ├── video-types.md
│       ├── styles.md
│       └── troubleshooting.md
├── zebracat-avatar/            # Avatar + character designer
│   ├── SKILL.md
│   └── references/
│       ├── avatar-selection.md
│       └── troubleshooting.md
├── zebracat-voice/             # Voice browse + clone
│   ├── SKILL.md
│   └── references/
│       ├── voice-cloning.md
│       └── tones.md
├── zebracat-brand/             # Brand kit (logo, colors, fonts, tone)
│   ├── SKILL.md
│   └── references/
│       └── brand-kit.md
├── zebracat-script/            # Voice-over script writer
│   ├── SKILL.md
│   └── references/
│       └── script-craft.md
├── zebracat-image/             # Standalone AI image generation
│   ├── SKILL.md
│   └── references/
│       └── image-styles.md
├── zebracat-brainrot/          # Viral short-form
│   ├── SKILL.md
│   └── references/
│       └── formats.md
└── zebracat-translate/         # Dubbing / localization
    ├── SKILL.md
    └── references/
        └── languages.md
```

*No root SKILL.md, no root references/.* The eight skills are independent. If shared docs drift between them, that's acceptable — each skill is internally consistent and authored independently.

## The 300-Line Rule

Each SKILL.md must stay under ~300 lines. Skill files are injected into EVERY prompt turn.

**What stays in SKILL.md:**
- Frontmatter (name, description, triggers, env requirements)
- Phase flow overview (what phases exist, when to enter each)
- Decision trees (transport detection, video-type selection, style selection)
- Critical rules that apply EVERY turn
- Short "Read references/X.md for details" pointers at each phase

**What moves to references/:**
- REST request/response shapes and full curl examples
- Step-by-step procedural instructions
- Classification tables and routing matrices
- Full prompt examples and style/voice galleries
- Error-handling patterns

**The test:** If removing a section from SKILL.md would NOT break the agent's ability to decide what to do next, it belongs in references/. If it WOULD break decision-making, it stays.

## The Transport Ladder (read this once, pick one, never narrate it)

Every skill reaches Zebracat through exactly one of three transports. Detect at session start, pick one, and never mention the choice to the user.

### 1. MCP (OAuth) — PREFERRED for end users

If `mcp__zebracat__*` tools are available in the toolset, use them. OAuth on first call (browser consent) — **no API key needed**, and calls bill against the user's normal Zebracat plan credits.

- Server: `https://mcp.zebracat.ai/mcp/`
- Tool namespace: `mcp__zebracat__*`
- Skills declare `allowed-tools: ... mcp__zebracat__*` in frontmatter.

### 2. CLI — the `zebracat` binary

If the `zebracat` binary is installed (`zebracat version` exits 0), use it. The CLI is API-key only: either the `ZEBRACAT_API_KEY` env var, or a key saved by `zebracat auth login` (it prompts for the key, or reads it from stdin / `--api-key`). Both bill pay-as-you-go from the account's API balance; the CLI never spends plan credits. `zebracat auth status` succeeds even when signed out, so read its `"authenticated"` field.

- Pattern: `zebracat <noun> <verb>` — e.g. `zebracat video create`, `zebracat voice list`.
- Output: JSON on stdout (add `--human` for tables). Add `--wait` on creation commands to block until completion.

### 3. REST API — direct HTTP

When neither MCP nor CLI is present, call the public REST API directly.

- Base: `https://api.zebracat.ai/api/v1/public/`
- Auth header: `X-API-KEY: sk-...` (pay-as-you-go) **or** `Authorization: Bearer <oauth-token>` (account credit).

### Hard rule (decides MCP vs CLI/REST)

> **If `ZEBRACAT_API_KEY` is set, prefer the CLI/REST path with it. Otherwise prefer MCP OAuth.**

Detection order, in full:

1. **CLI (API key)** — `ZEBRACAT_API_KEY` is set AND `zebracat` CLI works → CLI with the key (pay-as-you-go). The API key is an explicit signal the user wants direct/billed access; it short-circuits MCP.
2. **REST (API key)** — `ZEBRACAT_API_KEY` is set AND no CLI → direct REST with `X-API-KEY`.
3. **MCP (OAuth)** — no `ZEBRACAT_API_KEY` AND `mcp__zebracat__*` tools visible → MCP, plan credits. **This is the preferred end-user path.**
4. **CLI (saved key)** — no `ZEBRACAT_API_KEY` AND no MCP AND `zebracat auth status` reports `"authenticated": true` (a key saved by `zebracat auth login`) → CLI, pay-as-you-go.
5. **Neither** — tell the user once: *"To use this skill, connect the Zebracat MCP server (`https://mcp.zebracat.ai/mcp/`) or install the Zebracat CLI (`npm install -g @zebracat/cli`) and run `zebracat auth login` with a Zebracat API key."*

**Never cross transports mid-session.** Read only the column for your detected transport in each SKILL.md's operation blocks. If something isn't exposed in your transport, tell the user — don't silently switch.

## Hard Rules (every skill, every turn)

1. **One transport, picked silently.** MCP vs CLI vs REST is an internal detail. Never say "switching to MCP" or "the CLI is broken."
2. **`ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP.** No exceptions.
3. **Be concise.** No task IDs, raw payloads, or status JSON dumped in chat. Report the result (video link, duration) not the plumbing.
4. **No internal jargon.** Never mention phase names ("Discovery", "Pre-Submit Gate") or transport names to the user.
5. **Polling is silent.** Background long jobs; speak only on completion, hard failure, or a single ">taking longer than usual" update after ~5 min.
6. **Don't batch-ask.** Ask one or two questions at a time, then wait. A request usually carries context you can infer ("30-second product launch" = duration + purpose + tone).
7. **Read workspace files before asking.** `AVATAR-<NAME>.md` and prior log lines hold reusable state. Check them first.
8. **Language awareness.** Detect the user's language from their first message; reply in it. Keep technical args (`video_type`, `aspect_ratio`, style/voice ids, mood enums) in English — they are API directives, not viewer-facing text.
9. **Append a JSONL log line per finished video** to `zebracat-video-log.jsonl` at the workspace root (timestamp, task_id, video_type, duration, status, topic). This is the skills' local learning log.

## Shared State

Skills communicate through plain-text state files at the workspace root:

- **`AVATAR-<NAME>.md`** — one per avatar/character. `zebracat-avatar` writes them (Appearance / Voice / Zebracat IDs); `zebracat-video` reads them and picks up the presenter + voice automatically.
- **`zebracat-video-log.jsonl`** — append-only log, one JSON line per finished video. Human-readable and machine-readable.

## API Conventions

- **MCP tool names ARE the API in MCP mode** (e.g. `create_agentic_video`, `create_video_from_idea`, `list_voices`, `get_video_status`). Never shell out to `zebracat ...` in MCP mode.
- **CLI uses `zebracat <noun> <verb>`** with `--help` on any subcommand as the reference. Never call REST in CLI mode.
- **REST is `https://api.zebracat.ai/api/v1/public/`** with `X-API-KEY` or `Authorization: Bearer`. Only used when neither MCP nor CLI is present.
- **Long jobs are async.** Submit, then either `--wait` (CLI) or poll `get_video_status(task_id)` / `zebracat video status <id>`. Most videos finish in a few minutes; some take longer.
- **`should_render` / `--render`** controls whether the pipeline renders the final MP4 or stops at an editable draft. Default to rendering only after the user has approved the plan, unless they asked to "just make it."

## Key Decisions (do not revisit without data)

1. **MCP is the default for end users** — zero key handling, bills plan credits. The API key path is for agents/CI/pay-as-you-go.
2. **`create_agentic_video` is the lowest-friction entry** — let Zebracat's planner pick `video_type`, style, voice, and duration when the user has no strong preference.
3. **Discover intent before generating.** Purpose, audience, platform→aspect, duration, tone, and language drive every downstream parameter.
4. **One topic per video.** Multi-topic requests become multiple videos.
5. **Approve the plan, then render.** Offer a draft/preview before spending render credits unless the user says "just generate."
6. **Avatars are reusable.** Store `avatar_id` + `voice_id` in `AVATAR-<NAME>.md`; never re-create per video.
