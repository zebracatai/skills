# Zebracat Skills — Installation Guide for AI Agents

Read this entire file, then follow the steps. Ask the user for an API key or MCP connection when needed. Target: ~5 minutes to a working Zebracat integration that ends with a real video.

This file is the agent-facing companion to [`INSTALL.md`](./INSTALL.md) (human-facing). Where they overlap, **this file is canonical for agent-driven installs.**

## Step 0: If you are not Claude Code

Read [`CLAUDE.md`](./CLAUDE.md) at the repo root first. It defines the runtime contract: the transport ladder, the hard rules, and the shared-state conventions. Claude Code reads it automatically; other agents should fetch it explicitly.

If you fetched this file by URL without cloning yet, the companion files live at:

- `https://raw.githubusercontent.com/zebracatai/skills/main/CLAUDE.md` — runtime contract
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-video/SKILL.md` — flagship producer
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-avatar/SKILL.md` — avatar / character designer
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-voice/SKILL.md` — voice browse / clone
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-brand/SKILL.md` — brand kit
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-script/SKILL.md` — script writer
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-studio/SKILL.md` — Studio tools (hooks, voice-overs, images, clips)
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-swap/SKILL.md` — Character Swap
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-image/SKILL.md` — standalone AI images
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-brainrot/SKILL.md` — viral short-form
- `https://raw.githubusercontent.com/zebracatai/skills/main/zebracat-translate/SKILL.md` — translation / dubbing
- `https://raw.githubusercontent.com/zebracatai/skills/main/INSTALL.md` — human-facing install doc

The API docs written for agents (generated from the live API, so they never drift):

- `https://api.zebracat.ai/docs/llms.txt` (also served at `/llms.txt`) — the llmstxt.org index: guides and reference, one line each
- `https://api.zebracat.ai/docs/llms-full.txt` (also served at `/llms-full.txt`) — every guide and the full endpoint reference in one Markdown file
- `https://api.zebracat.ai/docs/guides/agent-quickstart.md` — one call to a finished video, in curl / Python / JS / MCP / CLI
- `https://api.zebracat.ai/docs/openapi.json` — OpenAPI 3.1

## Step 1: Install the skills

**Preferred — `npx skills` (auto-detects the agent):**

```bash
npx skills add zebracatai/skills                 # all ten skills
npx skills add zebracatai/skills --skill zebracat-video   # just one
```

Force a specific agent with `-a` (`claude-code`, `openclaw`, `cursor`, `codex`) and install at user scope with `-g`. For OpenClaw specifically, `npx skills add zebracatai/skills -a openclaw` or ClawHub (`clawhub install zebracat-skills`) also works.

