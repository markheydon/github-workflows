# GitHub Workflows, Scripts & Copilot PM Tooling

This repository centralises project management automation for solo developers managing multiple GitHub repos. It provides reusable workflows, label scripts, Copilot prompts, agents, skills, and **Copilot asset packs**—all designed to keep your issues, labels, and project board in sync with minimal manual admin.

## Purpose & Context

- **Frictionless project management:** Automate triage, board updates, and label consistency so you can focus on building.
- **Single source of truth:** All labels, workflows, and scripts derive from [plan/LABEL_STRATEGY.md](plan/LABEL_STRATEGY.md).
- **Easy reuse:** Designed for adaptation in other repos—just follow the documented patterns.

> **Copilot asset layout:**
> - Active PM workflow assets (agents, skills, prompts, and instructions used by Copilot on this repo) live under `.github/`.
> - Exportable assets intended for bootstrapping other repos via `Install-CopilotAssets.ps1` live in the root-level `skills/` and `instructions/` folders.
> - **Copilot asset packs** in the `copilot-packs/` folder are JSON configuration files for different project types. These are used as input to `Install-CopilotAssets.ps1` to automate setup of Copilot agents, skills, and instructions in new projects. Each pack specifies which assets to copy from which source repos.

## Reusable GitHub Actions Workflows

Workflows are in `.github/workflows/` and can be called from other repos via `workflow_call`.
**Ignore any file starting with `trigger-`—these are internal thin callers.**

**Workflow files:**
- add-to-personal-project.yml — Adds issues and PRs to your project board when labelled `story` or `bug`. Dependabot PRs are auto-added as `story` type.
- powershell-validate.yml — Validates PowerShell scripts for syntax and style.

## Scripts

Scripts automate label management, issue migration, and Copilot asset setup. Located in `scripts/`:

**Script files:**
- Install-CopilotAssets.ps1 — Bootstraps a project with Copilot agents, skills, and instructions from one or more source repositories. Uses a JSON config file (see copilot-assets.example.json) to specify asset sources and types. Assets are copied into the target repo's `.github` folder, preserving structure. Requires GitHub CLI (`gh`).
  - Usage: `./Install-CopilotAssets.ps1 -TargetFolder <path> -ConfigFile <json-file> [-CloneRoot <path>] [-Force]`
  - Config format: see `scripts/copilot-assets.example.json` or any file in `copilot-packs/`.
  - **Copilot asset packs:** See the `copilot-packs/` folder for ready-made JSON configs for Blazor (Fluent UI, MudBlazor) and C#/.NET development. These packs specify which agents, skills, and instructions to install for each project type.
  - Source repo asset folders: `agents/`, `skills/`, `instructions/` (root-level, as used by Awesome Copilot and the exportable assets in this repo — not the active `.github/` assets)
- Convert-IssueLabels.ps1 — Migrate issue labels between repos.
- Export-PatExists.ps1 — Export PAT existence for audit.
- Export-WorkflowAudit.ps1 — Export workflow audit data.
- Import-Workflow.ps1 — Import workflow files.
- Migrate-Workflows.ps1 — Migrate workflow files between repos.
- delete_old_labels.bat — Remove deprecated labels.
- update_github_labels.bat — Upsert all labels in a repo, grouped by type. Usage: `update_github_labels.bat <owner/repo>` (requires GitHub CLI)

**Config files:**
- copilot-assets.example.json — Example config for Install-CopilotAssets.ps1

## Copilot Tooling Overview

### Prompts (`.github/prompts/`)
- pm-assistant.prompt.md — Entry point for PM workflow
- pm-backlog-review.prompt.md — Review and prioritise backlog
- pm-create-story.prompt.md — Create a well-formed story issue
- pm-daily.prompt.md — Summarise unblocked work
- pm-issue-triage.prompt.md — Triage and label unlabelled issues
- pm-iteration-plan.prompt.md — Plan and group work for milestones
- repo-update-docs.prompt.md — Regenerate this README and plan future docs
- repo-update-from-strategy.prompt.md — Propagate label strategy changes

### Agents (`.github/agents/`)
- pm-assistant.agent.md
- pm-backlog-management.agent.md
- repo-docs-writer.agent.md
- repo-label-strategy-keeper.agent.md

### Skills (`.github/skills/`)
- documentation-writer/SKILL.md
- github-issue-management/SKILL.md
  - references/github-labels.md
  - references/project-setup.md
  - references/CUSTOMISATION_GUIDE.md
  - references/assets/
  - references/scripts/triage-example.sh
  - references/assets/triage-workflow.md

### Instructions (`.github/instructions/`)
- label-script-update.instructions.md

### Exportable Assets (root-level)

These assets are consumed by `Install-CopilotAssets.ps1` when bootstrapping other repos:

**`skills/`**
- dotnet-best-practices/SKILL.md
- mudblazor/SKILL.md (and references/)

**`instructions/`**
- blazor-csharp.instructions.md

## Setup & Prerequisites

- **GitHub CLI (`gh`)** — Required for label scripts and Copilot asset install.
- **Secrets:** Set a `PERSONAL_ACCESS_TOKEN` with repo and project access for workflows.
- **Project board:** Uses [GitHub Projects v2](https://github.com/users/markheydon/projects/6).

## Label Strategy (Summary)

- **Core labels:** `epic` (never on board), `story` (on board), `bug` (on board)
- **Modifier labels:** `priority-high`, `blocked`, `not-started`, `out-of-scope`, `feedback-required`, `waiting-for-details`
- **Board inclusion:** Only `story` and `bug` are tracked; `epic` is for grouping only.
- See [plan/LABEL_STRATEGY.md](plan/LABEL_STRATEGY.md) for full details, colours, and deprecated labels.

## License

MIT License — see [LICENSE](LICENSE).

Last updated: 2026-03-16
