# GitHub Workflows, Scripts & Copilot PM Tooling

This repository centralises project management automation for solo developers managing multiple GitHub repos. It provides reusable workflows, label scripts, Copilot prompts, agents, and skills—all designed to keep your issues, labels, and project board in sync with minimal manual admin.

## Purpose & Context

- **Frictionless project management:** Automate triage, board updates, and label consistency so you can focus on building.
- **Single source of truth:** All labels, workflows, and scripts derive from [plan/LABEL_STRATEGY.md](plan/LABEL_STRATEGY.md).
- **Easy reuse:** Designed for adaptation in other repos—just follow the documented patterns.

## Reusable GitHub Actions Workflows

Workflows are in `.github/workflows/` and can be called from other repos via `workflow_call`.  
**Ignore any file starting with `trigger-`—these are internal thin callers.**

- **add-to-personal-project.yml**  
  Adds issues and PRs to your project board when labelled `story` or `bug`. Dependabot PRs are auto-added as `story` type.

## Scripts

Scripts automate label management, issue migration, and Copilot tooling setup.  
Located in `scripts/`:

- **Install-CopilotAssets.ps1** — Platform-agnostic PowerShell script that bootstraps a project with Copilot agents, skills, and instructions from the [Awesome Copilot](https://github.com/github/awesome-copilot) repository.  
  _Usage:_ `.\Install-CopilotAssets.ps1 -TargetFolder <path> -ConfigFile <json-file> [-CloneRoot <path>]` (requires GitHub CLI)  
  See `copilot-assets.example.json` for the config file format.
- **Convert-IssueLabels.ps1** — PowerShell script for migrating issue labels between repos.
- **delete_old_labels.bat** — Batch script to remove deprecated labels.
- **update_github_labels.bat** — Batch script to upsert all labels in a repo, grouped by type.  
  _Usage:_ `update_github_labels.bat <owner/repo>` (requires GitHub CLI)

## Copilot Tooling Overview

### Prompts (`.github/prompts/`)
- **pm-assistant.prompt.md** — Entry point for PM workflow.
- **pm-backlog-review.prompt.md** — Review and prioritise backlog.
- **pm-create-story.prompt.md** — Create a well-formed story issue.
- **pm-daily.prompt.md** — Summarise unblocked work.
- **pm-issue-triage.prompt.md** — Triage and label unlabelled issues.
- **pm-iteration-plan.prompt.md** — Plan and group work for milestones.
- **repo-update-docs.prompt.md** — Regenerate this README and plan future docs.
- **repo-update-from-strategy.prompt.md** — Propagate label strategy changes.

### Agents (`.github/agents/`)
- **pm-assistant.agent.md** — Conversational PM guide.
- **pm-backlog-management.agent.md** — Backlog management logic.
- **repo-docs-writer.agent.md** — Documentation generator (Diátaxis).
- **repo-label-strategy-keeper.agent.md** — Validates label consistency.

### Skills (`.github/skills/`)
- **documentation-writer/SKILL.md** — Diátaxis documentation guidance.
- **github-issue-management/SKILL.md** — Label taxonomy, triage workflow, and automation.
  - **references/github-labels.md** — Label definitions (mirrors strategy).
  - **references/project-setup.md** — Board rules and field mapping.
  - **CUSTOMISATION_GUIDE.md** — Adapting the skill for other repos.
  - **assets/** — Example assets.
  - **scripts/triage-example.sh** — Example triage script.
  - **assets/triage-workflow.md** — Example workflow.

### Instructions (`.github/instructions/`)
- **label-script-update.instructions.md** — How to keep the label script in sync with the strategy.

## Setup & Prerequisites

- **GitHub CLI (`gh`)** — Required for label scripts.
- **Secrets:** Set a `PERSONAL_ACCESS_TOKEN` with repo and project access for workflows.
- **Project board:** Uses [GitHub Projects v2](https://github.com/users/markheydon/projects/6).

## Label Strategy (Summary)

- **Core labels:** `epic` (never on board), `story` (on board), `bug` (on board)
- **Modifier labels:** `priority-high`, `blocked`, `not-started`, `out-of-scope`, `feedback-required`, `waiting-for-details`
- **GitHub default labels:** `documentation`, `duplicate`, `enhancement`, `good first issue`, `help wanted`, `invalid`, `question`, `wontfix` (optional modifiers)
- **Board inclusion:** Only `story` and `bug` are tracked; `epic` is for grouping only.
- See [plan/LABEL_STRATEGY.md](plan/LABEL_STRATEGY.md) for full details, colours, and deprecated labels.

## License

MIT License — see [LICENSE](LICENSE).

_Last updated: 2026-03-04_
