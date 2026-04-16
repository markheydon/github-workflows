# Runbook - Solo Dev Project System

This repository is a toolkit for bootstrapping and managing AI-assisted solo .NET/C# projects.
This runbook explains what everything is for and when to use it.

---

## The Mental Model

There are three phases to every project. Different tools apply at each phase.

```
Phase 1: Pre-repo planning    → templates/
Phase 2: Repo setup           → copilot-packs/ + .github/prompts/repo-new-project-setup
Phase 3: Ongoing development  → skills (via Install-CopilotAssets) + templates/FEATURE-MINI-SPEC.md
```

---

## Phase 1: Pre-repo Planning

These templates live **outside any repo** - in your notes app, OneDrive, Obsidian, local folder,
wherever you capture ideas. They exist before you decide whether to create a repo at all.

### Step 1 - Capture the idea
Copy `templates/IDEA-CAPTURE.md` into your notes. Fill it in. It forces the 30-second pitch
and a basic gut check. If it doesn't pass, drop it or park it. Takes 5 minutes.

### Step 2 - Decide to proceed
If the idea passes the gut check, copy `templates/PROJECT-KICKOFF-SPEC.md` into your notes
and fill in all 13 sections. This is the primary planning document. It takes 30–60 minutes
to do properly and is worth every minute - it becomes the direct input to Phase 2.

> **You do not need to commit these files to a repo.** They are pre-repo planning artefacts.
> If you want traceability, you can commit the completed kickoff spec to `plan/` once the repo exists.

---

## Phase 2: New Repo Setup (two commands)

Once you have a completed `PROJECT-KICKOFF-SPEC.md` and have created a new (empty) GitHub repo:

### Command 1 - Install setup assets

```powershell
.\scripts\Install-CopilotAssets.ps1 `
  -TargetFolder C:\path\to\your-new-repo `
  -ConfigFile .\copilot-packs\solo-dev-project-setup.json
```

This installs into your new repo's `.github/` folder:
- `create-architectural-decision-record` skill
- `create-implementation-plan` skill
- `create-github-issue-feature-from-specification` skill
- `create-github-issues-feature-from-implementation-plan` skill
- `repo-new-project-setup` prompt (from this repo)

This pack is intentionally technology-agnostic. After setup, install any language or platform pack you need.

By default, `Install-CopilotAssets.ps1` clones source repositories into a per-user cache at `~/.copilot-assets-cache` so repeated runs reuse the same local clones. Use `-CloneRoot` to override this location when needed.

Optional example for C#/.NET:

```powershell
.\scripts\Install-CopilotAssets.ps1 `
  -TargetFolder C:\path\to\your-new-repo `
  -ConfigFile .\copilot-packs\csharp-dotnet-development.json
```

### Command 2 - Run the setup prompt

Open the new repo in VS Code. In Copilot Chat, run:

```
/repo-new-project-setup
```

When prompted, paste in your completed `PROJECT-KICKOFF-SPEC.md`. The prompt will generate:

| File | Source section |
|---|---|
| `GOALS.md` | Sections 4, 11, 12 |
| `SCOPE.md` | Sections 5, 6 |
| `AGENTS.md` | Standard template |
| `CONVENTIONS.md` | .NET defaults (review after) |
| `.github/copilot-instructions.md` | Sections 1, 8 + tech stack |
| `adr/README.md` | Standard template |
| `adr/0001-core-technology-stack.md` | Sections 8, 9 + tech stack |
| GitHub Issues (MVP items) | Section 6 - labelled `story`, with MVP context captured in the issue body |
| GitHub Issues (journeys) | Section 7 - labelled `story`, with spec follow-up captured in the issue body |

**After the prompt completes:**
- Review `CONVENTIONS.md` and `.github/copilot-instructions.md` - they use .NET defaults that need project-specific detail.
- Review ADR-0001 and fill in any alternatives the prompt couldn't infer.

---

## Phase 3: Ongoing Development

### Per-feature workflow

For each journey issue created from Section 7 (or any new feature):

**Step 1 - Write the spec**
Copy `templates/FEATURE-MINI-SPEC.md` into `plan/specs/` in your repo. Fill it in.

**Step 2 - Choose your path**

*Simple feature (clear scope, single deliverable):*
```
In Copilot Chat: use the create-github-issue-feature-from-specification skill
Give it: path to your FEATURE-MINI-SPEC.md
Gets you: one GitHub Issue with the full spec as context
```

*Complex feature (multiple phases, non-trivial architecture):*
```
Step A - In Copilot Chat: use the create-implementation-plan skill
         Give it: a description of what you're building (or paste the mini spec)
         Gets you: plan/feature-[name]-1.md - a phased plan with atomic tasks

Step B - In Copilot Chat: use the create-github-issues-feature-from-implementation-plan skill
         Give it: path to the plan file
         Gets you: one GitHub Issue per phase
```

### When you make an architectural decision

Use the `create-architectural-decision-record` skill at any time:
```
In Copilot Chat: use the create-architectural-decision-record skill
Give it: the decision title, context, what you decided, alternatives you considered
Gets you: adr/XXXX-[title].md, and the ADR index updated automatically
```

### Addressing PR code review comments

See `prompts/repo-pr-address-coding-review.prompt.md`.
Short version: run `/repo-pr-address-coding-review` with the PR number - it reads all open threads,
fixes the code, replies to each thread, and resolves them. Never silently skip a comment.

---

## Quick Reference

| I want to... | Use this |
|---|---|
| Capture a new idea | `templates/IDEA-CAPTURE.md` (in your notes) |
| Plan a new project | `templates/PROJECT-KICKOFF-SPEC.md` (in your notes) |
| Bootstrap a new repo | `Install-CopilotAssets.ps1` + `copilot-packs/solo-dev-project-setup.json` |
| Generate all standing docs | `/repo-new-project-setup` prompt (paste kickoff spec) |
| Spec out a feature | `templates/FEATURE-MINI-SPEC.md` |
| Turn a spec into an Issue | `create-github-issue-feature-from-specification` skill |
| Plan a complex feature | `create-implementation-plan` skill |
| Turn a plan into Issues | `create-github-issues-feature-from-implementation-plan` skill |
| Record an architectural decision | `create-architectural-decision-record` skill |
| Address PR review comments | `/repo-pr-address-coding-review` prompt |

---

## Installing skills into an existing project

If you have an existing project that predates this system, you can still install the skills:

```powershell
.\scripts\Install-CopilotAssets.ps1 `
  -TargetFolder C:\path\to\existing-repo `
  -ConfigFile .\copilot-packs\solo-dev-project-setup.json
```

Use `-Force` to overwrite any existing assets.

---

## Available copilot packs

| Pack | Use for |
|---|---|
| `solo-dev-project-setup.json` | Language/platform-agnostic project setup and planning assets |
| `csharp-dotnet-development.json` | C#/.NET development assets to layer on after setup |
| `blazor-fluentui-development.json` | Blazor with Fluent UI |
| `blazor-mudblazor-development.json` | Blazor with MudBlazor |
