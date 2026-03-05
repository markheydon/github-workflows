# Operating Model

This document describes how the PM tooling in this repository is intended to be used on a day-to-day and week-to-week basis.

---

## Two Modes of Operation

### PM Mode (weekly or fortnightly)

Run a small set of PM prompts to review all repos, triage issues and PRs, curate the next few days of work, and populate the project board. This is intentional, active curation — not passive auto-add.

**Typical PM Mode sequence:**

1. **`/pm-backlog-review`** — Scans all repos for open issues **and open PRs**, flags stale ones, surfaces ready work across the ecosystem. Identifies repos that haven't had attention recently so nothing gets forgotten. Non-Dependabot PRs without labels are flagged for triage.
2. **`/pm-iteration-plan`** — Reads the current board state first. Surfaces stalled items in Up Next and asks what to do with them before adding anything new. Proposes a curated cross-repo work list (issues and PRs) based on available capacity; ready-to-review PRs are prioritised above new stories. Moves confirmed items to **Up Next** on the project board.

The result: the project board is populated with a realistic, intentional view of what to work on for the next few days — covering both issues and open PRs.

### Work Mode (daily)

Open the project board and pick the next item. The board has already been curated in PM Mode so it reflects exactly what has been committed to this week. No hunting through repos required.

The optional **`/pm-daily`** prompt provides a quick board state snapshot and nudge on what's most urgent today — useful when Up Next has several items and the priority isn't obvious.

---

## Prompt Reference

| Prompt | Mode | Purpose |
|--------|------|---------|
| `/pm-backlog-review` | PM Mode | Scan all repos for issues and PRs, surface ready work, flag stale repos, flag unlabelled PRs |
| `/pm-iteration-plan` | PM Mode | Read board state, resolve stalled items, curate Up Next (issues and PRs), mutate board |
| `/pm-daily` | Work Mode (optional) | Board snapshot: stalled items, stalled PR reviews, top 3 to focus on today |
| `/pm-issue-triage` | As needed | Classify and label unlabelled issues and PRs |
| `/pm-create-story` | As needed | Create a well-formed story issue |
| `/pm-assistant` | Anytime | Conversational guide — routes you through the right prompts in order |

---

## Board Statuses and Transitions

For the automated rules that drive **Status** field changes on the project board (e.g. `blocked` label → Blocked status), see [`BOARD_AUTOMATION.md`](BOARD_AUTOMATION.md).

For the full project board field configuration, see [`.github/skills/github-issue-management/references/project-setup.md`](../.github/skills/github-issue-management/references/project-setup.md).
