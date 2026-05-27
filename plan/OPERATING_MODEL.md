# Operating Model

This document describes how the PM tooling in this repository is intended to be used on a day-to-day and week-to-week basis.

---

## Two Modes of Operation

### PM Mode (weekly or fortnightly)

Run a small set of PM prompts to review all repos, triage issues and PRs, curate the next few days of work, and populate the project board. This is intentional, active curation - not passive auto-add.

Repository participation is controlled centrally in [plan/REPO_PM_PARTICIPATION.md](REPO_PM_PARTICIPATION.md):

- `full` repos participate in the complete workflow, including triage.
- `observe` repos are still surfaced during review and planning, but are exempt from centralised triage and shared label enforcement.
- `exclude` repos are skipped entirely.

**Typical PM Mode sequence:**

1. **`/pm-backlog-review`** - Scans all repos for open issues **and open PRs**, flags stale ones, surfaces ready work across the ecosystem. Identifies repos that haven't had attention recently so nothing gets forgotten. Non-Dependabot PRs without labels are flagged for triage in `full` repos only.
   For OSS repos, it also runs an OSS suitability audit for repo-local community assets (for example `CONTRIBUTING`, `CODE_OF_CONDUCT`, `SECURITY`, templates, and `FUNDING`). Public repos are treated as OSS by default, private repos are never OSS, and exceptional public opt-outs are controlled via `plan/REPO_PM_PARTICIPATION.md`. When you need to follow up on one repo outside the normal backlog-review run, the same audit script can now be scoped to a single `owner/repo` target.
2. **`/pm-iteration-plan`** - Reads the current board state first. Surfaces stalled items in Up Next and asks what to do with them before adding anything new. Proposes a curated cross-repo work list (issues and PRs) based on available capacity; ready-to-review PRs are prioritised above new stories. Moves confirmed items to **Up Next** on the project board.

The result: the project board is populated with a realistic, intentional view of what to work on for the next few days - covering both issues and open PRs.

### Work Mode (daily)

Open the project board and pick the next item. The board has already been curated in PM Mode so it reflects exactly what has been committed to this week. No hunting through repos required.

The optional **`/pm-daily`** prompt provides a quick board state snapshot and nudge on what's most urgent today - useful when Up Next has several items and the priority isn't obvious.

---

## Prompt Reference

| Prompt | Mode | Purpose |
|--------|------|---------|
| `/pm-backlog-review` | PM Mode | Scan all repos for issues and PRs, surface ready work, flag stale repos, flag unlabelled PRs, and report OSS suitability gaps for OSS repos |
| `/pm-iteration-plan` | PM Mode | Read board state, resolve stalled items, curate Up Next (issues and PRs), mutate board |
| `/pm-daily` | Work Mode (optional) | Board snapshot: stalled items, stalled PR reviews, top 3 to focus on today |
| `/pm-issue-triage` | As needed | Classify and label unlabelled issues and PRs |
| `/pm-create-story` | As needed | Create a well-formed story issue |
| `/pm-assistant` | Anytime | Conversational guide - routes you through the right prompts in order |

---

## Board Statuses and Transitions

For the automated rules that drive **Status** field changes on the project board (e.g. `blocked` label → Blocked status), see [`BOARD_AUTOMATION.md`](BOARD_AUTOMATION.md).

For the full project board field configuration, see [`.github/skills/github-issue-management/references/project-setup.md`](../.github/skills/github-issue-management/references/project-setup.md).
