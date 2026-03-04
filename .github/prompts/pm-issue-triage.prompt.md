---
name: PM Issue Triage
description: Triage new or unlabelled issues. Classifies each as story or bug, applies appropriate labels, and ensures board membership is correct.
argument-hint: Specify a repo (owner/repo) and optionally issue numbers to triage
agent: PM Backlog Manager
---

## When to use this prompt

- **When issues come in without labels** (every few days or as issues arrive).
- **Before `pm-backlog-review`** if you want a clean view of your backlog.
- **Before `pm-iteration-plan`** to make sure everything is labelled.
- **Time:** 5 minutes per 10 issues to triage.

## What you'll get

- Summary of issues reviewed (count and breakdown)
- Proposed labels for each issue (core label + modifiers)
- Issues relabelled and ready to appear on the project board
- Any issues flagged as needing clarification before labelling

## What comes next

After triaging:
- **All issues now labelled.** The workflow will add `story` and `bug` items to the project board.
- **Review the backlog:** Run `/pm-backlog-review` to see the labelled items in priority order.
- **Then plan or pick items:** Use the prioritised view to decide what to work on next.

---

## Step 1 — Find issues to triage

Fetch unlabelled or recently created issues:

```sh
gh issue list --repo <owner/repo> --state open --json number,title,body,labels --limit 50
```

Filter to issues with no core label (`epic`, `story`, or `bug`), or ask me to specify issue numbers.

---

## Step 2 — Classify each issue

For each issue, apply the triage decision flow:

1. Read the title and body
2. Determine the core label: `epic`, `story`, or `bug`
3. Identify any applicable modifier labels
4. Show your classification reasoning briefly

Present results as a table before applying anything:

| # | Title | Proposed Core | Proposed Modifiers | Reasoning |
|---|-------|---------------|-------------------|-----------|
| 42 | Fix login error | `bug` | `priority-high` | Describes broken behaviour; affects all users |

---

## Step 3 — Confirm and apply

Wait for me to confirm the table (or adjust individual rows).

Once confirmed, apply labels using:

```sh
gh issue edit <number> --repo <owner/repo> --add-label "<label>"
```

---

## Step 4 — Board check

After labelling:
- Issues now labelled `story` or `bug` should appear on the project board once the workflow runs (triggered on label event)
- If any `epic` issues were previously on the board, flag them for removal

---

## Step 5 — Summary

Report what was triaged: how many issues classified, label breakdown (`epic`/`story`/`bug`), and any issues skipped due to needing more information.