**Manual clone (if `npx` isn't available).** Each host expects skills at a different path. If unsure, ask the user "which AI coding agent are you running this from?"

| Agent host  | Default install path                       |
|-------------|--------------------------------------------|
| Claude Code | `~/.claude/skills/zebracat-skills`         |
| OpenClaw    | `~/.openclaw/skills/zebracat-skills`       |
| Codex       | `~/.codex/skills/zebracat-skills`          |
| Cursor      | `~/.cursor/skills/zebracat-skills`         |
| Other       | Whatever path the host loads skills from. Ask the user. |

```bash
# Replace <install-path> with the row from the table above:
git clone --single-branch --depth 1 \
  https://github.com/zebracatai/skills.git \
  <install-path>
```

`gh skill install zebracatai/skills <skill>` (per-skill) is another cross-agent option. After install, jump to Step 2.

## Step 2: Pick a transport (the ladder)

The skills reach Zebracat through exactly one of three transports. **Detect, don't guess**, and follow the hard rule.

> **Hard rule:** if `ZEBRACAT_API_KEY` is set, prefer CLI/REST with it. Otherwise prefer MCP OAuth.

Detection order:

1. **CLI (API key)** — `ZEBRACAT_API_KEY` set AND `zebracat auth status` exits 0 → CLI, pay-as-you-go.
2. **REST (API key)** — `ZEBRACAT_API_KEY` set AND no `zebracat` binary → direct HTTPS to `https://api.zebracat.ai/api/v1/public/` with header `X-API-KEY: sk-…`.
3. **MCP (OAuth)** — no `ZEBRACAT_API_KEY` AND `mcp__zebracat__*` tools visible → MCP, plan credits. **Preferred for end users.**
4. **CLI (OAuth)** — no key AND no MCP AND `zebracat` binary present → `zebracat auth login`, account credit.
5. **Neither** — tell the user once how to connect MCP or install the CLI (Step 3).

**First, check for MCP.** If `mcp__zebracat__*` tools are visible and the user hasn't set an API key, MCP is the path of least resistance — OAuth, no key handling, bills the user's plan credits. If MCP is connected and the user is happy with it, **skip to Step 5**. But warn them:

> If you set `ZEBRACAT_API_KEY` later, the skills will short-circuit MCP and use the CLI / REST (pay-as-you-go) instead. To keep using plan credits, leave the key unset.

## Step 3: Connect a transport

### Option A — MCP server (OAuth, no key)

Point your agent at `https://mcp.zebracat.ai/mcp/`. The first call opens a browser OAuth consent flow. Claude Code:

```bash
claude mcp add --transport http zebracat https://mcp.zebracat.ai/mcp/
```

We cannot configure this from inside the skill — the user wires the MCP server into their agent. See [`INSTALL.md`](./INSTALL.md) for OpenClaw and other configs.

### Option B — `zebracat` CLI

Install the CLI:

```bash
npm install -g @zebracat/cli
# or:
curl -fsSL https://raw.githubusercontent.com/zebracatai/zebracat-cli/main/install.sh | bash
```

Then authenticate — either:

```bash
zebracat auth login                 # OAuth, account credit
# or, for pay-as-you-go:
export ZEBRACAT_API_KEY=sk-your-key
```

Verify:

```bash
zebracat auth status
zebracat whoami
```

### Option C — REST (no CLI, no MCP)

Set `ZEBRACAT_API_KEY` and call the public API directly:

```bash
curl -sS https://api.zebracat.ai/api/v1/public/account/balance \
  -H "X-API-KEY: $ZEBRACAT_API_KEY"
```

Account-credit auth instead of a key: `-H "Authorization: Bearer <oauth-token>"`.

## Step 4: Save the API key in the standard location (key path only)

Skip this if the user chose MCP. If they gave you a key, persist it so the agent's process inherits it:

```bash
# In ~/.zshrc, ~/.bashrc, or wherever the user's shell loads env vars:
export ZEBRACAT_API_KEY=sk-...
```

Then ask the user to restart their shell or `source` the file. If the agent runs in a separate process from the user's terminal, they may need to restart the agent host. For a project-local key, drop it in `.env` and tell the user never to commit it.

## Step 5: (Optional) Set up a reusable presenter

If the user wants presenter-led videos (a talking avatar), set up an avatar now so every future video reuses it.

Read [`zebracat-avatar/SKILL.md`](./zebracat-avatar/SKILL.md) and follow the phases. The skill will:

1. Pick a stock avatar (default) or customize one from a description / reference photo.
2. Pair a voice (or hand off to `zebracat-voice` to clone the user's own).
3. Save `AVATAR-<NAME>.md` at the workspace root with `Avatar ID` + `Voice ID`.

There is a STOP gate before saving — if the user aborts, no file is written and no credits are spent. That's correct behavior, not a bug.

**Skip this step** if the user only wants footage-led videos (AI Video, Moving AI Images, Stock Footage, Brainrot) — those don't need an avatar. Jump to Step 6.

## Step 6: Verify the install (opt-in)

Ask the user: **"Want to run a quick smoke test? It generates a short real video and confirms the integration works end-to-end."**

If yes:

```
Use zebracat-video to generate a 15-second vertical AI video about "Zebracat install
working, ready to ship." Render it, save the file locally, and tell me the path.
```

Expected outcome: a vertical `.mp4`, ~15 seconds. If it fails, the common causes in order:

1. **`ZEBRACAT_API_KEY` not in the current shell** (key path) — re-source the profile or restart the agent host.
2. **No credits** — check `get_balance()` / `zebracat account usage`; point the user to billing.
3. **Transport not detected** — confirm `zebracat auth status` (CLI) or that `mcp__zebracat__*` tools are visible (MCP).
4. **MCP vs key conflict** — `ZEBRACAT_API_KEY` set forces CLI/REST. To use MCP plan credits, `unset ZEBRACAT_API_KEY`.

If the user declines, skip to Step 7. The skills work either way; the smoke test just removes uncertainty.

## Step 7: Done

The skills now have a transport, an authenticated account, and (optionally) a reusable presenter. Tell the user:

> Zebracat Skills are installed. Try:
> - "Make a 30-second vertical video about [topic] — ask me what you need."
> - "Turn this blog post into a 60-second explainer: [URL]"
> - "Make a subway-surfers brainrot short about [fact]."
> - "Translate this video into Spanish and German: [URL]"

The skills handle intent discovery, scripting, style + voice selection, generation, polling, and delivery. Give a topic, let them do the rest.

## Upgrade

- Installed via `npx skills`: re-run `npx skills add zebracatai/skills` to pull the latest.
- Installed via git clone: `cd <install-path> && git pull origin main`.
- Installed via ClawHub: `clawhub update zebracat-skills`.

Re-read the active skill's `SKILL.md` after an upgrade if the version bumped — the transport ladder occasionally gains new options.

## Troubleshooting

**The agent says `ZEBRACAT_API_KEY` is not set, but the user exported it.** The export only applies to the shell that ran it. If the agent is a separate process, the export must be in `~/.zshrc` / `~/.bashrc` and re-sourced (or used in a fresh shell).

**MCP tools listed but the skill uses the CLI / REST.** `ZEBRACAT_API_KEY` being set short-circuits MCP. To make MCP the chosen transport, `unset ZEBRACAT_API_KEY` and re-detect.

**The CLI works in the terminal but the agent can't find it.** The agent's PATH differs from the user's interactive shell. Add the CLI's location to a PATH the agent inherits.

## What this skill does NOT do

- It does not create a Zebracat account — the user must already have one with MCP access or an API key.
- It does not bill or upgrade the user's plan. If they run out of credits, point them to Zebracat billing.
- It does not store or transmit the API key anywhere outside the local agent environment.
