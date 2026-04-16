# GitHub Workflows, Scripts & Copilot PM Tooling

This repository centralises project management automation for a solo developer managing multiple GitHub repos. It provides reusable workflows, label scripts, Copilot prompts, agents, skills, and Copilot asset packs to keep issues, labels, and project board state in sync with minimal admin.

## Purpose & Context

- Frictionless project management: automate triage, board updates, and label consistency.
- Single source of truth: labels, scripts, prompts, and agents align with [plan/LABEL_STRATEGY.md](plan/LABEL_STRATEGY.md).
- Easy reuse: patterns are designed to be adapted for other repos.

> Copilot asset layout:
> - Active PM assets used by this repo live under `.github/`.
> - Exportable assets for bootstrapping other repos live in root `skills/`, `instructions/`, `prompts/`, and `agents/`.
> - JSON asset packs live in `copilot-packs/` and are consumed by `scripts/Install-CopilotAssets.ps1`.

## Reusable GitHub Actions Workflows

Workflows in `.github/workflows/`:

- `powershell-validate.yml`: validates PowerShell scripts in the repo.

Notes:
- There are currently no `trigger-*` workflow files in this repo.
- Board mutation is now Copilot-driven (PM prompts + GitHub Projects v2 API via `gh`), not workflow-driven.

## Scripts

Scripts in `scripts/`:

- `Install-CopilotAssets.ps1`: installs agents/skills/instructions/prompts into a target repo from configured source repos.
- `Convert-IssueLabels.ps1`: migrates deprecated labels on issues to the current strategy labels.
- `Export-PatExists.ps1`: audits repos for `PERSONAL_ACCESS_TOKEN` usage.
- `Export-WorkflowAudit.ps1`: audits workflow presence/content across repos.
- `Import-Workflow.ps1`: imports workflow files into repos.
- `Migrate-Workflows.ps1`: migrates legacy workflow usage across repos.
- `delete_old_labels.bat`: removes deprecated labels after migration.
- `remove-project-workflow.sh`: removes legacy project workflow and token secret from repos.
- `update_github_labels.bat`: upserts labels from strategy definitions.
- `copilot-assets.example.json`: sample configuration for `Install-CopilotAssets.ps1`.

Recommended label migration order:

1. `scripts/update_github_labels.bat <owner/repo>`
2. `scripts/Convert-IssueLabels.ps1 <owner/repo> -WhatIf`
3. `scripts/Convert-IssueLabels.ps1 <owner/repo>`
4. Review results
5. `scripts/delete_old_labels.bat <owner/repo>`

## Copilot Tooling Overview

Prompts in `.github/prompts/`:

- `pm-assistant.prompt.md`
- `pm-backlog-review.prompt.md`
- `pm-create-story.prompt.md`
- `pm-daily.prompt.md`
- `pm-issue-triage.prompt.md`
- `pm-iteration-plan.prompt.md`
- `repo-update-docs.prompt.md`
- `repo-update-from-strategy.prompt.md`

Agents in `.github/agents/`:

- `pm-assistant.agent.md`
- `pm-backlog-management.agent.md`
- `repo-docs-writer.agent.md`
- `repo-label-strategy-keeper.agent.md`

Skills in `.github/skills/`:

- `documentation-writer/SKILL.md`
- `github-issue-management/SKILL.md`
- `github-issue-management/references/github-labels.md`
- `github-issue-management/references/project-setup.md`
- `github-issue-management/references/CUSTOMISATION_GUIDE.md`
- `github-issue-management/assets/triage-workflow.md`
- `github-issue-management/scripts/triage-example.sh`

Instructions in `.github/instructions/`:

- `label-script-update.instructions.md`

Exportable root assets:

- `skills/dotnet-best-practices/SKILL.md`
- `skills/mudblazor/SKILL.md` (plus references)
- `instructions/blazor-csharp.instructions.md`

## Setup & Prerequisites

- GitHub CLI (`gh`) authenticated for repository and project operations.
- Access to GitHub Projects v2 board: <https://github.com/users/markheydon/projects/6>.
- Repo access for cross-repo issue/PR scanning where PM prompts are used.

## Label Strategy

Summary:
- Core labels: `epic`, `story`, `bug`
- Modifier labels include: `priority-high`, `blocked`, `not-started`, `out-of-scope`, `feedback-required`, `waiting-for-details`
- Board inclusion: only `story` and `bug`; `epic` is never added

See full strategy in [plan/LABEL_STRATEGY.md](plan/LABEL_STRATEGY.md).

## Public Documentation

Public docs live in `docs/` (GitHub Pages scaffold). Start at [docs/README.md](docs/README.md).

## License

MIT License. See [LICENSE](LICENSE).

Last updated: 2026-04-14
