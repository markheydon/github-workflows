---
name: PM Iteration Plan
description: Plan an iteration. Groups open stories and bugs by epic, suggests which to include, and helps assign milestones.
argument-hint: Specify the repo(s) and target milestone name or number
agent: PM Backlog Manager
---

## When to use this prompt

- **Once a week or sprint** to commit work to a specific milestone.
- **After `pm-backlog-review`** to have context on what's ready.
- **To scope an iteration** (aim: complete one epic, or 3-5 stories with related bugs).
- **Time:** 5-10 minutes to run.

## What you'll get

- Stories and bugs grouped by parent epic
- Suggested iteration scope (e.g., "2 epics, 6 stories, 2 bugs")
- Issues assigned to the target milestone
- Link to the project board view filtered to this iteration

## What comes next

After planning your iteration:
- **Milestone created and issues assigned.** Your iteration is now live on the project board.
- **Start work:** Grab items from the top epic and work down logically.
- **Tracking progress:** Check the board daily to move items through the status columns as you work.
- **Next iteration:** Once this one is mostly done, run `/pm-iteration-plan` again for the next cycle.

---

Ask me: *"Which repo(s) should I pull issues from, and do you have a target milestone name or number?"*

---

## Step 1 — Fetch candidate issues

```sh
gh issue list --repo <owner/repo> --state open --label "story" --json number,title,labels,milestone --limit 100
gh issue list --repo <owner/repo> --state open --label "bug" --json number,title,labels,milestone --limit 100
```

Exclude issues labelled `out-of-scope` or `blocked` (unless I ask to include them).

---

## Step 2 — Group by epic

For each open `story` and `bug`, identify its parent epic (look for mentions in the issue body or title pattern). Present a grouped view:

```
Epic #10 — User Authentication
  story #15 — Implement login page
  story #16 — Add password reset flow
  bug #22 — Login fails on mobile Safari

Epic #11 — Reporting
  story #18 — Export to CSV
  story #19 — Dashboard charts

No epic
  bug #25 — App crashes on startup
```

---

## Step 3 — Suggested iteration scope

Recommend which issues to include based on:
- `priority-high` items first
- Bugs before new stories (unless the story is more urgent)
- Prefer completing an epic over starting a new one
- Avoid including anything with `blocked` unless the blocker is resolved

Present as a proposed iteration list with estimated scope (number of issues).

---

## Step 4 — Apply milestone

If I confirm the scope, assign the milestone to each selected issue:

```sh
gh issue edit <number> --repo <owner/repo> --milestone "<milestone-name>"
```

If the milestone doesn't exist yet, create it first:

```sh
gh api repos/<owner/repo>/milestones -f title="<milestone-name>" -f state="open"
```

---

## Step 5 — Summary

Confirm: how many stories, how many bugs, which epics are in play, and how to view the iteration on the project board.
