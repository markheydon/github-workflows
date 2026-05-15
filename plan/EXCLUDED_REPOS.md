# Excluded Repositories

This file is retained as a legacy reference for the older binary exclusion model.

The source of truth is now [plan/REPO_PM_PARTICIPATION.md](REPO_PM_PARTICIPATION.md), which supports three modes:

- `full` - fully managed by the PM workflow
- `observe` - visible to planning, but exempt from triage and shared label enforcement
- `exclude` - fully out of scope

---

## Current Status

There are currently **no repos managed exclusively through this legacy file**.

Any repo that needs special treatment should be added to [plan/REPO_PM_PARTICIPATION.md](REPO_PM_PARTICIPATION.md) instead.

---

## How to Use This File

### For Humans

- Do not add new entries here.
- Use [plan/REPO_PM_PARTICIPATION.md](REPO_PM_PARTICIPATION.md) instead.
- If you need a hard exclusion, add the repo there with mode `exclude`.

### For Agents

Treat this file as informational only.

1. Read [plan/REPO_PM_PARTICIPATION.md](REPO_PM_PARTICIPATION.md) instead.
2. Use participation mode `exclude` for hard exclusions.
3. Use participation mode `observe` when a repo should stay visible in planning but must not be triaged centrally.

---

## Notes

- Archived repos are automatically excluded by GitHub and do not need to be listed here.
- If a repo is temporarily inactive but may need PM attention later, prefer the project board **Ice Box** status or a lower priority tier before using `exclude`.
