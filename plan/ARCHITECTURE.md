# Architecture: Strategy-First Label Management

This document describes how label strategy flows through the tooling in `markheydon/github-workflows`.

---

## The Principle

**One file defines the rules. Everything else derives from it.**

[`plan/LABEL_STRATEGY.md`](LABEL_STRATEGY.md) is the single source of truth. When something changes there, the `repo-update-from-strategy` prompt propagates the change to every file that references labels.

---

## Information Flow

```
plan/LABEL_STRATEGY.md
         │
         ├──▶ .github/skills/github-issue-management/
         │         ├── references/github-labels.md     ← label definitions
         │         └── references/project-setup.md     ← board rules
         │
         ├──▶ .github/workflows/add-to-personal-project.yml
         │         └── label trigger conditions (story, bug; exclude epic)
         │
         ├──▶ scripts/update_github_labels.bat
         │         └── labels created in each repo
         │
         ├──▶ .github/copilot-instructions.md
         │         └── label summary for Copilot context
         │
         └──▶ .github/prompts/*.prompt.md
                   └── label names referenced in PM prompts
```

---

## Key Files

| File | Role |
|------|------|
| [`plan/LABEL_STRATEGY.md`](LABEL_STRATEGY.md) | **Source of truth.** All other files derive from this. |
| [`.github/skills/github-issue-management/SKILL.md`](../.github/skills/github-issue-management/SKILL.md) | Portable triage skill (agentskills.io). Generic logic, repo-specific config in `references/`. |
| [`.github/agents/repo-label-strategy-keeper.agent.md`](../.github/agents/repo-label-strategy-keeper.agent.md) | Validates consistency between strategy and all files. |
| [`.github/prompts/repo-update-from-strategy.prompt.md`](../.github/prompts/repo-update-from-strategy.prompt.md) | Interactive prompt — run after strategy changes to propagate updates. |
| [`.github/workflows/add-to-personal-project.yml`](../.github/workflows/add-to-personal-project.yml) | Reusable workflow. Called from other repos via `workflow_call`. |
| [`scripts/update_github_labels.bat`](../scripts/update_github_labels.bat) | Creates labels in a repo. Maintained from strategy doc. |

---

## How the Skill Integrates with Other Repos

The `github-issue-management` skill is designed for portability. Other repos can:

1. **Reference centrally** — use `markheydon/github-workflows` skill directly, override specifics via their own `.github/copilot-instructions.md`
2. **Copy and customise** — copy `.github/skills/github-issue-management/` into their own repo, update `references/github-labels.md` and `references/project-setup.md`

See [`.github/skills/github-issue-management/references/CUSTOMISATION_GUIDE.md`](../.github/skills/github-issue-management/references/CUSTOMISATION_GUIDE.md).

---

## Update Workflow (when strategy changes)

```
1. Edit plan/LABEL_STRATEGY.md
         │
         ▼
2. Run .github/prompts/repo-update-from-strategy.prompt.md
         │
         ├── Shows diff of proposed changes
         ├── Waits for confirmation
         └── Applies changes to all affected files
         │
         ▼
3. Invoke repo-label-strategy-keeper agent to validate
         │
         └── Reports ✅ / ⚠️ / ❌ for every file
```

---

## Extending the System

To add a new label:
1. Add it to `plan/LABEL_STRATEGY.md` under the appropriate section
2. Run `repo-update-from-strategy` to propagate
3. Run `repo-label-strategy-keeper` to validate

To add a new PM prompt:
1. Create `.github/prompts/pm-<name>.prompt.md`
2. Reference `.github/skills/github-issue-management/` for label logic
3. Add an entry to the prompts table in `README.md`

To extend the skill for a new repo:
1. Copy `.github/skills/github-issue-management/` to the target repo
2. Update `references/github-labels.md` with the repo's labels
3. Update `references/project-setup.md` with the repo's board config
4. Optionally, add label overrides to `.github/copilot-instructions.md`
