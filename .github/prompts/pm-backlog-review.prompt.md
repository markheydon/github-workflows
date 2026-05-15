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

- Count of unlabelled issues and PRs (needing triage)
- Open PRs not yet on the project board
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

## Step 0 - Read current board state

Before fetching issues, read the project board at https://github.com/users/markheydon/projects/6:
- Count items per Status column.
- Identify stalled items (in **Up Next** for 3+ days without moving).
- Note items in **Blocked** and **Ice Box** - are they still appropriately parked?
- Calculate active load (Up Next + In Progress combined).

Present a brief board snapshot before proceeding.

---

## Step 1 - Fetch open issues and PRs using repo priorities

**First, read `plan/REPO_PM_PARTICIPATION.md`** and determine participation mode for each repo:
- `full` repos participate normally
- `observe` repos are included in review and planning, but not triage or shared label enforcement
- `exclude` repos are skipped entirely

**Then, read `plan/REPO_PRIORITIES.md`**. Apply these rules when scanning:
- Fetch issues from Tier 1, Tier 2, and Tier 3 repos only. Skip **Not PM Tracked** and **Paused** repos for issue scanning.
- Always fetch PRs from **all non-`exclude` repos** regardless of tier - PRs surface on the board regardless of repo priority.
- In the prioritised backlog summary (Step 3), order items by tier: Tier 1 repos first, then Tier 2, then Tier 3.
- When flagging stale repos (no activity in 14 days), apply this only to Tier 1 and Tier 2 - Tier 3 repos are low priority by design and need not be flagged.

For `observe` repos, fetch open issues and PRs for visibility, but do **not** assume the shared `epic` / `story` / `bug` labels are present. Use the repo's `Selection Notes` from `plan/REPO_PM_PARTICIPATION.md` to decide what likely counts as ready work.

Run the following for **all applicable `markheydon` repos** (applying the tier rules above):

```sh
gh repo list markheydon --json name,isArchived --limit 100
gh issue list --repo <owner/repo> --state open --json number,title,labels,milestone,assignees,updatedAt --limit 100
gh pr list --repo <owner/repo> --state open --json number,title,labels,milestone,assignees,updatedAt,author,isDraft --limit 100
```

For PRs, note the author. Dependabot PRs (`author.login` = `dependabot[bot]` or `dependabot-preview[bot]`) are treated as Stories on the board when added - they are handled separately and do not need core labels. Non-Dependabot PRs are subject to the same labelling and board rules as issues in `full` repos.

For each Tier 1 and Tier 2 repo, note the date of the most recently updated issue or PR. Flag any Tier 1 or Tier 2 repos where nothing has been updated in the last 14 days as **potentially stale** - surface their ready work explicitly so it does not stay forgotten.

---

## Step 2 - Identify problems

Flag any **issues from `full` repos** that:

- ❌ Have **no core label** (`epic`, `story`, or `bug`)
- ❌ Are labelled `story` or `bug` but are **missing from the project board**
- ❌ Are labelled `epic` but appear **on the project board** (they shouldn't be)
- ⚠️ Have no milestone assigned
- ⚠️ Have no `priority-high` modifier but might benefit from one (based on title/description)

Flag any **non-Dependabot PRs from `full` repos** that:

- ❌ Have **no core label** (`story` or `bug`) - these will never appear on the project board
- ❌ Are labelled `story` or `bug` but are **missing from the project board**
- ⚠️ Are draft PRs - note them but do not flag as requiring immediate action
- ⚠️ Have had no activity (commits, comments, review requests) in the last 14 days - these are stale

Do **not** flag Dependabot PRs as labelling problems - they are auto-handled by the workflow.

For `observe` repos:

- Do **not** flag missing core labels as defects.
- Do **not** flag missing board membership based on the shared taxonomy.
- Do flag stale PRs, draft PRs, and work that appears neglected.
- Surface likely next work with an `[observe]` note so it is clear that it comes from a planning-visible, triage-exempt repo.

---

## Step 3 - Backlog summary

Present a prioritised view of actionable items across all repos. Include both issues and PRs in each section:

1. **Urgent** - `priority-high` issues or PRs
2. **PRs awaiting review** - non-Dependabot, non-draft PRs labelled `story` or `bug` that are ready to be merged or reviewed. List these before new stories - unblocking merged work takes priority over starting new items.
3. **Dependabot PRs** - list count and repos. These are already on the board as Stories in Up Next; flag any that are stale (no activity in 14+ days).
4. **Ready to start** - `story` and `bug` items (issues) with no blocking modifier labels
   Include likely next work from `observe` repos here as well, marked `[observe]`.
5. **Stalled on board** - items (issues or PRs) in Up Next for 3+ days (surface these for a decision)
6. **Blocked** - items with `blocked`, `feedback-required`, or `waiting-for-details`
7. **Deferred / Ice Box** - items with `out-of-scope`

For stale repos (no activity in 14 days), call them out separately with their ready items listed (issues and PRs).

---

## Step 4 - Recommendations

Based on the summary, suggest:
- Up to 3 items (issues or PRs) to focus on during the next PM Mode session - PRs awaiting review should rank above new stories unless they are stale or blocked
- Any unlabelled PRs from `full` repos that need triaging (run `/pm-issue-triage` with those PR numbers to label them and get them on the board)
- Any `observe` repo items that should be consciously pulled into this week's focus even though they are not centrally triaged
- Any stalled board items (issues or PRs) that should be moved to **Ice Box** or **Blocked**
- Any issues or PRs that should be re-labelled, closed, or moved
- Whether any epics are close to completion (all child stories closed)
- Any repos that are clearly being neglected and need attention this week
