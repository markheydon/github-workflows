# GitHub Workflows & Copilot PM Automation

This repository provides a complete, reusable system for solo developers to automate project management across multiple GitHub repositories. It centralises label strategy, board automation, Copilot prompts, agents, skills, and setup scripts - making it easy to keep issues, PRs, and project board state in sync with minimal admin.

## Purpose & Context

- **Frictionless project management:** Automate triage, board updates, and label consistency across all your repos.
- **Single source of truth:** All labels, scripts, prompts, and agents are aligned with [plan/LABEL_STRATEGY.md](plan/LABEL_STRATEGY.md).
- **Easy reuse:** All patterns and assets are designed to be adapted for other repositories.

> **Asset layout:**
> - Active PM assets for this repo live under `.github/`.
> - Exportable templates for bootstrapping other repos live in root `skills/`, `instructions/`, `prompts/`, and `agents/` (see each folder's README).
> - Copilot asset packs (`copilot-packs/*.json`) define installable sets for new projects, consumed by `Install-CopilotAssets.ps1`.

## Reusable GitHub Actions Workflows

Workflows in `.github/workflows/`:

- `powershell-validate.yml`: Validates PowerShell scripts in the repo.

**Note:** No `trigger-*` workflow files are present. Board mutation is Copilot-driven (PM prompts + GitHub Projects v2 API via `gh`).

## Scripts

Scripts in `scripts/`:

- `Install-CopilotAssets.ps1`: Installs agents, skills, instructions, and prompts into a target repo from configured source repos (see `copilot-assets.example.json`).
- `Convert-IssueLabels.ps1`: Migrates deprecated labels on issues to the current strategy labels.
- `Export-PatExists.ps1`: Audits repos for `PERSONAL_ACCESS_TOKEN` usage.
- `Export-WorkflowAudit.ps1`: Audits workflow presence/content across repos.
- `Import-Workflow.ps1`: Imports workflow files into repos.
- `Migrate-Workflows.ps1`: Migrates legacy workflow usage across repos.
- `delete_old_labels.bat`: Removes deprecated labels after migration.
- `remove-project-workflow.sh`: Removes legacy project workflow and token secret from repos.
- `update_github_labels.bat`: Upserts labels from strategy definitions.
- `copilot-assets.example.json`: Sample configuration for `Install-CopilotAssets.ps1`.

**Recommended label migration order:**
1. `scripts/update_github_labels.bat <owner/repo>`
2. `scripts/Convert-IssueLabels.ps1 <owner/repo> -WhatIf`
3. `scripts/Convert-IssueLabels.ps1 <owner/repo>`
4. Review results
5. `scripts/delete_old_labels.bat <owner/repo>`

## Copilot Tooling Overview

**Prompts in `.github/prompts/`:**
- `pm-assistant.prompt.md`
- `pm-backlog-review.prompt.md`
- `pm-create-story.prompt.md`
- `pm-daily.prompt.md`
- `pm-issue-triage.prompt.md`
- `pm-iteration-plan.prompt.md`
- `repo-update-docs.prompt.md`
- `repo-update-from-strategy.prompt.md`

**Agents in `.github/agents/`:**
- `pm-assistant.agent.md`
- `pm-backlog-management.agent.md`
- `repo-docs-writer.agent.md`
- `repo-label-strategy-keeper.agent.md`

**Skills in `.github/skills/`:**
- `documentation-writer/SKILL.md`
- `github-issue-management/SKILL.md`
- `github-issue-management/references/github-labels.md`
- `github-issue-management/references/project-setup.md`
- `github-issue-management/references/CUSTOMISATION_GUIDE.md`
- `github-issue-management/assets/triage-workflow.md`
- `github-issue-management/scripts/triage-example.sh`

**Instructions in `.github/instructions/`:**
- `label-script-update.instructions.md`

**Exportable root assets:**
- `skills/repo-dotnet-best-practices/SKILL.md`
- `skills/repo-mudblazor/SKILL.md` (plus references)
- `instructions/repo-blazor-csharp.instructions.md`

**Template asset folders:**
Each of `skills/`, `instructions/`, `prompts/`, and `agents/` contains a README clarifying that these are templates only - active runtime assets are always under `.github/`.

## Copilot Asset Packs

**Pack examples in `copilot-packs/`:**
- `solo-dev-project-setup.json`: Technology-agnostic setup pack (installs planning/setup skills and prompts).
- `csharp-dotnet-development.json`: C#/.NET pack (installs C# skills, best practices, and ADR support).

## Setup & Prerequisites

- GitHub CLI (`gh`) authenticated for repository and project operations.
- Access to the [GitHub Projects v2 board](https://github.com/users/markheydon/projects/6).
- Repo access for cross-repo issue/PR scanning when using PM prompts.

## Label Strategy

- **Core labels:** `epic`, `story`, `bug` (every issue/PR gets one)
- **Modifier labels:** `priority-high`, `blocked`, `not-started`, `out-of-scope`, `feedback-required`, `waiting-for-details`
- **Board inclusion:** Only `story` and `bug` go on the board; `epic` is never added

See the full strategy in [plan/LABEL_STRATEGY.md](plan/LABEL_STRATEGY.md).

## Public Documentation

End-user documentation lives in `docs/` (GitHub Pages scaffold). Start at [docs/README.md](docs/README.md).

## License

MIT License. See [LICENSE](LICENSE).

Last updated: 2026-04-16
