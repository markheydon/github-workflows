# GitHub Labels Reference

> Source of truth: [`plan/LABEL_STRATEGY.md`](../../../plan/LABEL_STRATEGY.md) in `markheydon/github-workflows`.
>
> If you are using a copy of this skill in another repo, update this file to match that repo's label configuration. See [`CUSTOMISATION_GUIDE.md`](CUSTOMISATION_GUIDE.md).

---

## Core Work Item Labels

Every issue should have **exactly one** core label.

| Label | Colour | Hex | On Board? | Description |
|-------|--------|-----|:---------:|-------------|
| `epic` | Indigo | `#3E4B9E` | No | A large body of work made up of multiple stories. |
| `story` | Green | `#0E8A16` | **Yes** | A user-facing feature, improvement, or technical task. |
| `bug` | Red | `#d73a4a` | **Yes** | Something isn't working as expected. |

**Board rule:** Only `story` and `bug` issues and PRs go on the project board. Epics are excluded.

---

## Modifier Labels

Apply alongside a core label as needed. Multiple modifiers are allowed.

| Label | Colour | Hex | Description |
|-------|--------|-----|-------------|
| `priority-high` | Amber | `#fbca04` | High priority — address before other items. |
| `blocked` | Light grey | `#cfd3d7` | Blocked by another issue or external dependency. |
| `not-started` | White | `#ffffff` | Work has not yet started. |
| `out-of-scope` | Grey | `#ededed` | Intentionally deferred — may be revisited in future. |
| `feedback-required` | Lavender | `#d9d4f5` | Waiting for feedback before work can proceed. |
| `waiting-for-details` | Lavender | `#d9d4f5` | Further details required before work can start. |

---

## Naming Conventions

- All labels are **lowercase**.
- Multi-word labels use **hyphens**: `priority-high`, not `Priority High` or `priority_high`.
- Core labels are single words: `epic`, `story`, `bug`.

---

## Decision Guide

1. Multiple sub-tasks grouped together? → `epic`
2. New feature, improvement, documentation change, or technical task? → `story`
3. Something broken? → `bug`
4. Urgent? → add `priority-high`
5. Blocked by another issue or external work? → add `blocked`
6. Not being worked on yet? → add `not-started`
7. Deferred? → add `out-of-scope`
8. Waiting on someone? → add `feedback-required` or `waiting-for-details`

---

## Excluded Labels

---

## GitHub Default Labels

These are optional modifier labels, using GitHub's default colours and descriptions:

| Label             | Hex      | Description                                 |
|-------------------|----------|---------------------------------------------|
| bug               | #d73a4a  | Something isn't working as expected.        |
| documentation     | #0075ca  | Improvements or additions to documentation. |
| duplicate         | #cfd3d7  | This issue or pull request already exists.  |
| enhancement       | #a2eeef  | An improvement to existing functionality.   |
| good first issue  | #7057ff  | Good for newcomers.                         |
| help wanted       | #008672  | Extra attention is needed.                  |
| invalid           | #e4e669  | This doesn't seem right.                    |
| question          | #d876e3  | Further information is requested.           |
| wontfix           | #ffffff  | This will not be worked on.                 |

---

## Excluded Labels
Do not create or use these — they are superseded or intentionally removed:

- `feature`, `improvement`, `technical` → use `story`
- `spike` → use `story`
- `dependency` → use `blocked`
- `incident`, `service request`, `problem`, `change request` → service desk labels, not used
- `feedback required`, `waiting for details` (with spaces) → use hyphenated versions
