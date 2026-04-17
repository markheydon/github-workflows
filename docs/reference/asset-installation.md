---
title: Reference - Copilot Asset Installation & Name Transform
---

# Reference: Copilot Asset Installation & Name Transform

This page documents the behaviour and schema for install-time asset name transforms in the Copilot asset installation workflow.

## Overview

When using `Install-CopilotAssets.ps1` to copy agents, skills, instructions, and prompts from one or more source repositories into a target repo, you can optionally apply a naming transform to the installed assets. This allows you to avoid filename collisions and clearly namespace assets without renaming the canonical source files.

## The `nameTransform` Object

Each entry in the `sources` array of your config JSON can include an optional `nameTransform` object:

```json
{
  "repo": "markheydon/github-workflows",
  "nameTransform": {
    "prefix": "myrepo",
    "suffix": "mh",
    "updateFrontmatter": true
  },
  "skills": ["dotnet-best-practices"],
  "prompts": ["new-project-setup"]
}
```

- `prefix`: (optional) Prepends this token to installed asset names (e.g. `myrepo-new-project-setup.prompt.md`).
- `suffix`: (optional) Appends this token to installed asset names (e.g. `new-project-setup-mh.prompt.md`).
- `updateFrontmatter`: (optional, boolean) If true, updates the `name` field in the frontmatter of installed prompts, agents, and instructions to match the transformed filename. For skills, updates the `name` in `SKILL.md` if the folder is renamed.

## Behaviour

- **Prompts, instructions, agents:** The transform applies to the file basename only (not the extension).
- **Skills:** The transform applies to the folder name only; files inside are not renamed. If the skill folder is renamed, the script updates the `name` field in `SKILL.md`.
- **Validation:** If a file does not match the expected pattern (e.g. `.prompt.md`), the transform is skipped for that file and a warning is logged.
- **Frontmatter:** If `updateFrontmatter` is true, the script updates the `name` field in the installed asset's frontmatter to match the new name.

## Example

Given this config:

```json
{
  "sources": [
    {
      "repo": "markheydon/github-workflows",
      "nameTransform": {
        "suffix": "mh",
        "updateFrontmatter": true
      },
      "prompts": ["new-project-setup"]
    }
  ]
}
```

The installed prompt will be named `new-project-setup-mh.prompt.md` and its frontmatter `name` field will be updated to `new-project-setup-mh`.

## See Also
- [How-to: Install Copilot Assets](../how-to/install-copilot-assets.md)
- [Sample config](../../scripts/copilot-assets.example.json)
- [Script reference](../../scripts/Install-CopilotAssets.ps1)
