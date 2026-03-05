# Customisation Guide

This skill is maintained centrally in `markheydon/github-workflows` and is designed for **portability**. Follow this guide to adapt it for a different repository.

---

## Option A: Reference the centralised skill

Rather than copying the skill, you can reference it directly from `markheydon/github-workflows`:

```
markheydon/github-workflows/.github/skills/github-issue-management/
```

This means you always get the latest version without maintenance overhead. The trade-off is that the label names and project board config in the `references/` files reflect Mark's personal setup — your agent should use your repo's `.github/copilot-instructions.md` to override specifics.

**Recommended if:** You follow the same `epic`/`story`/`bug` taxonomy and are one of Mark's repos.

---

## Option B: Copy and customise

Copy the entire `github-issue-management/` folder into your own `.github/skills/` directory and update the files below.

### Files to update after copying

#### 1. `references/github-labels.md`

Change the label names, colours, and descriptions to match your repo's labels. Keep the same structure — the `SKILL.md` instructions reference this file for all label decisions.

**What to update:**
- Core label names (e.g., if you use `feature` instead of `story`)
- Modifier labels (add or remove as needed)
- Naming conventions section if you use a different convention
- Decision guide to match your taxonomy

#### 2. `references/project-setup.md`

Update the project board URL and field mappings.

**What to update:**
- Project board URL
- Work Item Type field values (or remove if your board has different fields)
- Required secret name (if different from `PERSONAL_ACCESS_TOKEN`)
- Automation workflow reference (if you've forked or copied the workflow)

#### 3. `SKILL.md` frontmatter

Update the `metadata` section:

```yaml
metadata:
  author: your-github-username
  version: "1.0"
```

---

## Optional: Repo-specific copilot instructions

If your repo has a `.github/copilot-instructions.md`, the skill checks for it and reads it for overrides. This is the recommended way to document any repo-specific label rules without needing to fork the skill itself.

> **Note:** This file may not exist. The skill works without it — it just means the skill uses the defaults from `references/github-labels.md`.

Example `.github/copilot-instructions.md` addition:

```markdown
## Label overrides (github-issue-management skill)
- We use `task` instead of `story` for internal tooling issues.
- The modifier `spike` is used here (treated as `story` for board purposes).
```

---

## What NOT to change

- The **SKILL.md body** — the core triage workflow and consistency check logic is generic and should work for any label set. Update the `references/` files instead of the main instructions.
- The **folder name** (`github-issue-management`) — this must match the `name` field in the SKILL.md frontmatter per the agentskills.io specification.
