---
title: Reference - Repository Priorities File
description: Technical reference for plan/REPO_PRIORITIES.md and how it controls repo scanning and prompt behaviour.
---

# Reference: Repository Priorities File

The `plan/REPO_PRIORITIES.md` file defines which repositories are considered high, medium, or low priority for issue scanning, and which are paused or not PM tracked for issue scanning. It is the single source of truth for all Copilot PM prompts and agents when deciding which repos to scan for issues and how to order proposals.

## Structure

- **Tier 1 - Active Focus:** Highest priority. Issues from these repos are always considered first for Up Next. Keep this tier small.
- **Tier 2 - Medium Priority:** Considered after Tier 1. Good for background or less urgent work.
- **Tier 3 - Low Priority:** Only considered if there is capacity after Tier 1 and 2. Long-running or low-urgency projects.
- **Paused:** Temporarily suspends issue scanning for a repo without changing its tier. PRs are still always surfaced.
- **Not PM Tracked:** Repos skipped for issue scanning. PRs are still always surfaced.

## Rules

- **PRs from any repo** (including Not PM Tracked and Paused) are always surfaced and must be resolved.
- To promote/demote a repo, move its row to the appropriate tier table.
- To pause a repo, move it to the Paused table with a reason and resume condition.
- To permanently exclude a repo, add it to `plan/EXCLUDED_REPOS.md`.

## Usage in Prompts

- `/pm-backlog-review` and `/pm-iteration-plan` both read this file to determine which repos to scan for issues and how to order candidates.
- Only Tier 1, 2, and 3 repos are scanned for issues. Not PM Tracked and Paused are skipped.
- PRs are always included, regardless of tier.
- When proposing work, prompts order candidates by tier: Tier 1 first, then Tier 2, then Tier 3.

See the file itself for the latest tier assignments: [plan/REPO_PRIORITIES.md](../../plan/REPO_PRIORITIES.md)
