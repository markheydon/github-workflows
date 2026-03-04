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

- List of open stories and bugs grouped by repository
- Top 3 unblocked items ready to work on right now
- Any epics that are close to completion (all child stories closed)

## What comes next

After your daily summary:
- **Just want to start work?** Pick one of the top 3 items and get going.
- **Need to prioritise or reorganise?** Run `/pm-backlog-review` to see the full prioritised backlog.
- **Planning a new iteration?** Run `/pm-iteration-plan` to commit work to a milestone.

---

**Task:**
1. List all open issues labelled `story` or `bug` across the active repos.
2. Group them by repo.
3. Flag any that are unblocked and ready to work on (no `blocked`, `waiting-for-details`, or `feedback-required` labels).
4. Suggest a top 3 priority for today, with a brief reason for each.
5. Flag any epics that have all their child stories closed (potential epic to close).

Keep the summary concise — this is a quick daily check-in, not a full review.
