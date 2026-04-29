# Runbook - Solo Dev Project System

This repository is a toolkit for bootstrapping and managing AI-assisted solo .NET/C# projects.
This runbook explains what everything is for and when to use it.

---

## The Mental Model

There are three phases to every project. Different tools apply at each phase.

```
Phase 1: Pre-repo planning    → templates/
Phase 2: Repo setup           → copilot-packs/ + .github/prompts/new-project-setup-mh
Phase 3: Ongoing development  → installed skills and agents + templates/FEATURE-MINI-SPEC.md
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

### Command 1 - Bootstrap the repo

The assets in this repository are split across two destinations in the target repo:
- `templates/project-root/` -> copied into the target repository root as editable starter files
- `agents/`, `skills/`, and `prompts/` -> copied into the target repository's `.github/` folder

Use `Install-ProjectBootstrap.ps1` to do both in one step. It copies the root templates first, then calls `Install-CopilotAssets.ps1` for the `.github` assets.

```powershell
.\scripts\Install-ProjectBootstrap.ps1 `
  -TargetFolder C:\path\to\your-new-repo `
  -ConfigFile .\copilot-packs\solo-dev-project-setup.json
```

This copies the following starter files into your new repo root:
- `GOALS.md`
- `SCOPE.md`
- `AGENTS.md`
- `CONVENTIONS.md`

It then installs the following into your new repo's `.github/` folder:
- `create-architectural-decision-record` skill
- `create-implementation-plan` skill
- `create-github-issue-feature-from-specification` skill
- `create-github-issues-feature-from-implementation-plan` skill
- `documentation-writer` skill (Diátaxis framework guidance)
- `project-documentation` skill (project-aware documentation placement, terminology, and review guidance)
- `tech-writer` agent (project-aware writing agent for docs, guides, tutorials, and blogs)
- `new-project-setup-mh` prompt (from this repo, installed with the pack's `nameTransform` settings)
- `pr-address-coding-review-mh` prompt (from this repo, installed with the pack's `nameTransform` settings)

The starter files in the repo root are there for the prompt to populate and for the user to edit later. They are the single source template set for future project bootstraps.

This pack is intentionally technology-agnostic. After bootstrap, install any language or platform pack you need.

By default, `Install-CopilotAssets.ps1` clones source repositories into a per-user cache at `~/.copilot-assets-cache` so repeated runs reuse the same local clones. Use `-CloneRoot` on `Install-ProjectBootstrap.ps1` to override this location when needed.

Optional example for C#/.NET:

```powershell
.\scripts\Install-CopilotAssets.ps1 `
  -TargetFolder C:\path\to\your-new-repo `
  -ConfigFile .\copilot-packs\csharp-dotnet-development.json
```

> **Note:** Add-on packs only install `.github` assets - they do not touch the root templates
> (`GOALS.md`, `SCOPE.md`, etc.), so `Install-ProjectBootstrap.ps1` is not appropriate here.
> Use `Install-CopilotAssets.ps1` directly for any pack layered on after the initial bootstrap.

### Command 2 - Run the setup prompt

Open the new repo in VS Code. In Copilot Chat, run:

```
/new-project-setup-mh
```

When prompted, paste in your completed `PROJECT-KICKOFF-SPEC.md`. The prompt will generate:

| File | Source section |
|---|---|
| `GOALS.md` | Sections 4, 11, 12 |
| `SCOPE.md` | Sections 5, 6 |
| `AGENTS.md` | Copied root template + prompt updates |
| `CONVENTIONS.md` | .NET defaults (review after) |
| `.github/copilot-instructions.md` | Sections 1, 8 + tech stack |
| First ADR for the core technology stack | Sections 8, 9 + tech stack |
| GitHub Issues (MVP items) | Section 6 - labelled `story`, with MVP context captured in the issue body |
| GitHub Issues (journeys) | Section 7 - labelled `story`, with spec follow-up captured in the issue body |

> **Note - Copilot may write issue files instead of creating real issues.**
> The prompt asks Copilot to create real GitHub Issues. Depending on the environment and
> available permissions, Copilot may instead write draft issue files into `.github/issues/`
> (for example `1.md`, `2.md`, `journey-handle-api-errors.md`, etc.).
>
> If you end up with a `.github/issues/` folder, open Copilot Chat and say:
> *"Read the files in `.github/issues/` and create each one as a real GitHub Issue labelled `story`."*
> Once the real issues exist, delete the `.github/issues/` folder.
>
> The `> ⚠️ A Feature Mini Spec should be completed before work begins on this issue.` line at the
> bottom of every issue body is intentional - it is a reminder note, not an error.

**Understanding the two types of generated issues:**

- **MVP scope items** (`1.md`, `2.md`, etc.) are concrete deliverable story issues for the first
  release. Each one maps to a numbered item from Section 6 of your kickoff spec. Work on them
  after writing a Feature Mini Spec (see Phase 3 below).
- **Journey issues** (`journey-*.md`) are *placeholder* tracking issues drawn from Section 7. They
  are not stories to implement directly. For each one: write a Feature Mini Spec first, break it
  into individual story issues, then close or update the journey issue linking to the spec.

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
Gets you: an ADR drafted with the upstream skill
```

