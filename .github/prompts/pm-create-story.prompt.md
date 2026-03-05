---
name: PM Create Story
description: Create a well-formed story issue using the standard label and format conventions.
argument-hint: Briefly describe the feature or requirement you want to capture as a story
agent: PM Backlog Manager
---

## When to use this prompt

- **When you have a new feature or task idea** to track.
- **Before running `pm-backlog-review` or `pm-iteration-plan`** if you want to add a new item.
- **Time:** 2-3 minutes per story.

## What you'll get

- A new GitHub issue labelled `story`
- Filled in with title, description (user story format), and acceptance criteria
- Optionally linked to a parent epic
- Ready to appear on the project board

## What comes next

After creating a story:
- **Issue created and labelled.** It will be added to the project board shortly.
- **Include in next iteration?** Run `/pm-iteration-plan` to assign it to a milestone.
- **Assign to epic?** Update the issue body with a reference to the parent epic (e.g., "See parent epic #12").

---

## Title Format

Issue titles describe **what specifically** needs doing, not **what type** of work it is. Labels handle type categorisation (e.g., `story`, `bug`).

**Good titles:**
- "Add dark mode toggle to settings"
- "Fix memory leak in event listener cleanup"
- "Update API documentation for authentication endpoint"
- "Refactor user service to use dependency injection"

**Avoid:**
- ❌ "[Feature] Add dark mode" — the `story` label already indicates type
- ❌ "[Bug] Memory leak" — the `bug` label already indicates type
- ❌ "[Improvement] Update docs" — the `story` label already indicates type

---

Create a new GitHub issue for a story using this format:

```markdown
## Description

As a [user/developer], I can [do something], so that [benefit].

## Acceptance Criteria and Tasks

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Related Files

- path/to/relevant/file

## Parent Epic

See parent epic #
```
