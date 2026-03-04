---
description: Instructions for updating the GitHub labels script to stay in sync with the label strategy defined in `plan/LABEL_STRATEGY.md`. Follow these steps whenever the strategy document changes to ensure consistency across the repository.
applyTo: "scripts/update_github_labels.bat"
---

# Instructions: Keeping the Labels Script in Sync with Label Strategy

These instructions apply when editing `scripts/update_github_labels.bat`.

## Source of truth

`plan/LABEL_STRATEGY.md` is the **single source of truth** for all label definitions. Do not invent or modify label names, colours, or descriptions in the script directly — always derive them from the strategy document.

## How to update the script

When `plan/LABEL_STRATEGY.md` changes, update the script as follows:

1. **Read `plan/LABEL_STRATEGY.md` in full** before making any changes.
2. **For each label** in the Core Work Item Labels, Modifier Labels, and GitHub Default Labels tables:
   - Use the **Label** column for the `gh label create` name argument.
   - Use the **Hex** column for the `--color` argument (strip the leading `#`).
   - Use the **Description (used in script)** column for the `--description` argument — not the Purpose column.
   - Always include `--force` so the command acts as an upsert (creates or updates).
3. **Remove any `gh label create` lines** for labels that no longer appear in the strategy document.
4. **Add new `gh label create` lines** for any labels newly added to the strategy document.
5. **Do not reorder** the existing grouping: core labels first, then modifier labels, then GitHub default labels. Add a blank line and a comment between each group.

## Description vs Purpose

The `Description (used in script)` column is intentionally concise as it is what GitHub displays in the UI next to the label. The `Purpose` column gives fuller human-readable context and is not used in the script.

## Colour handling

- Custom labels (core and modifier): use the exact hex from `LABEL_STRATEGY.md`.
- GitHub default labels: use GitHub's own default hex values as documented in `LABEL_STRATEGY.md`. Do not change these.

## Script structure

The script must:
- Start with the `@echo off` and usage/dependency checks — do not remove these.
- Include the header comment block referencing `plan/LABEL_STRATEGY.md`.
- Use `set REPO=%~1` and reference `%REPO%` in every `gh label create` call.
- Group labels with comment headers: `:: --- Core labels ---`, `:: --- Modifier labels ---`, `:: --- GitHub default labels ---`.

## Example format

```bat
gh label create "story" --color "0E8A16" --description "A user-facing feature, improvement, or technical task." --repo "%REPO%" --force
```

Note: the `--color` value does **not** include the `#` prefix.