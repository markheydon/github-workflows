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

Dependabot PRs are set to **"Up Next"** automatically. All other items are added without a default status (managed manually on the board).

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
    types: [labeled]
  pull_request_target:
    types: [labeled]

jobs:
  add-to-personal-project:
    uses: markheydon/github-workflows/.github/workflows/add-to-personal-project.yml@main
    secrets:
      PERSONAL_ACCESS_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
```
