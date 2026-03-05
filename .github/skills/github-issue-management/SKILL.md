---
name: github-issue-management
description: Manage GitHub Issues using a structured label taxonomy (epic/story/bug), triage new issues, apply labels per strategy, maintain project board membership, and keep issues organised across one or more repos. Use when creating issues, triaging unlabelled issues, updating labels, managing milestones, or checking board consistency.
license: MIT
metadata:
  author: Mark Heydon
  version: "1.0"
compatibility: Requires GitHub CLI (gh) and GitHub API access. A .github/copilot-instructions.md may optionally be present in the target repo; if it exists, read it for repo-specific overrides.
---

# GitHub Issue Management Skill

This skill helps you manage GitHub Issues consistently using a **three-tier label taxonomy**: `epic`, `story`, and `bug`. It covers triage, label application, project board management, and milestone organisation.

## When to use this skill

- Creating a new issue and unsure which label(s) to apply.
- Triaging a batch of unlabelled issues.
- Checking whether issues are correctly on (or missing from) the project board.
- Planning iterations by grouping stories under epics.
- Keeping label usage consistent across multiple repos.

## How this skill is organised

| File | Purpose |
|------|---------|
| This file | Core workflow instructions |
| [`references/github-labels.md`](references/github-labels.md) | Full label taxonomy (names, colours, purposes, decision rules) |
| [`references/project-setup.md`](references/project-setup.md) | Project board configuration and field mappings |
| [`references/CUSTOMISATION_GUIDE.md`](references/CUSTOMISATION_GUIDE.md) | How to adapt this skill for a different repo |
| [`assets/triage-workflow.md`](assets/triage-workflow.md) | Visual triage decision flow |
| [`scripts/triage-example.sh`](scripts/triage-example.sh) | Example script for automating label application via GitHub CLI |

---

## Core Workflow

### 1. Always start with the label taxonomy

Before creating or labelling any issue, read [`references/github-labels.md`](references/github-labels.md). If a `.github/copilot-instructions.md` exists in the **target repo**, read it too — it may override label names or add repo-specific rules.

> **If you are operating in a repo other than `markheydon/github-workflows`**, check [`references/CUSTOMISATION_GUIDE.md`](references/CUSTOMISATION_GUIDE.md) to understand what to override.

### 2. Classify the issue

Every issue needs **exactly one** core label:

| If the issue is... | Apply label |
|--------------------|-------------|
| A large body of work grouping multiple tasks | `epic` |
| A feature, improvement, or technical task | `story` |
| Something broken or not working | `bug` |

Use the decision guide in [`references/github-labels.md`](references/github-labels.md) for edge cases.

### 3. Apply modifier labels (optional)

After the core label, assess whether any modifier labels apply. Multiple modifiers are allowed. See [`references/github-labels.md`](references/github-labels.md) for the full list.

Common combinations:
- `story` + `priority-high` — urgent new work.
- `story` + `blocked` — blocked waiting on another issue.
- `bug` + `priority-high` — urgent fix needed.
- `story` + `out-of-scope` — explicit backlog deferral.

### 4. Project board membership

Issues and PRs labelled `story` or `bug` belong on the project board. `epic` issues do **not** go on the board. See [`references/project-setup.md`](references/project-setup.md) for board configuration details and the Work Item Type field mapping.

### 5. Milestone and epic linkage

- Stories should be linked to a parent epic via a checklist item in the epic's description (e.g., `- [ ] #42 Short description`).
- Milestones are optional but recommended for grouping stories into iterations.

---

## Creating Issues

When creating a new issue, always:

1. Determine core label (`epic`, `story`, or `bug`).
2. Write a title that is specific and action-oriented.
3. Add relevant modifier labels.
4. For stories: link to the parent epic if one exists.
5. For epics: create a task list of planned child stories in the description.

### Story template

```markdown
## Context
Brief description of the background or problem this addresses.

## What needs to happen
Clear description of the work to be done.

## Acceptance criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Parent Epic
Closes #<epic-number> (if applicable)
```

### Bug template

```markdown
## What happened
Clear description of the unexpected behaviour.

## Steps to reproduce
1. Step 1.
2. Step 2.

## Expected behaviour
What should have happened.

## Environment
Relevant version/environment info.
```

---

## Triage Workflow

When triaging a batch of unlabelled issues:

1. Read each issue title and body.
2. Classify as `epic`, `story`, or `bug` using the decision guide.
3. Apply the core label and any appropriate modifiers.
4. If the issue is clearly `story` or `bug`, check it should be on the project board.
5. Flag any issues that need more information before classification — apply `waiting-for-details`.
6. Summarise what was triaged and highlight anything requiring human review.

**Watch for disguised epics.** An issue labelled `story` may actually be an epic if it: has multiple sub-issues listed, describes a large feature with its own data model or architecture section, or has an acceptance criteria list that spans several independent deliverables. If so, relabel it `epic`, remove it from the project board, and ensure its sub-issues are individually labelled and have appropriate statuses (e.g. `blocked` if they depend on each other sequentially).

For a visual flow, see [`assets/triage-workflow.md`](assets/triage-workflow.md).

---

## Consistency Checks

When asked to validate issue/label consistency:

1. List all open issues without a core label (`epic`, `story`, or `bug`) — these need triage.
2. List all issues labelled `story` or `bug` that are **not** on the project board — these need adding.
3. List all issues labelled `epic` that **are** on the project board — these need removing.
4. Report any labels in use that are not in the approved taxonomy.
5. Summarise findings and ask whether to auto-fix.
