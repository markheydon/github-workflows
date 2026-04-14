# Board Management

This document describes how the project board **Status** field is managed and defines the Status column set used on the personal project board.

> The project board is at https://github.com/users/markheydon/projects/6.

---

## Status Column Definitions

| Status | Purpose |
|--------|---------|
| **Backlog** | Ready and available to work on - not yet committed to a timeframe. |
| **Up Next** | Committed to this week. Set by `/pm-iteration-plan` during PM Mode. |
| **In Progress** | Actively being worked on. |
| **In Review** | Work complete, awaiting feedback or review. |
| **Blocked** | Cannot proceed - moved here by Copilot PM prompts when the `blocked` label is applied and the item was in Backlog. |
| **Ice Box** | Deprioritised or out of scope - moved here by Copilot PM prompts when the `out-of-scope` label is applied and the item was in Backlog. |
| **Done** | Complete. |

---

## How Items Get onto the Board

Items are added to the board **manually during PM Mode sessions** using the Copilot PM prompts. There is no automated workflow adding items on label events.

- `/pm-backlog-review` - identifies items labelled `story` or `bug` that are missing from the board and flags them for action.
- `/pm-iteration-plan` - adds confirmed items to the board, placing them in **Up Next** or **Backlog** as appropriate.

Dependabot PRs are surfaced during `/pm-backlog-review` and added to the board by `/pm-iteration-plan` when relevant.

**Board inclusion rules (enforced by PM prompts, not automation):**
- `story` → eligible for board
- `bug` → eligible for board
- `epic` → **never** added to board
- Dependabot PRs → treated as `story` type when added

---

## Label-Driven Status Rules

These rules define the intended relationship between labels and board Status. They are enforced by Copilot during PM Mode sessions (via `/pm-backlog-review` and `/pm-iteration-plan`), not by an automated workflow.

| Event | Condition | Action |
|-------|-----------|--------|
| `blocked` label **added** | Status = **Backlog** | → Move to **Blocked** |
| `out-of-scope` label **added** | Status = **Backlog** | → Move to **Ice Box** |
| `blocked` label **removed** | Status = **Blocked** | → Move to **Backlog** |
| `out-of-scope` label **removed** | Status = **Ice Box** | → Move to **Backlog** |

### Important Constraints

- Status is **only** updated when the item is in a qualifying state (Backlog, Blocked, or Ice Box).
- Items in **Up Next**, **In Progress**, **In Review**, or **Done** are **never moved** by these rules - manual control always takes precedence.
- If an item has a `blocked` label but is actively being worked on (In Progress), its Status is left alone.

---

## PM Mode Transitions

The PM prompts move items between statuses during a PM Mode session:

| Prompt | Transition |
|--------|-----------|
| `/pm-iteration-plan` | Moves confirmed items from **Backlog** → **Up Next** |
| `/pm-iteration-plan` | Moves stalled items from **Up Next** → **Ice Box** or **Blocked** (with user confirmation) |
| `/pm-backlog-review` | Flags items with `blocked`/`out-of-scope` labels whose Status does not match - prompts correction |

These transitions are performed via the GitHub Projects v2 GraphQL API.

---

## Setup Note

The **Blocked** and **Ice Box** status options must exist on the project board. These must be created manually via the GitHub Projects UI - they cannot be created programmatically.