### Addressing PR code review comments

See `prompts/pr-address-coding-review.prompt.md`.
Short version: run `/pr-address-coding-review-mh` with the PR number - it reads all open threads,
fixes the code, replies to each thread, and resolves them. Never silently skip a comment.

### Writing and updating documentation

After installation into a target repository, the `tech-writer` agent handles project documentation work there. Select it from the Agent mode picker in VS Code Copilot Chat in that target repository.

It loads two skills on activation:
- `documentation-writer` for Diátaxis guidance
- `project-documentation` for project-aware placement, terminology, and review guidance

It also reads that repository's project context files (`GOALS.md`, `SCOPE.md`, `CONVENTIONS.md`, `.github/copilot-instructions.md`) so it writes in terms of the project rather than generic boilerplate.

Use it for:
- Creating or updating user guides in `docs/` (Diátaxis-structured)
- Technical blog posts and tutorials
- Any documentation that needs to reflect the project's goals and scope accurately

For ADRs, use the `create-architectural-decision-record` skill instead.

---

## Quick Reference

| I want to... | Use this |
|---|---|
| Capture a new idea | `templates/IDEA-CAPTURE.md` (in your notes) |
| Plan a new project | `templates/PROJECT-KICKOFF-SPEC.md` (in your notes) |
| Bootstrap a new repo | `Install-ProjectBootstrap.ps1` + `copilot-packs/solo-dev-project-setup.json` |
| Generate all standing docs | `/new-project-setup-mh` prompt (paste kickoff spec) |
| Spec out a feature | `templates/FEATURE-MINI-SPEC.md` |
| Turn a spec into an Issue | `create-github-issue-feature-from-specification` skill |
| Plan a complex feature | `create-implementation-plan` skill |
| Turn a plan into Issues | `create-github-issues-feature-from-implementation-plan` skill |
| Record an architectural decision | `create-architectural-decision-record` skill |
| Address PR review comments | `/pr-address-coding-review-mh` prompt |
| Write or update project documentation | `tech-writer` agent (select from Agent mode picker) |
| Write an ADR | `create-architectural-decision-record` skill |

---

## Installing skills into an existing project

> **Note:** `Install-ProjectBootstrap.ps1` is a **one-off bootstrap script** for new repos only.
> It copies root template files (`GOALS.md`, `SCOPE.md`, `AGENTS.md`, `CONVENTIONS.md`) **and**
> installs Copilot assets. If your project already has those root files, running it again would
> overwrite them unnecessarily. For adding packs to an existing project - or layering on add-on
> packs after the initial setup - always use `Install-CopilotAssets.ps1` directly.

If you have an existing project that predates this system, you can still install the skills:

```powershell
.\scripts\Install-CopilotAssets.ps1 `
  -TargetFolder C:\path\to\existing-repo `
  -ConfigFile .\copilot-packs\solo-dev-project-setup.json
```

Use `-Force` to overwrite any existing `.github` assets.

---

## Available copilot packs

| Pack | Use for |
|---|---|
| `solo-dev-project-setup.json` | Language/platform-agnostic project setup and planning assets |
| `csharp-dotnet-development.json` | C#/.NET development assets to layer on after setup |
| `blazor-fluentui-development.json` | Blazor with Fluent UI |
| `blazor-mudblazor-development.json` | Blazor with MudBlazor |
