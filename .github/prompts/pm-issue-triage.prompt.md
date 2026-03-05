---
name: PM Issue Triage
description: Triage new or unlabelled issues and pull requests. Classifies each as story or bug, applies appropriate labels, and ensures board membership is correct.
argument-hint: Specify a repo (owner/repo) and optionally issue/PR numbers to triage
agent: PM Backlog Manager
---

## When to use this prompt

- **When issues or PRs come in without labels** (every few days or as issues/PRs arrive).
- **After `/pm-backlog-review`** flags unlabelled PRs or issues — use those numbers as the argument.
- **Before `pm-backlog-review`** if you want a clean view of your backlog.
- **Before `pm-iteration-plan`** to make sure everything is labelled.
- **Time:** 5 minutes per 10 items to triage.

## What you'll get

- Summary of issues and PRs reviewed (count and breakdown)
- Proposed labels for each item (core label + modifiers)
- Issues and PRs relabelled and ready to appear on the project board
- Any items flagged as needing clarification before labelling

## What comes next

After triaging:
- **All issues now labelled.** The workflow will add `story` and `bug` items to the project board.
- **Review the backlog:** Run `/pm-backlog-review` to see the labelled items in priority order.
- **Then plan or pick items:** Use the prioritised view to decide what to work on next.

---

## Step 1 — Find issues and PRs to triage

Fetch unlabelled or recently created issues and PRs:

```sh
gh issue list --repo <owner/repo> --state open --json number,title,body,labels --limit 50
gh pr list --repo <owner/repo> --state open --json number,title,body,labels,author,isDraft --limit 50
```

Filter to items with no core label (`epic`, `story`, or `bug`), or if specific numbers were provided as an argument, fetch only those.

**Skip Dependabot PRs** (`author.login` = `dependabot[bot]` or `dependabot-preview[bot]`) — they are automatically handled by the workflow. Include them only in the count of already-triaged items.

**Skip draft PRs** — note their existence but do not triage them until they are marked ready for review.

---

## Step 2 — Classify each item

For each issue or PR, apply the triage decision flow:

1. Read the title and body
2. Determine the core label:
   - Issues: `epic`, `story`, or `bug`
   - PRs: `story` or `bug` only (PRs cannot be epics)
3. For PRs, use these signals:
   - Dependency/version bump — `story` (if not Dependabot)
   - Bug fix — `bug`
   - New feature or improvement — `story`
   - Documentation change — `story` + `documentation` modifier
4. Identify any applicable modifier labels
5. Show your classification reasoning briefly

Present results as a table before applying anything. Include a **Type** column to distinguish issues from PRs:

| # | Type | Title | Proposed Core | Proposed Modifiers | Reasoning |
|---|------|-------|---------------|--------------------|----------|
| 42 | Issue | Fix login error | `bug` | `priority-high` | Describes broken behaviour; affects all users |
| 7 | PR | Add CSV export | `story` | | New feature for data export |

---
## Step 2.5 — Validate title format

Before confirming, check each title for format compliance:

- **No `[Type]` prefixes** — Titles should not start with `[Feature]`, `[Bug]`, `[Improvement]`, etc. These are redundant with labels.
- **Title describes what, not type** — Titles should state what specifically needs doing ("Add dark mode toggle" not "[Feature] Add dark mode").

If any title has a prefix:
1. Note it in the Reasoning column as "Title needs cleanup"
2. Suggest a cleaned-up version (e.g., "[Feature] Add dark mode" → "Add dark mode toggle to settings")
3. Include the suggested title in the table for your review

Example:

| # | Title | Suggested Title | Proposed Core | Reasoning |
|---|-------|-----------------|---------------|----------|
| 5 | [Feature] Add export to PDF | Add PDF export functionality | `story` | **Title needs cleanup** — remove `[Feature]` prefix. Suggested: "Add PDF export functionality" |

---
## Step 3 — Confirm and apply

Wait for me to confirm the table (or adjust individual rows).

Once confirmed, apply labels using the appropriate command for each item type:

```sh
# For issues:
gh issue edit <number> --repo <owner/repo> --add-label "<label>"

# For PRs:
gh pr edit <number> --repo <owner/repo> --add-label "<label>"
```

---

## Step 4 — Board check

After labelling:
- Issues and PRs now labelled `story` or `bug` should appear on the project board once the workflow runs (triggered on label event)
- If any `epic` issues were previously on the board, flag them for removal
- Note: PRs cannot carry the `epic` label; if one was inadvertently applied, remove it

---

## Step 5 — Summary

Report what was triaged: how many issues and PRs classified, label breakdown (`epic`/`story`/`bug`), how many Dependabot PRs and draft PRs were skipped, and any items skipped due to needing more information.
