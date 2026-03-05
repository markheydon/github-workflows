# Board Automation

This document describes how the project board **Status** field is automatically managed based on label changes, and defines the Status column set used on the personal project board.

> The project board is at https://github.com/users/markheydon/projects/6.

---

## Status Column Definitions

| Status | Purpose |
|--------|---------|
| **Backlog** | Ready and available to work on — not yet committed to a timeframe. |
| **Up Next** | Committed to this week. Set by `/pm-iteration-plan` during PM Mode. |
| **In Progress** | Actively being worked on. |
| **In Review** | Work complete, awaiting feedback or review. |
| **Blocked** | Cannot proceed — set automatically by the `blocked` label (when item is in Backlog). |
| **Ice Box** | Deprioritised or out of scope — set automatically by the `out-of-scope` label (when item is in Backlog). |
| **Done** | Complete. |

---

## Label-Driven Status Automation

The workflow `add-to-personal-project.yml` watches for `labeled` and `unlabeled` events on the `blocked` and `out-of-scope` labels, and updates the board Status field accordingly.

### Rules

| Event | Condition | Action |
|-------|-----------|--------|
| `blocked` label **added** | Status = **Backlog** | → Move to **Blocked** |
| `out-of-scope` label **added** | Status = **Backlog** | → Move to **Ice Box** |
| `blocked` label **removed** | Status = **Blocked** | → Move to **Backlog** |
| `out-of-scope` label **removed** | Status = **Ice Box** | → Move to **Backlog** |

### Important Constraints

- Status is **only** updated automatically when the item is in a qualifying state (Backlog, Blocked, or Ice Box).
- Items in **Up Next**, **In Progress**, **In Review**, or **Done** are **never touched** by this automation — manual control always takes precedence.
- If an item has a `blocked` label but is actively being worked on (In Progress), its Status is left alone.

---

## PM Mode Transitions

Beyond the automated label-driven rules, the PM prompts also move items between statuses during a PM Mode session:

| Prompt | Transition |
|--------|-----------|
| `/pm-iteration-plan` | Moves confirmed items from **Backlog** → **Up Next** |
| `/pm-iteration-plan` | Moves stalled items from **Up Next** → **Ice Box** or **Blocked** (with user confirmation) |

These transitions are performed via the GitHub Projects v2 GraphQL API.

---

## Setup Note

The **Blocked** and **Ice Box** status options must exist on the project board for automation to work. These must be created manually via the GitHub Projects UI — they cannot be created programmatically by the workflow. Once they exist, the automation handles all transitions.
