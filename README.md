# GitHub Workflows & Scripts

This repo centralises and standardises my personal GitHub Actions workflows, utility scripts, Copilot prompt files, and agent definitions. Everything here is tailored to how I work, but feel free to use or adapt anything if it helps you!

## Label Strategy

All repos using this tooling follow a shared label strategy. The single source of truth is [`plan/LABEL_STRATEGY.md`](plan/LABEL_STRATEGY.md).

**Core labels:**

| Label | On Board | Purpose |
|-------|:--------:|---------|
| `epic` | No | Groups multiple stories. Never tracked directly on the board. |
| `story` | **Yes** | A feature, improvement, or technical task. |
| `bug` | **Yes** | Something isn't working as expected. |

Plus modifier labels: `priority-high`, `blocked`, `not-started`, `out-of-scope`, `feedback-required`, `waiting-for-details`.

See [`plan/LABEL_STRATEGY.md`](plan/LABEL_STRATEGY.md) for full definitions, colours, naming conventions, and the list of deprecated labels.

---

## Workflows

### `add-to-personal-project.yml`

Adds Issues and PRs to my [personal project board](https://github.com/users/markheydon/projects/6) when labelled `story` or `bug`. Dependabot PRs are added automatically as Story type with status "Up Next".

**Trigger:** `workflow_call` (reused from other repositories)

**Minimal usage — add this to your repo as `.github/workflows/add-to-personal-project.yml`:**

```yaml
on:
  issues:
    types: [labeled]
  pull_request_target:
    types: [labeled]

jobs:
  add-to-personal-project:
    uses: markheydon/github-workflows/.github/workflows/add-to-personal-project.yml@main
    secrets:
      PERSONAL_ACCESS_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
```

---

## Scripts

### `scripts/update_github_labels.bat`

Creates (or updates) the full set of development labels in a GitHub repository using the [GitHub CLI](https://cli.github.com/). Labels are defined by [`plan/LABEL_STRATEGY.md`](plan/LABEL_STRATEGY.md).

```sh
scripts/update_github_labels.bat <owner/repository>
```

### `scripts/Convert-IssueLabels.ps1`

Converts deprecated issue labels to their current replacements (e.g. `dependency` → `blocked`, `feature` → `story`). Does **not** delete old labels — that is a separate step. Supports `-WhatIf` for a dry run.

Note: `dependency` is only converted on _open_ issues. Closed issues with `dependency` are left as-is — `blocked` does not apply retroactively to completed work.

```powershell
# Preview changes first
scripts/Convert-IssueLabels.ps1 <owner/repository> -WhatIf

# Apply changes
scripts/Convert-IssueLabels.ps1 <owner/repository>
```

### `scripts/delete_old_labels.bat`

Deletes deprecated labels from a repository once issues have been converted. Safe to run multiple times. Run after `Convert-IssueLabels.ps1` when you are satisfied the conversion is clean.

```sh
scripts/delete_old_labels.bat <owner/repository>
```

> **Recommended order when migrating a repo to the current label strategy:**
> 1. `update_github_labels.bat` — create new labels
> 2. `Convert-IssueLabels.ps1 -WhatIf` — preview issue relabelling
> 3. `Convert-IssueLabels.ps1` — apply issue relabelling
> 4. Review, fix any errors
> 5. `delete_old_labels.bat` — delete old labels

---

## Copilot Skills, Prompts & Agents

This repo ships a set of AI tools for project management. They are designed for use in [VS Code with GitHub Copilot](https://code.visualstudio.com/docs/copilot/overview).

### 🎯 Getting Started — The PM Workflow

**Start here:** Type **`/pm-assistant`** in Copilot Chat, or select **"PM Assistant"** from the Agent mode picker.

The PM Assistant is a conversational guide that will:
1. Ask what you want to accomplish (daily work? review backlog? plan iteration?)
2. Route you through the right prompts in the right order
3. Explain what each prompt does and what comes next

This is your entry point to the entire workflow. No need to know which prompt to use — just tell the assistant your goal.

```
You: /pm-assistant
Assistant: I'll help you figure out what to work on today, or plan your next iteration, by guiding you through the right set of tools in order.

What would you like to do?
- 🔍 What should I work on today?
- 📋 Review my backlog and suggest priorities
- 📅 Plan my next iteration
- ✏️ Create a new story
- 🔍 Triage my recent unlabelled issues
- ⚙️ Something else
```

> **How it works in VS Code:**
> - **Prompts** (`/pm-daily`, `/pm-backlog-review`, etc.) are invoked as slash commands in Copilot Chat.
> - **Agents** (PM Assistant, Repo Label Strategy Keeper, Repo Docs Writer) are selected from the Agent mode picker in Copilot Chat.
> - `/pm-assistant` works because there is both a prompt file that kicks off the PM Assistant agent.

### Typical Weekly Workflow

If you prefer to run prompts directly, here's the recommended sequence:

1. **Monday morning:** `/pm-daily` — what's unblocked and ready to work on?
2. **Mid-week (if needed):** `/pm-backlog-review` — see your full prioritised backlog, flag unlabelled issues.
3. **Before starting an iteration:** `/pm-iteration-plan` — commit work to a milestone.
4. **Anytime:** `/pm-create-story` or `/pm-issue-triage` — add new items or label unlabelled ones.

Each prompt has a **"When to use"** and **"What comes next"** section built in. Check the prompt files for detailed guidance.

---

### Prompts (`.github/prompts/`)

Invoked as slash commands in Copilot Chat, e.g. `/pm-daily`.

| Prompt | How to invoke | Purpose |
|--------|:-------------:|---------|
| **`pm-assistant`** | `/pm-assistant` ⭐ | Conversational guide — asks your goal and routes you through the workflow |
| `pm-daily` | `/pm-daily` | What should I focus on today? |
| `pm-backlog-review` | `/pm-backlog-review` | Review and prioritise the open backlog |
| `pm-issue-triage` | `/pm-issue-triage` | Triage unlabelled issues |
| `pm-iteration-plan` | `/pm-iteration-plan` | Plan the next iteration |
| `pm-create-story` | `/pm-create-story` | Create a well-formed story issue |
| `repo-update-from-strategy` | `/repo-update-from-strategy` | Sync all files after a strategy change |

**Quick reference:** Each prompt has these sections:
- **"When to use this prompt"** — when and how often
- **"What you'll get"** — the output
- **"What comes next"** — suggested next step or how to use the output

---

### Agents (`.github/agents/`)

Selected from the **Agent mode picker** in Copilot Chat.

| Agent | How to use | Purpose |
|-------|:----------:|---------|
| **PM Assistant** | `/pm-assistant` or Agent picker ⭐ | Routes you through the PM workflow based on your goal |
| Backlog Manager | Via PM prompts | Powers daily focus, backlog review, triage, story creation, and iteration planning |
| Repo Label Strategy Keeper | Agent picker | Validates that all files are consistent with `plan/LABEL_STRATEGY.md` |
| Repo Docs Writer | Agent picker | Regenerates documentation (README, future docs/ site) |

---

### Agent Skill — `github-issue-management`

Location: [`.github/skills/github-issue-management/`](.github/skills/github-issue-management/)

A portable [Agent Skill](https://agentskills.io/specification) for triaging issues, applying labels, and maintaining project board consistency. Follows the label strategy in this repo by default.

**Using in another repo:**

- **Reference centrally** — point your agent at `markheydon/github-workflows/.github/skills/github-issue-management/`
- **Copy and customise** — copy the folder into your own `.github/skills/` and follow [`CUSTOMISATION_GUIDE.md`](.github/skills/github-issue-management/references/CUSTOMISATION_GUIDE.md)

---

## Keeping everything in sync

When you update [`plan/LABEL_STRATEGY.md`](plan/LABEL_STRATEGY.md), run `/repo-update-from-strategy` in Copilot Chat. It will scan all workflows, scripts, prompts, and agents for label references and apply any needed updates.

For a periodic consistency check, select the **Repo Label Strategy Keeper** agent from the Agent mode picker.

---

## Setup

- **Workflows:** Add a `PERSONAL_ACCESS_TOKEN` secret to your repo with permissions to update your GitHub Project.
- **Scripts:** Requires the [GitHub CLI](https://cli.github.com/) (`gh`) installed and authenticated.

## License

MIT License

---
_Last updated: 2026-03-04_
