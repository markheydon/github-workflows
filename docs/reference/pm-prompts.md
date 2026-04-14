# Reference: PM Workflow Prompts

This page documents the main Copilot PM workflow prompts provided in this repository. Each prompt is a slash command you can run in Copilot Chat or VS Code to automate project management tasks.

## Available Prompts

| Prompt                | Purpose                                                      |
|-----------------------|--------------------------------------------------------------|
| `/pm-assistant`       | Conversational guide to the PM workflow                      |
| `/pm-backlog-review`  | Review all issues/PRs, flag stale work, surface priorities   |
| `/pm-iteration-plan`  | Curate board for the next few days, resolve stalled items    |
| `/pm-daily`           | Daily nudge: what to focus on today                         |
| `/pm-issue-triage`    | Triage and label unlabelled issues/PRs                      |
| `/pm-create-story`    | Create a well-formed story issue                            |

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

For more, see the [Operating Model](../../plan/OPERATING_MODEL.md).
