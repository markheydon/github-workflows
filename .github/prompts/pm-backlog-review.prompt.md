---
name: PM Backlog Review
description: Review and prioritise your open backlog. Flags unlabelled issues, items missing from the board, and suggests priority ordering.
agent: PM Backlog Manager
---

## When to use this prompt

- **Weekly** (typically after `pm-daily` or standalone) to see the full prioritised backlog.
- **After triaging new issues** to understand the overall state of your work.
- **Before planning an iteration** to identify what's ready to commit.
- **Time:** 5-10 minutes to run.

## What you'll get

- Count of unlabelled issues (needing triage)
- Urgent items (labelled `priority-high`)
- Unblocked stories and bugs ready to start
- Blocked or deferred items (waiting for feedback, out of scope)
- Suggested next 3 items to focus on
- Epics nearing or already completed

## What comes next

After your backlog review:
- **Unlabelled issues found?** Run `/pm-issue-triage` to label them, then come back here for an updated view.
- **Ready to commit work?** Run `/pm-iteration-plan` to assign issues to a milestone.
- **Just want to pick something?** Grab one of the suggested items and start.

---

## Step 0 — Read current board state

Before fetching issues, read the project board at https://github.com/users/markheydon/projects/6:
- Count items per Status column.
- Identify stalled items (in **Up Next** for 3+ days without moving).
- Note items in **Blocked** and **Ice Box** — are they still appropriately parked?
- Calculate active load (Up Next + In Progress combined).

Present a brief board snapshot before proceeding.

---

## Step 1 — Fetch open issues across ALL repos

Run the following for **all `markheydon` repos** with open issues (do not limit to a single repo — the point is cross-repo visibility):

```sh
gh repo list markheydon --json name,isArchived --limit 100
gh issue list --repo <owner/repo> --state open --json number,title,labels,milestone,assignees,updatedAt --limit 100
```

For each repo, note the date of the most recently updated issue. Flag any repos where no issue has been updated in the last 14 days as **potentially stale** — surface their ready work explicitly so it does not stay forgotten.

---

## Step 2 — Identify problems

Flag any issues that:

- ❌ Have **no core label** (`epic`, `story`, or `bug`)
- ❌ Are labelled `story` or `bug` but are **missing from the project board**
- ❌ Are labelled `epic` but appear **on the project board** (they shouldn't be)
- ⚠️ Have no milestone assigned
- ⚠️ Have no `priority-high` modifier but might benefit from one (based on title/description)

---

## Step 3 — Backlog summary

Present a prioritised view of actionable items across all repos:

1. **Urgent** — `priority-high` issues
2. **Ready to start** — `story` and `bug` items with no blocking modifier labels
3. **Stalled on board** — items in Up Next for 3+ days (surface these for a decision)
4. **Blocked** — items with `blocked`, `feedback-required`, or `waiting-for-details`
5. **Deferred / Ice Box** — items with `out-of-scope`

For stale repos (no activity in 14 days), call them out separately with their ready items listed.

---

## Step 4 — Recommendations

Based on the summary, suggest:
- Up to 3 issues to focus on during the next PM Mode session
- Any stalled board items that should be moved to **Ice Box** or **Blocked**
- Any issues that should be re-labelled, closed, or moved
- Whether any epics are close to completion (all child stories closed)
- Any repos that are clearly being neglected and need attention this week
