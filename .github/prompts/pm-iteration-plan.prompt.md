---
name: PM Iteration Plan
description: Plan an iteration. Reads board state, resolves stalled items, proposes a curated cross-repo work list, and moves selected items to Up Next on your project board.
argument-hint: Optional — provide a milestone name if you want issues assigned to one (e.g. 'v2.1')
agent: PM Backlog Manager
---

## When to use this prompt

- **Once a week or fortnightly** to commit work to the board for the next few days.
- **After `/pm-backlog-review`** to have full cross-repo context on what's ready.
- **When starting a new cycle** — clear any stalled board items, then populate Up Next with fresh work.
- **Time:** 5–10 minutes to run.

## What you'll get

- A clear view of the current board state (stalled items, capacity)
- A conversation to resolve any stalled Up Next items before adding new work
- A curated list of stories, bugs, and ready-to-review PRs proposed for this week
- Board updated: selected items moved to **Up Next**, stalled items resolved as agreed
- Optional: milestone assignment for selected issues

## What comes next

After planning your iteration:
- **Board is updated.** Up Next now reflects your committed load for the next few days.
- **Switch to Work Mode:** open https://github.com/users/markheydon/projects/6 and pick the first item.
- **Tracking progress:** as you work, move items through In Progress → In Review → Done.
- **Next cycle:** once most items are done, run `/pm-iteration-plan` again to reset.

---

## Step 0 — Read current board state

Before anything else, read the project board at https://github.com/users/markheydon/projects/6:
- Count items per Status column.
- List all items currently in **Up Next** with how long they have been there.
- Identify **stalled items** (in Up Next for 3 or more days without moving to In Progress).
- Calculate current active load (Up Next + In Progress combined).

Present a board snapshot. **Do not continue until this is done.**

---

## Step 1 — Resolve stalled items (if any)

If there are stalled items in Up Next, present them and ask what to do with each:

```
Stalled items in Up Next:
  #15 Add login page — in Up Next for 5 days
  #22 Fix mobile crash — in Up Next for 4 days

For each: move to Ice Box (deprioritise), mark Blocked (apply `blocked` label), or keep and re-commit?
```

Wait for confirmation before moving anything. Kept stalled items count toward capacity.

---

## Step 2 — Calculate capacity and fetch candidates

After resolving stalled items, calculate remaining capacity:
- **Target:** no more than 5 items across Up Next + In Progress combined.
- **Available slots:** 5 minus current count after resolving stalled items.

If available slots = 0, tell the user and do not suggest adding more. Let them decide.

Fetch candidate issues **and PRs** from **all `markheydon` repos** (cross-repo, not single-repo):

```sh
gh issue list --repo <owner/repo> --state open --label "story" --json number,title,labels,milestone,updatedAt --limit 100
gh issue list --repo <owner/repo> --state open --label "bug" --json number,title,labels,milestone,updatedAt --limit 100
gh pr list --repo <owner/repo> --state open --label "story" --json number,title,labels,milestone,updatedAt,author,isDraft --limit 100
gh pr list --repo <owner/repo> --state open --label "bug" --json number,title,labels,milestone,updatedAt,author,isDraft --limit 100
```

Exclude items labelled `out-of-scope` or `blocked`. Exclude draft PRs. Skip Dependabot PRs — they are already on the board.

Prioritise in this order:
1. Non-Dependabot PRs labelled `story` or `bug` that are ready for review/merge (clear these first — unblocking merged work is more valuable than starting new items)
2. `priority-high` issues or PRs
3. `bug` issues
4. `story` issues

---

## Step 3 — Propose iteration scope

Based on available capacity, propose items to add to **Up Next**. Present as a simple list, noting whether each item is an issue or PR:

```
Proposed for Up Next (N slots available):
  #7  Merge CSV export PR [PR, story] — markheydon/my-app  ← ready for review
  #25 Fix app crash on startup [issue, bug] — markheydon/my-app
  #18 Export to CSV [issue, story, priority-high] — markheydon/my-app
  #15 Add login page [issue, story] — markheydon/other-repo
```

Include repo names since this is cross-repo. Ask for confirmation before making any changes.

---

## Step 4 — Update board and optionally assign milestone

Once the user confirms:

1. **Move selected items to Up Next** by updating the Status field via the GitHub Projects v2 API.
2. **Apply milestone** (optional) — only if the user provides a milestone name:

```sh
gh issue edit <number> --repo <owner/repo> --milestone "<milestone-name>"
```

If the milestone doesn't exist yet, create it first:

```sh
gh api repos/<owner/repo>/milestones -f title="<milestone-name>" -f state="open"
```

---

## Step 5 — Summary

Confirm: how many stories, bugs, and PRs were added to Up Next, which repos they came from, and a link to the board:
https://github.com/users/markheydon/projects/6
