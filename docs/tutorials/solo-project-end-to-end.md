---
title: Tutorial - End-to-End Solo Project Workflow
sidebar_position: 1
description: Step-by-step guide to bootstrapping and managing a solo developer project using Copilot PM automation.
---

# Tutorial: End-to-End Solo Project Workflow

This guide walks you through the complete workflow for bootstrapping and managing a solo developer project using the Copilot-powered project management system. It is adapted from the internal runbook for end users.

---

## Overview: The Three Phases

Every project follows three phases, each with its own tools:

```
Phase 1: Pre-repo planning    → templates/
Phase 2: Repo setup           → copilot-packs/ + .github/prompts/new-project-setup
Phase 3: Ongoing development  → skills (via Install-CopilotAssets) + templates/FEATURE-MINI-SPEC.md
```

---

## Phase 1: Pre-Repo Planning

1. **Capture the idea:**
   - Copy `IDEA-CAPTURE.md` (from [templates/](../../templates/IDEA-CAPTURE.md)) into your notes. Fill it in to clarify your pitch and gut check the idea.
2. **Decide to proceed:**
   - If the idea passes, copy `PROJECT-KICKOFF-SPEC.md` (from [templates/](../../templates/PROJECT-KICKOFF-SPEC.md)) into your notes and complete all sections. This becomes the input for setup.

> *Tip: These are pre-repo artefacts. You don't need to commit them, but you can for traceability.*

---

## Phase 2: New Repo Setup

1. **Install setup assets:**
   - Run the install script in your new repo:
     ```powershell
     ./scripts/Install-CopilotAssets.ps1 -TargetFolder <your-new-repo> -ConfigFile ./copilot-packs/solo-dev-project-setup.json
     ```
   - This installs planning/setup skills and the `new-project-setup` prompt into `.github/`.
   - (Optional) Layer on a language/platform pack, e.g. `csharp-dotnet-development.json` for .NET projects.
2. **Run the setup prompt:**
   - Open the repo in VS Code and run `/new-project-setup` in Copilot Chat.
   - Paste your completed kickoff spec when prompted.
   - The prompt generates all standing docs, ADRs, and initial issues for you.

---

## Phase 3: Ongoing Development

- **Spec out features:**
  - For each new feature or journey, copy `FEATURE-MINI-SPEC.md` (from [templates/](../../templates/FEATURE-MINI-SPEC.md)) into `plan/specs/` and fill it in.
- **Create issues from specs:**
  - Use the `create-github-issue-feature-from-specification` skill for simple features.
  - For complex features, use `create-implementation-plan` and then `create-github-issues-feature-from-implementation-plan`.
- **Record architectural decisions:**
  - Use the `create-architectural-decision-record` skill to document decisions and alternatives.
- **Address PR review comments:**
  - Use the `/pr-address-coding-review` prompt to process and resolve all open PR review threads.

---

## Quick Reference Table

| Task | Tool or File |
|---|---|
| Capture a new idea | `IDEA-CAPTURE.md` |
| Plan a new project | `PROJECT-KICKOFF-SPEC.md` |
| Bootstrap a new repo | `Install-CopilotAssets.ps1` + `solo-dev-project-setup.json` |
| Generate standing docs | `/new-project-setup` prompt |
| Spec out a feature | `FEATURE-MINI-SPEC.md` |
| Turn a spec into an Issue | `create-github-issue-feature-from-specification` skill |
| Plan a complex feature | `create-implementation-plan` skill |
| Turn a plan into Issues | `create-github-issues-feature-from-implementation-plan` skill |
| Record an architectural decision | `create-architectural-decision-record` skill |
| Address PR review comments | `/pr-address-coding-review` prompt |

---

## Available Copilot Packs

| Pack | Use for |
|---|---|
| `solo-dev-project-setup.json` | Language/platform-agnostic setup and planning |
| `csharp-dotnet-development.json` | C#/.NET development (layer on after setup) |
| `blazor-fluentui-development.json` | Blazor with Fluent UI |
| `blazor-mudblazor-development.json` | Blazor with MudBlazor |

---

For more details, see the [Reference](../reference/) and [How-to Guides](../how-to/).
