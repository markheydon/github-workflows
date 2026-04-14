---
title: How-to - Install Copilot Assets in Your Repo
description: Install prompts, agents, skills, and instructions into another repository.
---

# How-to Guide: Install Copilot Assets in Your Repo

This guide explains how to install the Copilot agents, skills, prompts, and instructions from this repository into your own project.

## Using PowerShell Script (Recommended)

1. Copy `Install-CopilotAssets.ps1` and a config file (see `copilot-packs/` for examples) into your target repo.
2. Run:
   ```powershell
   ./Install-CopilotAssets.ps1 -TargetFolder <your-repo> -ConfigFile <config.json>
   ```
3. The script will copy the specified agents, skills, prompts, and instructions into `.github/`.

## Manual Installation

1. Copy the following folders from this repo to your target repo:
   - `.github/agents/`
   - `.github/skills/`
   - `.github/prompts/`
   - `.github/instructions/`
2. Adjust any paths or references as needed.

## Next Steps

- [Set Up the Project Board](setup-project-board.md).
- [Run the PM Workflow Prompts](../tutorials/getting-started.md).
