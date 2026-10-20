---
version: 1.2.0
name: zebracat-swap
description: |
  Zebracat Character Swap: replace the main person in a video with a character from a picture,
  keeping the motion, the camera and the original sound. The same engine and prices as the
  dashboard's Swap page; the result is a normal Zebracat project you can edit.
  Use when: (1) "put me / my mascot / this character in this video", "swap the person in this
  clip", "replace the presenter with …"; (2) "make this TikTok with my avatar instead of them".
  Needs: a clip on Zebracat storage, a picture of the character (or a saved AI character), a paid
  plan, and the user's consent that it is them or they have the person's permission.
  Chain signal: to make a new video from a brief → zebracat-video; to design a reusable character
  first → zebracat-avatar, then come back with its picture.
  NOT for: making videos from text (zebracat-video), cloning a video's style onto a new topic
  (zebracat-video clone), voice changes (zebracat-voice).
argument-hint: "[video url] [character picture]"
homepage: https://zebracat.ai
allowed-tools: Bash, WebFetch, Read, Write, mcp__zebracat__*
metadata:
  openclaw:
    requires:
      env: [ZEBRACAT_API_KEY]
    primaryEnv: ZEBRACAT_API_KEY
---

# Zebracat Character Swap 🦓

Put a character in place of the main person in a clip. Read the full guide when a field is unclear:
https://api.zebracat.ai/docs/guides/character-swap.md

## Skill Announcement

> 🦓 **Using: zebracat-swap** — swapping in your character

## Hard rules

1. **Consent is the user's to give.** Ask, in plain words: "Is this you, or do you have the person's permission to
   use their likeness?" Only a clear yes becomes `consent: true`. Never assume it, never fill it in for them.
2. **Price before spending.** Show the quote (credits per second × seconds) and wait for a yes.
3. **Refusals are final.** Public figures, minors and explicit content are refused (`refused`): say so and stop. Do
   not retry with another crop or wording.
4. One transport, picked silently (ladder in [CLAUDE.md](../CLAUDE.md)).

## Steps

| Step | MCP | REST (`/api/v1/public/…`) | CLI |
|------|-----|---------------------------|-----|
| 1. Can this account swap? price, length cap, consent text | — | `GET character-swap/options` | — |
| 2. Find the people in the clip | `analyze_character_swap(video_url)` | `POST character-swap/analyze {video_url}` | (inside `zebracat swap`) |
| 3. Price | `swap_character(…)` without `confirmed` | `POST character-swap {…, "dry_run": true}` | `zebracat swap … --dry-run` |
| 4. Swap (after yes) | `swap_character(…, confirmed=true)` | `POST character-swap {…}` → `202 {job_id, project_id}` | `zebracat swap --video <url> --character <image-url> --consent --yes --wait` |
| 5. Result | `get_character_swap(job_id)` | `GET character-swap/{job_id}` | (`--wait`) |

`swap_character` / `POST character-swap` fields: `analysis_id` (step 2), `person` (a `people[].id`; the main person
when omitted), `character_image_url` **or** `character_id` (a saved AI character), `consent`, optional
`quoted_credits` (from the quote; a moved price answers `price_changed`), `trim_to_cap`.

The analysis lists `people` with `is_main`, `selectable` and a `reason` when one cannot be picked. Default to the
main person; ask only when the user meant someone else.

## Limits

- **Paid plans only** (`upgrade_required` otherwise), whatever the credential.
- **The clip must be on Zebracat storage** (`cdata.zebracat.ai`): ask the user to upload it in the dashboard first if
  it is a link elsewhere.
- **Length:** the plan's video length (`max_seconds`); longer clips are refused unless the user agrees to trim
  (`trim_to_cap: true`).
- Credits are held at start, settled for the seconds delivered, and released in full on any failure.

## Deliver

`status` runs `queued` → `swapping` → `done` (`result.video_url`, `result.credits_charged`) or `failed` (`error`,
`refunded: true`). Send the video link and the editor link for `project_id`
(`https://studio.zebracat.ai/storyboard/<project_id>`).

## Errors

| `code` | Action |
|--------|--------|
| `upgrade_required` | Swap needs a paid plan: say so. |
| `refused` | The safety check said no: say why (`message`) and stop. |
| `insufficient_credits` | Show `required` vs `available`; point to billing. |
| `api_key_billing_pending` | This server has not switched API-key billing on: use the MCP/OAuth path. |
| `price_changed` | Re-quote and ask again. |
| `invalid` on `analysis_id` | The analysis expired: analyze again. |
