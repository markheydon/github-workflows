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

## Step 1 — Fetch open issues

Run the following for each repo I'm actively working on (or ask me which repos to include):

```sh
gh issue list --repo <owner/repo> --state open --json number,title,labels,milestone,assignees --limit 100
```

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

Present a prioritised view of actionable items:

1. **Urgent** — `priority-high` issues
2. **In-progress** — items without `not-started` or `out-of-scope`
3. **Up next** — `story` and `bug` items that are ready to start
4. **Blocked** — items with `blocked`, `feedback-required`, or `waiting-for-details`
5. **Deferred** — items with `out-of-scope` or `not-started`

Group by epic where applicable.

---

## Step 4 — Recommendations

Based on the summary, suggest:
- Up to 3 issues to focus on next
- Any issues that should be re-labelled, closed, or moved to a different epic
- Whether any epics are close to completion (all child stories closed)
