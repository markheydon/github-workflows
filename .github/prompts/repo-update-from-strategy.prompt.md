---
name: Update From Strategy
description: Reads plan/LABEL_STRATEGY.md and propagates any changes to all files that reference labels, issue types, or board rules — including the labels script. Run this after updating the strategy document.
agent: Repo Label Strategy Keeper
model: GPT-4.1
---

You are helping keep this repository consistent after a label strategy change.

## Step 1 — Load the strategy

Read `plan/LABEL_STRATEGY.md` in full. Extract and confirm:
- Core labels (name, colour, hex, board inclusion)
- Modifier labels (name, colour, hex)
- GitHub default labels (name, hex, description)
- Naming conventions
- Deprecated/excluded label list
- Board inclusion rules
- Dependabot rule

Summarise what you found in a compact table so I can confirm it's correct before proceeding.

---

## Step 2 — Scan for label references

Search the repository for all files referencing labels. Check these locations:

```
.github/workflows/*.yml
.github/copilot-instructions.md
.github/agents/*.agent.md
.github/prompts/*.prompt.md
.github/skills/github-issue-management/references/github-labels.md
.github/skills/github-issue-management/references/project-setup.md
scripts/update_github_labels.bat
README.md
plan/ARCHITECTURE.md
```

For each file, identify:
- Any label name that doesn't match the current strategy
- Any deprecated label still referenced
- Any board inclusion logic that doesn't match (`story` + `bug` in, `epic` out)
- Any label colour/hex mismatch

For `scripts/update_github_labels.bat` specifically, check:
- Every `gh label create` line corresponds to a label in the strategy (Core, Modifier, or GitHub Default tables) — no more, no fewer
- The `--color` value matches the strategy hex (without the `#` prefix)
- The `--description` value matches the **Description (used in script)** column exactly (not the Purpose column)
- Labels removed from the strategy have had their `gh label create` lines removed
- Labels added to the strategy have new `gh label create` lines added
- Labels are grouped with comment headers: `:: --- Core labels ---`, `:: --- Modifier labels ---`, `:: --- GitHub default labels ---`

---

## Step 3 — Show me the diff

Present a clear list of proposed changes:

```
FILE: .github/copilot-instructions.md
  CHANGE: Update label list to reflect new strategy
  FROM: [current text]
  TO:   [proposed text]
```

Do NOT make any edits yet. Wait for my confirmation.

---

## Step 4 — Apply changes

Once I confirm, apply all changes. Edit files one at a time and confirm each.

When updating `scripts/update_github_labels.bat`:
- Derive every value from `plan/LABEL_STRATEGY.md` — do not invent or adjust label names, hex codes, or descriptions
- Use the **Description (used in script)** column for `--description`, not the Purpose column
- Strip the leading `#` from hex values for `--color`
- Always include `--force` on every `gh label create` call so it acts as an upsert
- Preserve the script structure: `@echo off`, usage/dependency checks, header comment, `set REPO=%~1`, grouped labels
- Example format: `gh label create "story" --color "0E8A16" --description "A user-facing feature, improvement, or technical task." --repo "%REPO%" --force`

---

## Step 5 — Validate

After all changes are applied, invoke the `repo-label-strategy-keeper` agent (or re-read each updated file yourself) to confirm everything is now consistent. Report a final ✅ / ⚠️ / ❌ summary.
