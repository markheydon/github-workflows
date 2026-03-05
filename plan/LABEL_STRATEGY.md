# Label Strategy

> **This is the single source of truth for all label definitions used across `markheydon` repositories.**
>
> All workflows, scripts, prompts, and agent instructions derive from this document.
> When this file changes, run the `repo-update-from-strategy` prompt to propagate updates.

---

## Core Work Item Labels

These three labels define the fundamental type of every issue or PR. **Every issue should have exactly one of these.**

| Label | Colour | Hex | Goes on Board? | Description (used in script) | Purpose |
|-------|--------|-----|:--------------:|------------------------------|---------|
| `epic` | Indigo | `#3E4B9E` | No | A large body of work made up of multiple stories. | Epics group stories; they are never tracked directly on the project board. |
| `story` | Green | `#0E8A16` | **Yes** | A user-facing feature, improvement, or technical task. | Stories are the primary unit of work on the board. A story can be a new feature, a documentation change, a refactor, or any other deliverable piece of work. |
| `bug` | Red | `#d73a4a` | **Yes** | Something isn't working as expected. | Bugs are tracked on the board alongside stories. |

### Board Inclusion Rule

Only issues and PRs labelled `story` or `bug` are added to the [personal project board](https://github.com/users/markheydon/projects/6).

Epics are **excluded** — they exist only to group stories in the repository view.

### Dependabot Rule

Dependabot PRs are automatically treated as `story` type on the project board (Work Item Type = "Story", Status = "Up Next"). No manual labelling is needed.

---

## Modifier Labels

These labels provide additional context and can be applied **alongside** a core label. An issue may have multiple modifiers.

| Label | Colour | Hex | Description (used in script) | Purpose |
|-------|--------|-----|------------------------------|---------|
| `priority-high` | Amber | `#FBCA04` | High priority — address before other items. | Flags urgent work that should jump the queue. |
| `blocked` | Light grey | `#cfd3d7` | Blocked by another issue or external dependency. | Indicates work cannot proceed until something else is resolved. Replaces the old `dependency` label. |
| `not-started` | White | `#ffffff` | Work has not yet started. | Useful for explicit backlog filtering. |
| `out-of-scope` | Grey | `#ededed` | Intentionally deferred — may be revisited in future. | Parked work, not rejected. See also `wontfix` for permanent rejection. |
| `feedback-required` | Lavender | `#d9d4f5` | Waiting for feedback before work can proceed. | Use when the ball is in someone else's court. |
| `waiting-for-details` | Lavender | `#d9d4f5` | Further details required before work can start. | Use when an issue needs more information before it can be acted on. |

---

## GitHub Default Labels

Every new GitHub repository includes a set of default labels. Rather than deleting these, this strategy integrates them. They are treated as **optional modifier labels** and their colours are kept at GitHub's defaults.

| Label | Hex | Description (used in script) | Notes |
|-------|-----|------------------------------|-------|
| `bug` | `#d73a4a` | Something isn't working as expected. | Also a core label — see above. |
| `documentation` | `#0075ca` | Improvements or additions to documentation. | Valid modifier alongside `story`. |
| `duplicate` | `#cfd3d7` | This issue or pull request already exists. | Housekeeping label. |
| `enhancement` | `#a2eeef` | An improvement to existing functionality. | Compatible with `story` — apply both if relevant. `story` remains the board trigger. |
| `good first issue` | `#7057ff` | Good for newcomers. | Useful if onboarding contributors. |
| `help wanted` | `#008672` | Extra attention is needed. | Outward-facing signal. |
| `invalid` | `#e4e669` | This doesn't seem right. | Housekeeping label. |
| `question` | `#d876e3` | Further information is requested. | Pre-triage state. |
| `wontfix` | `#ffffff` | This will not be worked on. | Permanent rejection. Distinct from `out-of-scope`, which is deferred rather than rejected. |

> **Note:** The script sets descriptions for all default labels to ensure consistency, but uses GitHub's default colours exactly as shipped.

---

## Naming Conventions

- All label names are **lowercase**.
- Multi-word labels use **hyphens** (e.g., `priority-high`, not `Priority High` or `priority_high`).
- Core labels are **single words** (`epic`, `story`, `bug`).

---

## Project Board Field Mapping

When an issue or PR is added to the project board, the Work Item Type field is set based on the label:

| Label | Work Item Type |
|-------|---------------|
| `story` | Story |
| `bug` | Bug |
| Dependabot PR (any) | Story |

> The `blocked` and `out-of-scope` modifier labels also drive automatic **Status** field transitions on the board. See [`BOARD_AUTOMATION.md`](BOARD_AUTOMATION.md) for the full rules and Status column definitions.

---

## Decision Guide

Use this to decide which label(s) to apply to a new issue:

1. **Is this a large body of work containing multiple sub-tasks?** → `epic`
2. **Is this a new feature, improvement, documentation change, or technical task?** → `story`
3. **Is something broken or not working as expected?** → `bug`
4. **Is it blocked by another issue or external work?** → add `blocked`
5. **Is it urgent?** → add `priority-high`
6. **Is it on the backlog but not being worked on yet?** → add `not-started`
7. **Has it been deferred but may be revisited?** → add `out-of-scope`
8. **Will it definitely never be actioned?** → add `wontfix`
9. **Waiting on someone?** → add `feedback-required` or `waiting-for-details`

---

## Labels NOT Used

The following labels have been **deliberately excluded** from this strategy. Do not create or use them:

- `feature` — superseded by `story`
- `improvement` — superseded by `story`
- `technical` — superseded by `story`
- `spike` — treated as a `story`
- `dependency` — replaced by `blocked`
- `incident`, `service request`, `problem`, `change request` — service desk labels, not used in dev repos
- `feedback required`, `waiting for details` (with spaces) — use the hyphenated versions instead

---

## Versioning

| Version | Date | Change |
|---------|------|--------|
| 1.0 | 2026-03-04 | Initial strategy document. Consolidates from previous ad-hoc approach. Removes service desk labels. Integrated GitHub default labels. Clarified purpose of various labels. |