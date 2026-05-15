---
title: Reference - PM Workflow Prompts
description: Prompt catalogue for the Copilot-powered PM workflow.
---

# Reference: PM Workflow Prompts

This page documents the main Copilot PM workflow prompts provided in this repository. Each prompt is a slash command you can run in Copilot Chat or VS Code to automate project management tasks.

## Available Prompts

| Prompt                | Purpose                                                      |
|-----------------------|--------------------------------------------------------------|
| `/pm-assistant`       | Conversational guide to the PM workflow                      |
| `/pm-backlog-review`  | Review all issues/PRs, flag stale work, surface priorities. Uses [repo priorities](repo-priorities.md) to decide which repos to scan and how to order candidates.   |
| `/pm-iteration-plan`  | Curate board for the next few days, resolve stalled items. Uses [repo priorities](repo-priorities.md) to decide which repos to scan and how to order candidates.    |
| `/pm-daily`           | Daily nudge: what to focus on today                         |
| `/pm-issue-triage`    | Triage and label unlabelled issues/PRs                      |
| `/pm-create-story`    | Create a well-formed story issue                            |


## How Repo Priorities Affect Prompts

- Both `/pm-backlog-review` and `/pm-iteration-plan` read [plan/REPO_PRIORITIES.md](../../plan/REPO_PRIORITIES.md) to determine which repos to scan for issues and how to order candidates.
- Both prompts also read `plan/REPO_PM_PARTICIPATION.md` to determine whether each repo is `full`, `observe`, or `exclude`.
- Only Tier 1, 2, and 3 repos are scanned for issues. Not PM Tracked and Paused are skipped for issue scanning, but PRs from all non-`exclude` repos are always included.
- `observe` repos are included in review and planning, but skipped by `/pm-issue-triage` and shared label enforcement.

See [Repository Priorities Reference](repo-priorities.md) for details on the file structure and rules.

---

## How to Use

- Run the prompt in Copilot Chat or VS Code (e.g., `/pm-backlog-review`).
- Follow the interactive guidance to review, triage, or plan work.
- See [Tutorials](../tutorials/) for step-by-step guides.

## Prompt Details

- **pm-assistant:** Entry point; interviews you about your goal and routes you to the right prompt.
- **pm-backlog-review:** Scans all repos, flags unlabelled or stale items, suggests priorities.
- **pm-iteration-plan:** Reads board state, resolves stalled items, curates Up Next.
- **pm-daily:** Summarises board, flags top 3 items to focus on.
- **pm-issue-triage:** Applies labels and ensures board membership.
- **pm-create-story:** Creates a new story issue with standard format.

---

For more, see the [Operating Model](https://github.com/markheydon/github-workflows/blob/main/plan/OPERATING_MODEL.md).
