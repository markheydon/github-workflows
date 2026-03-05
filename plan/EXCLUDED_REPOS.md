# Excluded Repositories

This file lists repositories that should be **excluded from all PM prompt and agent operations** (daily focus, backlog review, issue triage, iteration planning, etc.).

---

## Active Exclusions

| Repository | Reason | Excluded Since |
|------------|--------|----------------|
| `markheydon/solo-dev-board` | 100% AI-managed repository with its own workflow. Outside scope of personal project management. | 2026-03-05 |

---

## How to Use This File

### For Humans

Simply add a row to the table above when you need to exclude a repo. Include:
- **Repository**: Full name in `owner/repo` format
- **Reason**: Why it's excluded (brief, specific)
- **Excluded Since**: Date in YYYY-MM-DD format

### For Agents

When scanning repositories:
1. Read this file during initialization
2. Parse the "Active Exclusions" table
3. Skip any repo listed in the first column when:
   - Fetching open issues or PRs
   - Calculating board state
   - Running triage operations
   - Suggesting work priorities
4. Do not count excluded repos when reporting total repo counts or flagging stale repos

---

## Notes

- Exclusions apply to **all PM operations** unless explicitly overridden
- If a repo is temporarily inactive but may need PM attention later, use the project board **Ice Box** status instead of excluding it
- Archived repos are automatically excluded by GitHub and do not need to be listed here
