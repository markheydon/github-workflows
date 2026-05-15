# Repository PM Participation

This file defines how each repository participates in the PM workflow driven from this repo.

It separates two concerns that were previously conflated:

- **Whether a repo is visible to PM prompts at all**
- **Whether this repo is allowed to manage that repo's labels and triage process**

Repos not listed in the overrides table are treated as **`full`** by default.

---

## Participation Modes

| Mode | Included In | Excluded From | Typical Use |
|------|-------------|---------------|-------------|
| `full` | Backlog review, daily focus, iteration planning, stale repo checks, triage, shared label checks, board consistency checks | - | Normal repos that follow the shared PM workflow from this repo |
| `observe` | Backlog review, daily focus, iteration planning, stale repo checks, board suggestions | `/pm-issue-triage`, shared label enforcement, missing-label checks, missing-board checks based on the shared taxonomy | Repos that should stay visible in planning, but manage their own labels or internal workflow |
| `exclude` | - | All PM prompts and agent operations | Repos that should remain completely out of scope |

### Key Rule

`observe` repos are **planning-visible but triage-exempt**.

When a repo is in `observe` mode, prompts must still surface likely next work, but they must **not** try to classify its issues or PRs using the shared `epic` / `story` / `bug` taxonomy unless that repo already uses it independently.

---

## Active Overrides

| Repository | Mode | Selection Notes | Reason | Since |
|------------|------|-----------------|--------|-------|
| `markheydon/solo-dev-board` | `observe` | Surface open non-draft PRs first, then open issues that look like active next-step work. Do not rely on shared labels. | AI-managed experimental repo with its own workflow. Keep it visible in planning without taking over its triage. | 2026-03-05 |

---

## How To Use This File

### For Humans

- Add a row when a repo needs behaviour other than the default `full` mode.
- Use `observe` when you want a repo to appear in suggestions and iteration planning without centralised triage.
- Use `exclude` only when a repo should be completely ignored by PM prompts.
- Keep selection notes short and concrete so prompts can understand what to surface for `observe` repos.

### For Agents

1. Read this file before scanning repos.
2. Treat repos not listed here as `full`.
3. Skip `exclude` repos for all PM operations.
4. For `observe` repos:
   - Include them in backlog review, daily visibility, stale repo checks, and iteration planning.
   - Do **not** run triage or shared label enforcement against them.
   - Do **not** flag missing `epic` / `story` / `bug` labels as defects.
   - Use the `Selection Notes` column to decide what kind of work to surface during planning.
5. Combine this file with `plan/REPO_PRIORITIES.md`:
   - Priority decides **when** a repo's work should be considered.
   - Participation decides **how** that repo may be managed.

---

## Notes

- This file supersedes the old binary exclusion-only model.
- `plan/EXCLUDED_REPOS.md` is retained as a legacy reference, but the participation mode in this file is now the source of truth.
