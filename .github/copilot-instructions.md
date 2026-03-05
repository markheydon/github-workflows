# Copilot Instructions for markheydon/github-workflows

This repository centralises reusable GitHub Actions workflows, label scripts, Copilot prompt files, and agent definitions for Mark Heydon's personal GitHub project management.

All and any documentation, instructions, and code in this repo must be consistent with the label strategy defined in `plan/LABEL_STRATEGY.md`. This is the single source of truth for all label names, colours, board inclusion rules, and deprecated labels.

When working with issue management in any repository, always refer to the `github-issue-management` skill at `.github/skills/github-issue-management/` for guidance on label usage and project board automation. The `SKILL.md` file defines the triage workflow, while `references/github-labels.md` provides detailed label definitions. If a target repository has its own `.github/copilot-instructions.md`, check it for any overrides or specific instructions related to that repository's setup. However, note that not all repositories may have this file.

When writing or updating documentation, refer to the `documentation-writer` skill at `.github/skills/documentation-writer/SKILL.md` for Diátaxis framework guidance. Use the `repo-docs-writer` agent (`.github/agents/repo-docs-writer.agent.md`) and invoke it via the `repo-update-docs` prompt (`.github/prompts/repo-update-docs.prompt.md`). Documentation covers two contexts: `README.md` (internal/contributor-facing) and the future `docs/` folder (end-user GitHub Pages site).

Any internal or end-user facing documention including code comments must be in UK English.

## Context

The strategy and tooling in this repo were specifically designed for my own personal workflow, which may (or may not) be suitable for others. It includes:

- Solo developer managing multiple personal repos.
- Project board: https://github.com/users/markheydon/projects/6.
- Label strategy: `epic` (never on board), `story` (on board), `bug` (on board). Epics group stories; stories and bugs are the unit of work.
- Both issues **and PRs** use the same label taxonomy. PRs labelled `story` or `bug` appear on the board identically to issues. All PM prompts scan for both.
- Dependabot PRs are automatically treated as `story` type on the board.

## Label strategy — single source of truth

**Before suggesting any label change, always read `plan/LABEL_STRATEGY.md` first.** That file defines all label names, colours, board inclusion rules, and deprecated labels. Do not reference labels not listed there.

The centralised label skill is at `.github/skills/github-issue-management/`. When working with issue management in any repo:
- Read `SKILL.md` for the triage workflow.
- Read `references/github-labels.md` for label definitions.
- If a `.github/copilot-instructions.md` exists in the target repo, read it for overrides — but note it **may not exist**.

To validate consistency across this repo, use the `repo-label-strategy-keeper` agent (`.github/agents/repo-label-strategy-keeper.agent.md`).

## Using the PM Workflow

This repo provides a complete set of AI tools for project management. The **entry point is the PM Assistant**, which acts as a conversational guide.

**Repository exclusions:** Some repos may be excluded from PM operations (listed in `plan/EXCLUDED_REPOS.md`). These repos are skipped when scanning for issues, PRs, and board state calculations.

### Quick Start

1. **Type `/pm-assistant`** in Copilot Chat (or select "PM Assistant" from the Agent mode picker).
2. **Tell it your goal:** "What should I work on today?" or "Plan my next iteration?"
3. **Follow the guidance:** The assistant will route you through the right prompts in the right order.

> **How invocation works:**
> - **Prompts** are slash commands: `/pm-daily`, `/pm-backlog-review`, `/pm-iteration-plan`, etc.
> - **Agents** are selected from the Agent mode picker in Copilot Chat (PM Assistant, Backlog Manager, Repo Label Strategy Keeper, Repo Docs Writer). The **Backlog Manager** agent is invoked automatically via the PM prompts (`/pm-daily`, `/pm-backlog-review`, `/pm-issue-triage`, `/pm-create-story`, `/pm-iteration-plan`).
> - `/pm-assistant` works as a slash command because there is a matching prompt file that kicks off the PM Assistant agent.

### Available Prompts

| When | Prompt | Purpose |
|------|--------|---------|
| **Optional daily** | `/pm-daily` | Board state snapshot: stalled items, stalled PR reviews, top 3 to focus on today |
| **Weekly (PM Mode)** | `/pm-backlog-review` | Scan all repos for issues and PRs, flag stale ones, surface ready work across the ecosystem |
| **Weekly (PM Mode)** | `/pm-iteration-plan` | Read board state, resolve stalled items, curate Up Next (issues and PRs), mutate board |
| **Anytime** | `/pm-create-story` | Create a well-formed story issue |
| **As needed** | `/pm-issue-triage` | Classify and label unlabelled issues and PRs |
| **After strategy change** | `/repo-update-from-strategy` | Sync all files with updated label strategy |

Each prompt has:
- **"When to use this prompt"** — timing and frequency
- **"What you'll get"** — the output
- **"What comes next"** — suggested next steps

### Operating Model: PM Mode vs Work Mode

**PM Mode (weekly/fortnightly):**
1. `/pm-backlog-review` → Scan all repos for issues and PRs, surface neglected work, flag stale repos, flag unlabelled PRs
2. `/pm-iteration-plan` → Check board state, resolve stalled items, curate this week's load (issues and PRs), update board

**Work Mode (daily):**
1. Open your project board at https://github.com/users/markheydon/projects/6 — the board has been curated in PM Mode
2. Optionally run `/pm-daily` for a nudge on what's most urgent today

**Don't know the exact sequence?** Type `/pm-assistant` — it will guide you.

---
- Maintain consistent label names: `epic`, `story`, `bug` (lowercase).
- The reusable workflow `add-to-personal-project.yml` is called from other repos via `workflow_call`. It handles both `labeled` and `unlabeled` events — calling repo trigger files must include both.
- Trigger files (prefixed `trigger-`) are thin callers — document or suggest changes to the reusable workflow, not the trigger files.
- When suggesting new workflows or scripts, follow the existing pattern (reusable workflow + thin trigger).
- Use `actions/github-script@v8`, `actions/add-to-project@v1.0.2`, and `titoportas/update-project-fields@v0.1.0` for project automation.

## Tone & style
- Documentation should be concise, friendly, and welcoming to others who may want to adapt things.
- YAML examples must use spaces (never tabs).
