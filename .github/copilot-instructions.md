# Copilot Instructions for markheydon/github-workflows

This repository centralises reusable GitHub Actions workflows, label scripts, Copilot prompt files, and agent definitions for Mark Heydon's personal GitHub project management.

## Context
- Solo developer managing multiple personal repos.
- Project board: https://github.com/users/markheydon/projects/6
- Label strategy: `epic` (never on board), `story` (on board), `bug` (on board). Epics group stories; stories and bugs are the unit of work.
- Dependabot PRs are automatically treated as `story` type on the board.

## When helping in this repo
- Maintain consistent label names: `epic`, `story`, `bug` (lowercase).
- The reusable workflow `add-to-personal-project.yml` is called from other repos via `workflow_call`.
- Trigger files (prefixed `trigger-`) are thin callers — document or suggest changes to the reusable workflow, not the trigger files.
- When suggesting new workflows or scripts, follow the existing pattern (reusable workflow + thin trigger).
- Use `actions/github-script@v8`, `actions/add-to-project@v1.0.2`, and `titoportas/update-project-fields@v0.1.0` for project automation.

## Tone & style
- Documentation should be concise, friendly, and welcoming to others who may want to adapt things.
- YAML examples must use spaces (never tabs).
