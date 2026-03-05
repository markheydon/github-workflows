# Project Board Setup Reference

> This file describes the project board configuration for `markheydon`'s personal GitHub Project.
>
> If you are using a copy of this skill in another repo, update the project URL and field mappings here. See [`CUSTOMISATION_GUIDE.md`](CUSTOMISATION_GUIDE.md).

---

## Project Board

| Setting | Value |
|---------|-------|
| URL | https://github.com/users/markheydon/projects/6 |
| Type | GitHub Projects (v2) |
| Owner | Personal (markheydon) |

---

## Board Inclusion Rules

Issues and PRs are added to the board **automatically** when labelled `story` or `bug`, via the reusable workflow `add-to-personal-project.yml` in `markheydon/github-workflows`.

- `story` → added to board
- `bug` → added to board
- `epic` → **never** added to board
- Dependabot PRs → added automatically as `story` type (no labelling required)

---

## Work Item Type Field Mapping

When an item is added to the board, the **Work Item Type** custom field is set:

| Trigger | Work Item Type |
|---------|---------------|
| Label: `story` | Story |
| Label: `bug` | Bug |
| Dependabot PR | Story |

---

## Status Field

The board uses the following Status column values:

| Status | Purpose |
|--------|---------|
| **Backlog** | Ready and available to work on — not yet committed to a timeframe. |
| **Up Next** | Committed to this week. Set by `/pm-iteration-plan` during PM Mode. |
| **In Progress** | Actively being worked on. |
| **In Review** | Work complete, awaiting feedback or review. |
| **Blocked** | Cannot proceed — set automatically when `blocked` label is applied (if item was in Backlog). |
| **Ice Box** | Deprioritised or out of scope — set automatically when `out-of-scope` label is applied (if item was in Backlog). |
| **Done** | Complete. |

### Default Statuses on Add

- **Dependabot PRs:** set to **Up Next** automatically.
- **All other items:** no default status — managed via PM Mode prompts or the automation rules below.

### Label-Driven Status Automation

| Event | Condition | Action |
|-------|-----------|--------|
| `blocked` label **added** | Status = Backlog | → Set to **Blocked** |
| `out-of-scope` label **added** | Status = Backlog | → Set to **Ice Box** |
| `blocked` label **removed** | Status = Blocked | → Set to **Backlog** |
| `out-of-scope` label **removed** | Status = Ice Box | → Set to **Backlog** |

Items in **Up Next**, **In Progress**, **In Review**, or **Done** are never touched by this automation.

### Blocked Label and Status Consistency Rule

The `blocked` label and the **Blocked** board status must always be in sync:

- Every item in the **Blocked** column **must** have the `blocked` label applied.
- Every item with the `blocked` label **must** be in the **Blocked** column (unless it is in In Progress, In Review, or Done — where status automation does not apply).

The workflow enforces this going forward for items in Backlog. However, items manually placed in the Blocked column before the automation existed will not have the label. During any consistency check or backlog review, flag and correct any items where the label and column status disagree.

---

## Required Secret

The workflow requires a `PERSONAL_ACCESS_TOKEN` secret set on the calling repository. This token must have permissions to:

- Read issues and PRs
- Update GitHub Projects (v2)

---

## Automation Workflow

The reusable workflow is at:

```
markheydon/github-workflows/.github/workflows/add-to-personal-project.yml@main
```

Calling repos use a thin trigger file. Minimal example:

```yaml
on:
  issues:
    types: [labeled, unlabeled]
  pull_request_target:
    types: [labeled, unlabeled]

jobs:
  add-to-personal-project:
    uses: markheydon/github-workflows/.github/workflows/add-to-personal-project.yml@main
    secrets:
      PERSONAL_ACCESS_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
```
