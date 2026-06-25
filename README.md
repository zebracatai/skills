# Zebracat Skills 🦓

AI agent skills for making video. Describe an idea — your agent writes the script, picks the style and voice, generates the footage, and hands back a finished video. AI Video, Moving AI Images, AI Avatar presenters, Stock Footage, and viral Brainrot, plus voice cloning and 170+ language dubbing.

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

### Option A — `gh skill install` (works across 12+ agents)

Requires [GitHub CLI](https://cli.github.com) v2.90+. Writes to the right directory for your agent automatically (Claude Code, Cursor, Codex, Gemini CLI, Copilot, and more — [agentskills.io](https://agentskills.io)):

```bash
gh skill install zebracatai/skills zebracat-video
gh skill install zebracatai/skills zebracat-avatar
gh skill install zebracatai/skills zebracat-translate
gh skill install zebracatai/skills zebracat-brainrot
gh skill install zebracatai/skills zebracat-voice
```

### Option B — ClawHub

```bash
clawhub install zebracat-skills
```

Installs all five skills to your agent's default skills directory.

### Option C — Git clone

Clone into your agent's skills directory (Claude Code default shown):

```bash
git clone https://github.com/zebracatai/skills.git ~/.claude/skills/zebracat-skills
```

After cloning, the five skills are auto-discovered at `zebracat-video/SKILL.md`, `zebracat-avatar/SKILL.md`, `zebracat-translate/SKILL.md`, `zebracat-brainrot/SKILL.md`, and `zebracat-voice/SKILL.md`.

> Not sure where your skills directory is? Ask your agent: *"Where is your skills directory?"*

## What's Included

Five skills that work standalone or chain together:

| Skill | What it does | Invoke |
|-------|--------------|--------|
| **zebracat-video** | Idea / script / blog URL / audio → finished video. The flagship producer. | `/zebracat:video` |
| **zebracat-avatar** | Choose or customize a presenter, build reusable characters → `AVATAR-<NAME>.md`. | `/zebracat:avatar` |
| **zebracat-translate** | Existing video → dubbed + captioned version in 170+ languages. | `/zebracat:translate` |
| **zebracat-brainrot** | Viral short-form: subway-surfers / minecraft-parkour / italian-brainrot / general. | `/zebracat:brainrot` |
| **zebracat-voice** | Browse, preview, and clone voices; pick a tone → `voice_id`. | `/zebracat:voice` |

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
| 3 | **CLI (OAuth)** | `zebracat auth login` session | Account credit | Interactive CLI users |

**The rule:** if `ZEBRACAT_API_KEY` is set, the skills use the CLI (or REST) with it. Otherwise they use MCP via OAuth — no key handling, bills your plan credits.

- **MCP (zero-setup if on a plan):** connect `https://mcp.zebracat.ai/mcp/` to your agent. First call triggers OAuth in your browser.
- **API key (pay-as-you-go):** get a key from your Zebracat account, then `export ZEBRACAT_API_KEY=sk-…`.

## Things to Try

| Prompt | What happens |
|--------|--------------|
| "Make a 30-second cinematic AI video about our launch. Ask me what you need." | Producer flow: intent → style → voice → render → link. |
| "Turn this blog post into a 60-second explainer: [URL]" | Fetches the article, scripts it, generates the video. |
| "Set up an AI avatar presenter, then record a 30s intro." | zebracat-avatar → `AVATAR-NAME.md` → zebracat-video. |
| "Make a subway-surfers brainrot short about this fact." | zebracat-brainrot: vertical, fast captions, gameplay background. |
| "Clone my voice from this recording and use it in a video." | zebracat-voice → `voice_id` → zebracat-video. |
| "Translate this video into Spanish, German, and Japanese." | zebracat-translate: one dubbed + captioned video per language. |

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
- [Installation guide](INSTALL.md) · [For agents](INSTALL_FOR_AGENTS.md)
- [Contributing](CONTRIBUTING.md) · [Changelog](CHANGELOG.md)

## License

MIT
