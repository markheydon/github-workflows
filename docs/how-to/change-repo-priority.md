---
title: How-to - Change Repo Priority or Pause a Repo
description: Step-by-step guide to updating plan/REPO_PRIORITIES.md to change a repo's priority or pause it.
---

# How-to: Change Repo Priority or Pause a Repo

This guide explains how to update your repository priorities so the Copilot PM workflow prompts surface the right work at the right time.

## Steps

1. **Open `plan/REPO_PRIORITIES.md`** in your repo.
2. **To promote or demote a repo:**
   - Move its row to the appropriate tier table (Active Focus, Medium, Low).
   - Update the Notes column if needed.
3. **To pause a repo:**
   - Move it to the Paused table.
   - Add a reason and a resume condition.
   - When ready to resume, move it back to its previous tier.
4. **To change how a repo participates in PM:**
   - Update `plan/REPO_PM_PARTICIPATION.md`.
   - Use `observe` if the repo should stay visible in planning but keep its own triage process.
   - Use `exclude` if it should be ignored completely.
5. **To change OSS suitability behaviour for a public repo:**
   - In `plan/REPO_PM_PARTICIPATION.md`, set `OSS Override` to `non-oss` for that repo.
   - Leave `OSS Override` as `default` for normal behaviour.
   - OSS suitability checks run in `/pm-backlog-review` only.
6. **Save and commit your changes.**
7. **Next time you run `/pm-backlog-review` or `/pm-iteration-plan`,** the prompts will use your updated priorities.

## Tips

- Keep Tier 1 (Active Focus) small for best results.
- Paused repos are skipped for issue scanning, but PRs are still surfaced unless the repo's participation mode is `exclude`.
- Participation mode is separate from priority. Use `plan/REPO_PM_PARTICIPATION.md` for `full` / `observe` / `exclude`.
- Public repos are treated as OSS by default for backlog-review suitability checks. Private repos are never OSS.
- See [Repository Priorities Reference](../reference/repo-priorities.md) for full details.
