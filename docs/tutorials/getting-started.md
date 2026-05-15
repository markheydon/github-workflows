---
title: Tutorial - Getting Started with Copilot PM Workflow
description: Step-by-step onboarding guide for adopting the workflow in your own repositories.
---

# Tutorial: Getting Started with Copilot PM Workflow

This tutorial will guide you through setting up and running the Copilot-powered project management workflow for your own repositories.

## Prerequisites

- A GitHub account with multiple repositories.
- Access to GitHub Projects (beta or later).
- GitHub Copilot enabled in VS Code.
- (Optional) PowerShell for running setup scripts.

## Steps

1. **Clone this repository** or copy the relevant assets (see [How-to: Install Copilot Assets](../how-to/install-copilot-assets.md)).
2. **Review the label strategy** in [plan/LABEL_STRATEGY.md](https://github.com/markheydon/github-workflows/blob/main/plan/LABEL_STRATEGY.md) and adapt as needed.
3. **Copy or create your repository priorities file** at `plan/REPO_PRIORITIES.md` in the target repo, using [plan/REPO_PRIORITIES.md](https://github.com/markheydon/github-workflows/blob/main/plan/REPO_PRIORITIES.md) from this repository as a starting point. Then assign each repo to a tier (Active Focus, Medium, Low, Paused, or Not PM Tracked) to control which ones are surfaced by the PM workflow prompts.
4. **Copy or create your participation file** at `plan/REPO_PM_PARTICIPATION.md`, using this repo's file as a starting point. Use it to decide whether each repo is fully managed (`full`), planning-visible only (`observe`), or fully out of scope (`exclude`).
5. **Install Copilot assets** using `Install-CopilotAssets.ps1` or manually copy `.github/agents/`, `.github/skills/`, `.github/prompts/`, and `.github/instructions/` into your repo. This step covers `.github/` Copilot assets only, so ensure `plan/REPO_PRIORITIES.md` and `plan/REPO_PM_PARTICIPATION.md` are added separately.
6. **Configure your project board** as described in [How-to: Set Up the Project Board](../how-to/setup-project-board.md).
7. **Run the PM workflow prompts**:
   - `/pm-backlog-review` - Review all issues and PRs across your repos (uses your repo priorities)
   - `/pm-iteration-plan` - Curate your board for the next few days (uses your repo priorities)
   - `/pm-daily` - Get a daily nudge on what to focus on
8. **Customise as needed** - Update prompts, agents, or skills to fit your workflow.

## Next Steps

- Explore the [How-to Guides](../how-to/) for specific tasks
- Read the [Reference](../reference/) for label and script details
- Understand the [Explanation](../explanation/) for design rationale
