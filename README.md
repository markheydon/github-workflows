
# GitHub Workflows & Copilot PM Automation

This repository provides a complete, reusable system for solo developers to automate project management across multiple GitHub repositories. It centralises label strategy, board automation, Copilot prompts, agents, skills, and setup scripts—making it easy to keep issues, PRs, and project board state in sync with minimal admin.

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
	- **Install-time asset name transforms:** Supports optional `nameTransform` (prefix/suffix/frontmatter update) per source entry, so installed assets can be safely namespaced without renaming the canonical source files. See the script and example config for details.
- `Convert-IssueLabels.ps1`: Migrates deprecated labels on issues to the current strategy labels.
- `Export-PatExists.ps1`: Audits repos for `PERSONAL_ACCESS_TOKEN` usage.
- `Export-WorkflowAudit.ps1`: Audits workflow presence/content across repos.
- `Export-OssSuitabilityAudit.ps1`: Audits OSS suitability assets for public OSS repos, including `FUNDING.yml`, using repo-local checks. Supports markdown reporting via `-OutputFormat Markdown -MarkdownPath ./oss-suitability-audit.md`.
- `Import-Workflow.ps1`: Imports workflow files into repos.
- `Migrate-Workflows.ps1`: Migrates legacy workflow usage across repos.
- `Remove-DeprecatedLabels.ps1`: Removes deprecated labels after migration.
- `Remove-ProjectWorkflow.ps1`: Removes legacy project workflow and token secret from repos.
- `Update-GitHubLabels.ps1`: Upserts labels from strategy definitions.
- `copilot-assets.example.json`: Sample configuration for `Install-CopilotAssets.ps1`.

**Recommended label migration order:**
1. `scripts/Update-GitHubLabels.ps1 <owner/repo>`
2. `scripts/Convert-IssueLabels.ps1 <owner/repo> -WhatIf`
3. `scripts/Convert-IssueLabels.ps1 <owner/repo>`
4. Review results
5. `scripts/Remove-DeprecatedLabels.ps1 <owner/repo>`

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
	- `repo-update-github-assets.prompt.md`
	- `new-project-setup.prompt.md`
	- `pr-address-coding-review.prompt.md`

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
	- `github-issue-management/scripts/Set-IssueLabelExample.ps1`

**Instructions in `.github/instructions/`:**
	- `label-script-update.instructions.md`

**Exportable root assets:**
	- `skills/dotnet-best-practices/SKILL.md`
	- `skills/mudblazor/SKILL.md` (plus references)
	- `instructions/blazor-csharp.instructions.md`
	- `prompts/new-project-setup.prompt.md`
	- `prompts/pr-address-coding-review.prompt.md`

**Template asset folders:**
Each of `skills/`, `instructions/`, `prompts/`, and `agents/` contains a README clarifying that these are templates only—active runtime assets are always under `.github/`.

Install-time naming transforms are configured in `copilot-packs/*.json` via an optional `nameTransform` object on each source entry. This keeps canonical source asset names clean while allowing installed assets to be suffixed or prefixed to avoid collisions with library assets.

## Copilot Asset Packs

**Pack examples in `copilot-packs/`:**
	- `solo-dev-project-setup.json`: Technology-agnostic setup pack (installs planning/setup skills and prompts).
	- `csharp-dotnet-development.json`: C#/.NET pack (installs C# skills, best practices, and ADR support).
	- `blazor-fluentui-development.json`, `blazor-mudblazor-development.json`: Blazor-specific packs.

## Setup & Prerequisites

- GitHub CLI (`gh`) authenticated for repository and project operations.
- Access to the [GitHub Projects v2 board](https://github.com/users/markheydon/projects/6).
- Repo access for cross-repo issue/PR scanning when using PM prompts.

### Codespaces / Dev Container

This repo now includes a dev container config at `.devcontainer/devcontainer.json` to support low-spec devices and browser-based development.

Included tools/features:
- GitHub CLI feature (`ghcr.io/devcontainers/features/github-cli:1`, version `2`)
- PowerShell feature (`ghcr.io/devcontainers/features/powershell:1`)
- Copilot Likes feature (`ghcr.io/markheydon/devcontainer-features/copilot-likes:1`)

## Label Strategy

- **Core labels:** `epic`, `story`, `bug` (every issue/PR gets one)
- **Modifier labels:** `priority-high`, `blocked`, `not-started`, `out-of-scope`, `feedback-required`, `waiting-for-details`
- **Board inclusion:** Only `story` and `bug` go on the board; `epic` is never added

See the full strategy in [plan/LABEL_STRATEGY.md](plan/LABEL_STRATEGY.md).

## Public Documentation

End-user documentation lives in `docs/` (GitHub Pages scaffold). Start at [docs/README.md](docs/README.md).

## License

MIT License. See [LICENSE](LICENSE).

Last updated: 2026-04-17
