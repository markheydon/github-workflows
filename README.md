# GitHub Workflows and Copilot PM Automation

This repository is a solo developer project management toolkit for working across multiple GitHub repositories. It centralises reusable automation patterns, Copilot prompts and agents, and label governance so issue and PR curation stays consistent with less manual admin.

## Purpose and Context

- Keep cross-repo work visible so older repositories do not quietly go stale.
- Keep the project board as the single pane of glass for committed work.
- Use `plan/LABEL_STRATEGY.md` as the single source of truth for label names, colours, and board rules.
- Use Copilot PM prompts and scripts to enforce consistency with minimal overhead.

For strategy and intent, start with `plan/GOALS.md` and `plan/OPERATING_MODEL.md`.

## GitHub Actions Workflows

Files in `.github/workflows/` (excluding `trigger-*` workflows):

| File | Purpose |
|---|---|
| `powershell-validate.yml` | Runs `PSScriptAnalyzer` against `scripts/` on pushes/PRs to `main`, plus manual dispatch support. |

### Reuse in other repositories

There are currently no `workflow_call` reusable workflows in this repository. Current reuse patterns are:

- Copy or adapt workflow YAML into target repositories.
- Use migration and audit scripts in `scripts/` for repo fleet rollout where relevant.

## Scripts

Files in `scripts/`:

| File | Purpose |
|---|---|
| `Convert-IssueLabels.ps1` | Converts deprecated labels on issues to the active label taxonomy from `plan/LABEL_STRATEGY.md` (`-WhatIf` supported). |
| `Export-OssSuitabilityAudit.ps1` | Audits OSS-readiness assets for one repo or across eligible repos, including repo-local `.github/FUNDING.yml` baseline matching; exports CSV and optional Markdown. |
| `Export-PatExists.ps1` | Audits repos for workflow references to `PERSONAL_ACCESS_TOKEN` and reports whether that secret exists. |
| `Export-WorkflowAudit.ps1` | Audits repositories for expected vs legacy project-workflow files and exports results to CSV. |
| `Import-Workflow.ps1` | Bulk-import helper that opens PRs to add the legacy project workflow trigger file where missing. |
| `Install-CopilotAssets.ps1` | Installs agents, prompts, skills, and instructions into a target repo from one or more configured source repos. |
| `Install-ProjectBootstrap.ps1` | Copies root project templates, then runs `Install-CopilotAssets.ps1` for `.github` asset bootstrap. |
| `Migrate-Workflows.ps1` | Batch migration helper driven by workflow audit CSV; can remove legacy files and open migration PRs. |
| `Remove-DeprecatedLabels.ps1` | Deletes deprecated labels after issue relabelling is complete. |
| `Remove-ProjectWorkflow.ps1` | Removes legacy `add-to-personal-project.yml` and deletes the `PERSONAL_ACCESS_TOKEN` Actions secret across repos. |
| `Update-GitHubLabels.ps1` | Upserts repository labels from `plan/LABEL_STRATEGY.md`. |
| `copilot-assets.example.json` | Example multi-source config for `Install-CopilotAssets.ps1`, including optional naming transforms. |

### Recommended label migration order

1. `./scripts/Update-GitHubLabels.ps1 <owner/repo>`
2. `./scripts/Convert-IssueLabels.ps1 <owner/repo> -WhatIf`
3. `./scripts/Convert-IssueLabels.ps1 <owner/repo>`
4. Review issue updates in GitHub
5. `./scripts/Remove-DeprecatedLabels.ps1 <owner/repo>`

## Copilot Tooling

Runtime Copilot assets live in `.github/`.

### Prompts

Files in `.github/prompts/`:

| File | Purpose |
|---|---|
| `pm-assistant.prompt.md` | Entry-point PM assistant that routes users to the right PM prompt path. |
| `pm-backlog-review.prompt.md` | Weekly cross-repo backlog review with board state checks and prioritised recommendations. |
| `pm-create-story.prompt.md` | Creates a well-formed `story` issue using the standard structure and labels. |
| `pm-daily.prompt.md` | Daily focus prompt showing board snapshot, stalled items, and top priorities. |
| `pm-issue-triage.prompt.md` | Triage flow for unlabelled issues and PRs in `full` participation repos. |
| `pm-iteration-plan.prompt.md` | Iteration planning flow that resolves stalled work and curates `Up Next`. |
| `pr-address-coding-review.prompt.md` | Process for addressing PR review threads, replying, and resolving each thread. |
| `repo-update-docs.prompt.md` | Regenerates README and supports Diataxis docs planning and updates. |
| `repo-update-from-strategy.prompt.md` | Propagates changes from `plan/LABEL_STRATEGY.md` across repo assets. |
| `repo-update-pinned-models.prompt.md` | Updates model pinning references and policy wording across repository files. |

### Agents

Files in `.github/agents/`:

| File | Purpose |
|---|---|
| `pm-assistant.agent.md` | Conversational PM router that interviews the user and recommends prompt sequences. |
| `pm-backlog-management.agent.md` | Execution agent for daily, triage, backlog review, and iteration planning workflows. |
| `repo-docs-writer.agent.md` | Documentation specialist for internal README work and public Diataxis docs. |
| `repo-label-strategy-keeper.agent.md` | Consistency validator for label references against `plan/LABEL_STRATEGY.md`. |

### Skills

Files in `.github/skills/`:

| File | Purpose |
|---|---|
| `.github/skills/documentation-writer/SKILL.md` | Diataxis documentation guidance and writing workflow. |
| `.github/skills/github-issue-management/SKILL.md` | Core issue/PR triage and label governance workflow. |
| `.github/skills/github-issue-management/assets/triage-workflow.md` | Visual triage flow reference. |
| `.github/skills/github-issue-management/references/CUSTOMISATION_GUIDE.md` | How to adapt the issue-management skill for other repositories. |
| `.github/skills/github-issue-management/references/github-labels.md` | Label taxonomy reference and decision guide. |
| `.github/skills/github-issue-management/references/project-setup.md` | Board setup, status model, and board behaviour rules. |
| `.github/skills/github-issue-management/scripts/Set-IssueLabelExample.ps1` | Example script for applying labels via `gh issue edit`. |

### Instructions

Files in `.github/instructions/`:

| File | Purpose |
|---|---|
| `label-script-update.instructions.md` | Rules for keeping `scripts/Update-GitHubLabels.ps1` in sync with `plan/LABEL_STRATEGY.md`. |

## Setup and Prerequisites

- GitHub CLI installed and authenticated (`gh auth status`).
- PowerShell (`pwsh`) available to run scripts.
- Permission to read/write issues, PRs, labels, and (where needed) project board items via GitHub APIs.
- Access to the project board: <https://github.com/users/markheydon/projects/6>.
- For legacy workflow migration scripts, permission to manage Actions secrets (`PERSONAL_ACCESS_TOKEN`) in target repos.

## Label Strategy

Label policy is defined in `plan/LABEL_STRATEGY.md`.

- Core labels: `epic`, `story`, `bug`
- Board inclusion: `story` and `bug` are board units of work; `epic` is excluded
- Common modifiers: `priority-high`, `blocked`, `not-started`, `out-of-scope`, `feedback-required`, `waiting-for-details`
- Dependabot PRs are treated as `story`-equivalent board work in PM Mode

If you change label strategy, run `/repo-update-from-strategy` to propagate updates.

## Public Docs

Public GitHub Pages documentation is in `docs/`, structured using Diataxis (tutorials, how-to guides, reference, explanation).

## License

MIT - see `LICENSE`.

Last updated: 2026-05-17
