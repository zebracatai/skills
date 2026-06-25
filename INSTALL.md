# Install Zebracat Skills

The repo ships *five* skills you can install:

- **`zebracat-video`** — the flagship producer: idea / script / blog / audio → finished video
- **`zebracat-avatar`** — choose or customize a presenter, build reusable characters
- **`zebracat-translate`** — dub existing videos into 170+ languages with captions
- **`zebracat-brainrot`** — viral short-form (subway-surfers / minecraft-parkour / italian-brainrot)
- **`zebracat-voice`** — browse, preview, and clone voices; pick a tone

Most people start with `zebracat-video`. The others chain into it: `zebracat-avatar` and `zebracat-voice` produce a presenter and a `voice_id` that `zebracat-video` consumes; `zebracat-translate` localizes finished videos; `zebracat-brainrot` is a fast lane for viral shorts.

## Option 1 — `gh skill install` (works across 12+ agents)

With [GitHub CLI](https://cli.github.com) v2.90+, this is the most portable install. `gh skill` writes to the right directory for your agent automatically (Claude Code, Cursor, Codex, Gemini CLI, GitHub Copilot, and more):

```bash
gh skill install zebracatai/skills zebracat-video
gh skill install zebracatai/skills zebracat-avatar
gh skill install zebracatai/skills zebracat-translate
gh skill install zebracatai/skills zebracat-brainrot
gh skill install zebracatai/skills zebracat-voice
```

Project scope (current repo only) is the default. For user scope (every project on this machine), add `--scope user`. Pin to a release tag for reproducibility, e.g. `zebracat-video@v1.0.0 --pin`.

## Option 2 — ClawHub

```bash
clawhub install zebracat-skills
```

Installs all five skills to your agent's default skills directory automatically.

## Option 3 — Git clone

Clone into your agent's skills directory:

**Claude Code** (default: `~/.claude/skills/zebracat-skills`):
```bash
git clone https://github.com/zebracatai/skills.git ~/.claude/skills/zebracat-skills
```

**OpenClaw** (default: `~/.openclaw/skills/zebracat-skills`):
```bash
git clone https://github.com/zebracatai/skills.git ~/.openclaw/skills/zebracat-skills
```

> Not sure where your skills directory is? Ask your agent: *"Where is your skills directory?"*

## Auth — three ways to reach Zebracat

The skills auto-detect a transport at runtime. The full ladder lives in [CLAUDE.md](./CLAUDE.md); the short version:

| Priority | Mode | Trigger | Billing |
|----------|------|---------|---------|
| 1 | **CLI / REST (API key)** | `ZEBRACAT_API_KEY` is set | Pay-as-you-go |
| 2 | **MCP (OAuth)** | MCP tools visible AND no API key | Zebracat plan credits |
| 3 | **CLI (OAuth)** | `zebracat auth login` session | Account credit |

**The rule:** if `ZEBRACAT_API_KEY` is set, the skills use the CLI (or REST) with it. Otherwise they prefer MCP via OAuth.

### MCP (zero-setup if you're on a Zebracat plan)

Connect the Zebracat remote MCP server to your agent — OAuth handles auth, calls use your existing plan credits. No key to manage.

- Endpoint: `https://mcp.zebracat.ai/mcp/`
- Tool namespace: `mcp__zebracat__*`

Claude Code:
```bash
claude mcp add --transport http zebracat https://mcp.zebracat.ai/mcp/
```

OpenClaw — add to `~/.openclaw/openclaw.json`:
```json
{
  "mcp": {
    "servers": {
      "zebracat": { "url": "https://mcp.zebracat.ai/mcp/" }
    }
  }
}
```

The first call triggers an OAuth consent flow in your browser.

### API key (pay-as-you-go, recommended for agents/CI)

Get a key from your Zebracat account, then:

```bash
export ZEBRACAT_API_KEY=sk-your-key-here
```

Ephemeral (current shell only). To persist, add the `export` line to your shell profile (`~/.zshrc`, `~/.bashrc`, or equivalent). If `ZEBRACAT_API_KEY` is set, the skills use the CLI (or REST). This is the most predictable setup for agent workflows.

The `zebracat` CLI pattern is `zebracat <noun> <verb>`; output is JSON on stdout (`--human` for tables). Verify with `zebracat auth status`.

## First Run

Paste this to your agent — it finds the right paths automatically:

> Install the Zebracat Skills from https://github.com/zebracatai/skills.git — clone into your skills directory (find it with your config, or ask if unsure). Then connect the Zebracat MCP server at https://mcp.zebracat.ai/mcp/, or if you have a Zebracat API key, `export ZEBRACAT_API_KEY=sk-…`. Then use zebracat-video to make a 30-second vertical video about [topic] — ask me anything first.
