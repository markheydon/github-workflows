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

Items are added to the board **during PM Mode sessions** by the Copilot PM prompts — there is no automated workflow adding items on label events.

- `story` → eligible for board
- `bug` → eligible for board
- `epic` → **never** added to board
- Dependabot PRs → treated as `story` type when added; surfaced by `/pm-backlog-review`

The prompts that add items to the board are:
- `/pm-backlog-review` — identifies `story`/`bug` items missing from the board and flags them
- `/pm-iteration-plan` — adds confirmed items to the board via the GitHub Projects v2 API

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
| **Blocked** | Cannot proceed — moved here by Copilot PM prompts when the `blocked` label is applied and the item was in Backlog. |
| **Ice Box** | Deprioritised or out of scope — moved here by Copilot PM prompts when the `out-of-scope` label is applied and the item was in Backlog. |
| **Done** | Complete. |

### Label-Driven Status Rules

These rules define the intended relationship between labels and board Status. They are enforced by Copilot during PM Mode sessions, not by an automated workflow.

| Event | Condition | Action |
|-------|-----------|--------|
| `blocked` label **added** | Status = Backlog | → Set to **Blocked** |
| `out-of-scope` label **added** | Status = Backlog | → Set to **Ice Box** |
| `blocked` label **removed** | Status = Blocked | → Set to **Backlog** |
| `out-of-scope` label **removed** | Status = Ice Box | → Set to **Backlog** |

Items in **Up Next**, **In Progress**, **In Review**, or **Done** are never moved by these rules.

### Blocked Label and Status Consistency Rule

The `blocked` label and the **Blocked** board status must always be in sync:

- Every item in the **Blocked** column **must** have the `blocked` label applied.
- Every item with the `blocked` label **must** be in the **Blocked** column (unless it is in Up Next, In Progress, In Review, or Done — where these rules do not apply).

During any consistency check or backlog review, flag and correct any items where the label and column status disagree.
