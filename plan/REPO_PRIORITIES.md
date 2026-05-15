# Repository Priorities

This file defines the priority tiers for all active `markheydon` repositories. It is the single source of truth used by PM prompts and agents when deciding which repos to scan for issue candidates and how to order proposals.

Participation mode is controlled separately by [plan/REPO_PM_PARTICIPATION.md](REPO_PM_PARTICIPATION.md). Priority decides when a repo's work is considered; participation decides how the PM workflow is allowed to treat that repo.

---

## Priority Rules

| Tier | Name | Issue Scanning | PR Scanning |
|------|------|----------------|-------------|
| 1 | **Active Focus** | ✅ First - highest priority candidates | ✅ Always |
| 2 | **Medium Priority** | ✅ After Tier 1 | ✅ Always |
| 3 | **Low Priority** | ✅ Last - only when capacity remains after Tier 1 and 2 | ✅ Always |
| - | **Not PM Tracked** | ❌ Skipped for issue scanning | ✅ Always |

> **Key rule:** PRs from **any** repo - including Not PM Tracked and Paused - are always surfaced and must always be resolved. A PR awaiting review is never deprioritised because of the repo's tier.

---

## Tier 1 - Active Focus

| Repository | Description | Notes |
|------------|-------------|-------|
| `markheydon/import-to-planner` | Blazor CSV-to-Planner import utility | Side project. Graph API integration in progress. |
| `markheydon/better-freeagent-projects` | Blazor add-on improving FreeAgent Projects | FreeAgent-related; pick up when FreeAgent work is unblocked. |
| `markheydon/freeagent-dotnet` | Open source .NET FreeAgent API client | Foundational library. Work here can unblock other FreeAgent repos. |
| `markheydon/monolog-wp-cli` | WordPress CLI logging bridge for Monolog | Recently transferred from `mhcg`; backlog cleanup, dependency refresh, and AI/spec retrofit now needed. |
| `markheydon/solo-dev-board` | Open source .NET Blazor app for a solo developer to manage multiple repos in a centralised manner. | 

---

## Tier 2 - Medium Priority

| Repository | Description | Notes |
|------------|-------------|-------|
| `markheydon/github-workflows` | PM tooling, reusable workflows, Copilot assets | Always relevant - this repo. |
| `markheydon/mhcg-cs-mhcgintegrationapp` | FreeAgent / Stripe / Dataverse integration app | Primary client tooling. Core billing epic in progress. Internal app with private repo. |
| `markheydon/national-lottery-generator` | Fun lottery number predictor | Good for a quick win or learning experiment. |
| `markheydon/mhcg-pp-mhcgapps` | Power Platform apps (model-driven) | Companion to integration app. |
| `markheydon/avd-occasional` | Azure Virtual Desktop Bicep setup | Side project. Script and schedule improvements in progress. |

---

## Tier 3 - Low Priority

| Repository | Description | Notes |
|------------|-------------|-------|
| `markheydon/rename-my-files-ai` | PowerShell AI file renaming tool | Very low priority. Only suggest if Tier 1 and 2 have no suitable candidates. |
| `markheydon/the-teachings-of-monkey` | Hugo archive site for TV series content | Very low priority. Long-running passion project. |
| `markheydon/m365-powershell-docker` | Docker utility - no active feature work |
| `markheydon/markheydon` | GitHub profile README - no issue tracking |
| `markheydon/markheydon.github.io` | Personal site - no active development |
| `markheydon/UnmessyCleanExample` | Demo/example project - not actively developed |


---

## Paused

Use this table to temporarily suspend issue scanning for a repo without changing its tier. Paused repos behave like **Not PM Tracked** for issue scanning. Their PRs are still always surfaced.

| Repository | Tier | Reason | Paused Since | Resume When |
|------------|------|--------|-------------|-------------|
| _(none)_ | - | - | - | - |

---

## Not PM Tracked

These repos are skipped when scanning for issue candidates. PRs from these repos are still always surfaced.

| Repository | Reason |
|------------|--------|
| `markheydon/Avada-Child-Theme` | WordPress child theme template - legacy boilerplate |
| `markheydon/WordPress-Plugin-Boilerplate` | Plugin boilerplate - not actively developed |
| `markheydon/php-library-template` | PHP boilerplate - not actively used |
| `markheydon/template-development` | Template repo - no feature work |
| `markheydon/wordpress-localdockerdev` | WordPress local dev tooling - no active development |
| `markheydon/wordpress-vscode-container` | WordPress VS Code container setup - no active development |

---

## How to Use This File

### For Humans

- To promote or demote a repo, move its row to the appropriate tier table and update the Notes column.
- To temporarily pause issue scanning for a repo without changing its tier, move it to the **Paused** table with a reason and a resume condition.
- To change whether a repo is fully managed, observed only, or fully excluded, update `plan/REPO_PM_PARTICIPATION.md`.
- To add a newly created repo, decide its tier based on current focus and add a row to the appropriate table.

### For Agents

1. Read this file together with `plan/REPO_PM_PARTICIPATION.md` during Step 2 of `/pm-iteration-plan` and Step 1 of `/pm-backlog-review`.
2. Fetch issues from Tier 1, 2, and 3 repos only. Skip repos in **Not PM Tracked** and **Paused** when querying issues.
3. Always fetch PRs from **all** repos regardless of tier, including Not PM Tracked and Paused.
4. Skip repos whose participation mode is `exclude`.
5. When proposing candidates for Up Next, order by tier: Tier 1 first, then Tier 2, then Tier 3.
6. Only surface Tier 3 issue candidates if capacity remains after all Tier 1 and Tier 2 candidates have been handled or deliberately skipped by the user.
7. When flagging stale repos (no activity in 14 days), apply this only to Tier 1 and Tier 2 repos - Tier 3 repos are low priority by design.
