---
title: Reference - Label Taxonomy
description: Core, modifier, and default labels used by the workflow.
---

# Reference: Label Taxonomy

This page documents the label strategy used across all repos managed by this workflow. For the single source of truth, see [plan/LABEL_STRATEGY.md](https://github.com/markheydon/github-workflows/blob/main/plan/LABEL_STRATEGY.md).

## Core Work Item Labels

| Label  | Colour | Board? | Purpose |
|--------|--------|--------|---------|
| `epic` | Indigo | No     | Groups stories; not tracked on the board |
| `story`| Green  | Yes    | Main unit of work (features, docs, refactors) |
| `bug`  | Red    | Yes    | Fixes and regressions |

## Modifier Labels

| Label              | Colour   | Purpose |
|--------------------|----------|---------|
| `priority-high`    | Amber    | Urgent work |
| `blocked`          | Light grey | Blocked by dependency |
| `not-started`      | White    | Not yet started |
| `out-of-scope`     | Grey     | Deferred work |
| `feedback-required`| Lavender | Waiting for feedback |
| `waiting-for-details` | Lavender | Needs more info |

## GitHub Default Labels

These are optional modifiers and retain their default colours.

| Label              | Colour   | Purpose |
|--------------------|----------|---------|
| `documentation`    | Blue     | Docs improvements |
| `enhancement`      | Light blue | Improvements |
| `good first issue` | Purple   | For newcomers |
| `help wanted`      | Green    | Needs help |
| `invalid`          | Yellow   | Not valid |
| `question`         | Pink     | Needs info |
| `duplicate`        | Grey     | Already exists |

---

For automation rules, see [BOARD_AUTOMATION.md](https://github.com/markheydon/github-workflows/blob/main/plan/BOARD_AUTOMATION.md).
