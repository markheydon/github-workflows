---
title: How-to - Set Up the Project Board
description: Configure a GitHub Project board to work with the PM workflow and label strategy.
---

# How-to Guide: Set Up the Project Board

This guide explains how to configure your GitHub Project board to work with the Copilot PM workflow and label strategy.

## Steps

1. **Create a new Project (beta or later) in GitHub**
   - Go to https://github.com/users/{your-username}/projects.
   - Click "New Project".
   - Choose "Table" or "Board" view.
2. **Configure Status Columns**
   - Add columns for: Backlog, Up Next, In Progress, In Review, Blocked, Ice Box, Done.
3. **Confirm Status Field**
   - Ensure a "Status" field exists with the board states used by this workflow.
4. **Set Up Board Automation**
   - Use the Copilot PM prompts to automate board membership and status transitions.
   - See [BOARD_AUTOMATION.md](https://github.com/markheydon/github-workflows/blob/main/plan/BOARD_AUTOMATION.md) for rules.
5. **Add Issues and PRs**
   - Only items labelled `story` or `bug` are added to the board.
   - Epics are used for grouping but do not appear on the board.

## Next Steps

- [Run the PM Workflow Prompts](../tutorials/getting-started.md)
- [Label Taxonomy Reference](../reference/label-taxonomy.md)
