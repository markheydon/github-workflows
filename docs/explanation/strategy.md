---
title: Explanation - Why This Strategy
description: Rationale and design principles behind the workflow and documentation approach.
---

# Explanation: Why This Strategy?

This documentation site and workflow exist to solve a real problem: as a solo developer managing many repos, it's easy to lose track of issues and let work go stale. The system here is designed to:

- Surface neglected work across all repos, but **focus attention on the most important ones** using a tiered priorities file ([plan/REPO_PRIORITIES.md](../../plan/REPO_PRIORITIES.md)).
- Separate repo visibility from repo governance using [plan/REPO_PM_PARTICIPATION.md](../../plan/REPO_PM_PARTICIPATION.md), so some repos can stay visible without being centrally triaged.
- Keep the project board lean and intentional by only surfacing work from Tier 1, 2, and 3 repos (and always surfacing PRs from any non-`exclude` repo).
- Minimise manual admin by automating triage, board updates, and label consistency.
- Make it easy for others to adopt or adapt the approach.

## Why Repository Priorities?

Not all repos are equally important at all times. The priorities file lets you:
- Promote or demote repos as your focus changes
- Pause repos temporarily without losing their tier
- Exclude legacy or irrelevant repos from PM operations
- Always surface PRs, even from paused or low-priority repos

This keeps the board and prompt suggestions relevant, actionable, and free from noise.

## Why Separate Participation From Priority?

Priority and participation solve different problems:

- **Priority** decides whether a repo is Tier 1, 2, 3, Paused, or Not PM Tracked.
- **Participation** decides whether that repo is fully managed, planning-visible only, or completely excluded.

That split avoids an awkward all-or-nothing choice. Some repos, such as experimental or independently managed projects, should still be visible when planning the week but should not be relabelled or triaged by the shared workflow.

## Public vs Internal Documentation

- **Public docs (this site):** Focus on how to use, adapt, and extend the workflow. No details are hidden, but irrelevant internal specifics are omitted for clarity.
- **Internal docs (repo README):** Cover contributor-facing details, implementation notes, and anything needed to maintain or extend the system.

## Why Diátaxis?

The Diátaxis framework ensures every type of user need is covered:
- **Tutorials:** For newcomers.
- **How-to Guides:** For specific tasks.
- **Reference:** For technical details.
- **Explanation:** For rationale and design.

---

For day-to-day usage, see the [Operating Model](https://github.com/markheydon/github-workflows/blob/main/plan/OPERATING_MODEL.md).
