---
name: PM Daily Focus
description: What should I focus on today? Summarise open stories and bugs across my active repos.
agent: PM Backlog Manager
---

## When to use this prompt

- **Every morning** to see what work is unblocked and ready to pick up.
- **Mid-week check-in** if priorities have shifted and you need a fresh view.
- **Time:** 2-5 minutes to run.

## What you'll get

- Current board state: count of items per Status column (includes both issues and PRs)
- Stalled items: anything in Up Next for 3+ days without moving
- PRs in **In Review** for 3+ days — flagged as potential merge/close candidates
- Top 3 unblocked items to focus on today (from Up Next or high-priority Backlog)
- Any epics that are close to completion (all child stories closed)

## What comes next

After your daily summary:
- **Just want to start work?** Pick one of the top 3 items and get going.
- **Board is a mess / stalled items?** Run `/pm-iteration-plan` to clear the decks and re-curate your Up Next.
- **Need a full backlog review?** Run `/pm-backlog-review`.

---

**Task:**
1. Read the current state of the project board at https://github.com/users/markheydon/projects/6:
   - Count items per Status column.
   - Identify any items in **Up Next** that have been there for 3 or more days without moving (stalled).
   - Identify any **PRs** (look for items with PR numbers — they have `#` prefixes from the `pull_request` content type) in **In Review** that have been there for 3 or more days — these need a merge or close decision, not just deprioritisation.
   - Calculate active load (Up Next + In Progress combined).
2. Summarise board state: total items per column, any stalled items (flag these clearly), any PRs awaiting review decision.
3. Flag the top 3 unblocked items to focus on today — prefer PRs ready to merge/review over new issue work; otherwise prefer items already in **Up Next** that are not stalled; fall back to high-priority Backlog items if Up Next is empty or all stalled.
4. If stalled items exist:
   - For **issues**: suggest moving to **Ice Box** (deprioritise), **Blocked** (add `blocked` label), or keep and re-commit.
   - For **PRs in In Review**: suggest merge, close, or move back to **In Progress** if more work is needed.
5. Flag any epics that have all their child stories closed (potential epic to close).

Keep the summary concise — this is a quick daily check-in, not a full review.
