# Troubleshooting — zebracat-avatar

Error → cause → action across all three transports (MCP, CLI, REST).

---

## Transport & auth

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Can't reach Zebracat | No transport detected | Connect MCP (`https://mcp.zebracat.ai/mcp/`) or install the CLI + `zebracat auth login`. |
| Wrong billing path | `ZEBRACAT_API_KEY` set forces CLI/REST | `unset ZEBRACAT_API_KEY` for MCP plan credits; set it for pay-as-you-go. |
| CLI `zebracat auth status` non-zero | No login / expired / no key | `zebracat auth login` or `export ZEBRACAT_API_KEY=sk-…`. |

> Hard rule: `ZEBRACAT_API_KEY` set ⇒ CLI/REST. Unset ⇒ MCP. See [CLAUDE.md](../CLAUDE.md).

## Selection

| Symptom | Cause | Action |
|---------|-------|--------|
| No avatars match the filter | Filter too narrow | Widen it, or switch to a custom avatar. |
| Previews not loading | Transient CDN / network | Retry the list call; previews are public URLs. |
| User can't decide | Too many options shown | Narrow to 3 strong matches for the audience and re-present. |

## Custom avatar / reference photo

| Symptom | Cause | Action |
|---------|-------|--------|
| Reference photo upload fails | Auth-walled URL, wrong type, too large | Ask for a public image URL or a local file; if it keeps failing, fall back to a stock avatar. |
| Weak likeness | Low-quality source photo | Re-shoot per the photo guidance (front-facing, well-lit), or use a stock avatar. |
| Custom avatar not usable yet | Creation is asynchronous | Wait for it to finish processing before generating a video; confirm readiness, then proceed. |

## Voice pairing

| Symptom | Cause | Action |
|---------|-------|--------|
| No voice fits the character | Catalog filter too tight / wrong language | List the full set, filter by the video language, present 2–3. |
| User wants their own voice | Needs a clone | Hand off to **zebracat-voice**; return with the cloned `voice_id`. |
| Voice doesn't speak the target language | Language mismatch | Re-filter `list_voices(language=<lang>)` and pick a matching voice. |

## AVATAR file

| Symptom | Cause | Action |
|---------|-------|--------|
| zebracat-video can't find the avatar | File missing or ids empty | Confirm `AVATAR-<NAME>.md` exists with a filled `Zebracat` section. |
| Stale ids (old avatar/voice) | Catalog changed since save | Re-list avatars/voices, update the file, bump `Last Synced`. |
| Wrong presenter in a video | zebracat-video read a different AVATAR file | Make sure the requested name matches the file name. |

## Credits

`402` / insufficient credits → check `get_balance()` / `zebracat account usage`, point the user to billing. Stock-avatar selection itself is cheap; custom-avatar creation and test videos consume credits.
