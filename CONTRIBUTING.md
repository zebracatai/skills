# Contributing to Zebracat Skills

Thanks for improving the Zebracat Skills. The skill files **are the product** — an agent reading only `SKILL.md` (plus its `references/`) must be able to execute the whole workflow correctly.

## Git Workflow

All changes go through pull requests off `main`.

```bash
# 1. Branch from main
git checkout main && git pull
git checkout -b <type>/<short-description>
# e.g. feat/audio-entry, fix/transport-ladder, docs/readme

# 2. Make changes, commit with a clear message
git add -A
git commit -m "Short summary of what changed

- Bullet points explaining WHY, not just what
- Note any change to a SKILL.md interface or transport rule"

# 3. Push and open a PR
git push -u origin <branch-name>
gh pr create --title "Short summary" --body "What / Why / Changes / Testing"
```

### Branch naming

| Prefix | Use for |
|--------|---------|
| `feat/` | New capability (new phase, new entry method, new skill) |
| `fix/` | Bug fix (transport detection, polling, prompt rules) |
| `refactor/` | Internal cleanup, no behavior change |
| `docs/` | README / INSTALL / CONTRIBUTING / references only |

## Repository layout

Eight **independent, self-contained skills**, each owning its own `references/`:

```
zebracat-video/      SKILL.md + references/{prompt-craft,video-types,styles,troubleshooting}.md
zebracat-avatar/     SKILL.md + references/{avatar-selection,troubleshooting}.md
zebracat-voice/      SKILL.md + references/{voice-cloning,tones}.md
zebracat-brand/      SKILL.md + references/brand-kit.md
zebracat-script/     SKILL.md + references/script-craft.md
zebracat-image/      SKILL.md + references/image-styles.md
zebracat-brainrot/   SKILL.md + references/formats.md
zebracat-translate/  SKILL.md + references/languages.md
```

There is **no root `SKILL.md`** and **no root `references/`**. Edit references inside the skill that owns them. If two skills share a doc (e.g. both have `troubleshooting.md`), edit the relevant copy — drift between independent skills is acceptable.

## The rules that keep skills good

1. **The 300-line rule.** Each `SKILL.md` stays under ~300 lines — it's injected into every prompt turn. Decision logic stays in `SKILL.md`; procedures, tables, and examples move to `references/`. The test: if removing a section would NOT break the agent's ability to decide what to do next, it belongs in `references/`.
2. **One transport, picked silently.** Every skill follows the transport ladder in [CLAUDE.md](./CLAUDE.md): `ZEBRACAT_API_KEY` set ⇒ CLI/REST; unset ⇒ MCP. Never narrate the choice. Show MCP and CLI side by side in operation blocks.
3. **Producer voice, not form-filling.** User-facing output reads like a creative collaborator: ask one or two questions at a time, infer from context, no IDs or raw payloads in chat.
4. **Language awareness.** Detect and reply in the user's language; keep technical args (`video_type`, `aspect_ratio`, style/voice ids, mood enums) in English.
5. **Keep the brand voice.** Purple-and-zebra, crisp and professional. The only emoji is the announcement line (`🦓 **Using: …**`). No emoji spam.
6. **JSONL log convention.** Skills that finish a video append one line to `zebracat-video-log.jsonl`.

## PR review checklist

Before merging, confirm:

1. `SKILL.md` is under ~300 lines and is the source of truth — if behavior changed, the file reflects it.
2. The transport ladder is intact and the hard rule (`ZEBRACAT_API_KEY` ⇒ CLI/REST) is honored.
3. MCP and CLI examples are present and correct for any new operation.
4. No internal jargon or transport narration leaked into user-facing copy.
5. Commit messages explain *why*, not just "updated SKILL.md".
6. `VERSION`, `CHANGELOG.md`, and the plugin manifest versions are bumped together for a release.

## Versioning

Releases use [semantic versioning](https://semver.org). Bump `VERSION`, the `version:` in each `SKILL.md` frontmatter, the plugin manifest versions (`.claude-plugin/`, `.codex-plugin/`, `.cursor-plugin/`), and add a `CHANGELOG.md` entry — all in the same PR.
