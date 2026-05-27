# Repository PM Participation

This file defines how each repository participates in the PM workflow driven from this repo.

It separates two concerns that were previously conflated:

- **Whether a repo is visible to PM prompts at all**
- **Whether this repo is allowed to manage that repo's labels and triage process**
- **Whether a repo should be treated as OSS for OSS suitability checks**

Repos not listed in the overrides table are treated as **`full`** by default.

---

## Participation Modes

| Mode | Included In | Excluded From | Typical Use |
|------|-------------|---------------|-------------|
| `full` | Backlog review, daily focus, iteration planning, stale repo checks, triage, shared label checks, board consistency checks | - | Normal repos that follow the shared PM workflow from this repo |
| `observe` | Backlog review, daily focus, iteration planning, stale repo checks, board suggestions | `/pm-issue-triage`, shared label enforcement, missing-label checks, missing-board checks based on the shared taxonomy | Repos that should stay visible in planning, but manage their own labels or internal workflow |
| `exclude` | - | All PM prompts and agent operations | Repos that should remain completely out of scope |

## OSS Suitability Rule

OSS suitability checks are run during `/pm-backlog-review` only.

Use this evaluation order:

1. Participation mode decides whether a repo is in scope at all (`exclude` repos are skipped).
2. Repository visibility decides default OSS eligibility:
   - Public repo -> treated as OSS by default.
   - Private repo -> never treated as OSS.
3. `OSS Override` (table below) can opt a public repo out of OSS checks.

Allowed `OSS Override` values:

- `default` - use visibility-based behaviour.
- `non-oss` - explicit opt-out for an unusual public repo.

For this workflow, OSS suitability is **repo-local only**. Do not count inherited defaults from an owner `.github` repository.

### Key Rule

`observe` repos are **planning-visible but triage-exempt**.

When a repo is in `observe` mode, prompts must still surface likely next work, but they must **not** try to classify its issues or PRs using the shared `epic` / `story` / `bug` taxonomy unless that repo already uses it independently.

---

## Active Overrides

| Repository | Mode | OSS Override | Selection Notes | Reason | Since |
|------------|------|--------------|-----------------|--------|-------|
| `markheydon/me-testing-prv` | `exclude` | `default` | Temporary test repo for validating `solo-dev-board` work. Ignore for PM prompts and board review. | Test-only repo - keep fully out of PM workflow. | 2026-05-27 |
| `markheydon/solo-dev-board` | `observe` | `default` | Surface open non-draft PRs first, then open issues that look like active next-step work. Do not rely on shared labels. | AI-managed experimental repo with its own workflow. Keep it visible in planning without taking over its triage. | 2026-03-05 |

---

## How To Use This File

### For Humans

- Add a row when a repo needs behaviour other than the default `full` mode.
- Use `observe` when you want a repo to appear in suggestions and iteration planning without centralised triage.
- Use `exclude` only when a repo should be completely ignored by PM prompts.
- Leave `OSS Override` as `default` unless a public repo must be explicitly treated as non-OSS.
- Keep selection notes short and concrete so prompts can understand what to surface for `observe` repos.

### For Agents

1. Read this file before scanning repos.
2. Treat repos not listed here as `full`.
3. Skip `exclude` repos for all PM operations.
4. Determine OSS suitability for backlog review checks:
   - Private repo -> not OSS.
   - Public repo with `OSS Override = non-oss` -> not OSS.
   - Public repo otherwise -> OSS.
5. For `observe` repos:
   - Include them in backlog review, daily visibility, stale repo checks, and iteration planning.
   - Do **not** run triage or shared label enforcement against them.
   - Do **not** flag missing `epic` / `story` / `bug` labels as defects.
   - Use the `Selection Notes` column to decide what kind of work to surface during planning.
6. Run OSS suitability checks only in `/pm-backlog-review`, and only against repo-local files.
7. Combine this file with `plan/REPO_PRIORITIES.md`:
   - Priority decides **when** a repo's work should be considered.
   - Participation decides **how** that repo may be managed.

---

## Notes

- This file supersedes the old binary exclusion-only model.
- `plan/EXCLUDED_REPOS.md` is retained as a legacy reference, but the participation mode in this file is now the source of truth.
