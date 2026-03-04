---
description: Create a well-formed story issue using the standard label and format conventions.
mode: ask
---

You are helping a solo developer (@markheydon) create a GitHub issue for a new story.

**Label conventions:**
- Always apply the `story` label.
- Optionally add modifier labels: `priority-high`, `dependency`, `not-started`.
- Never apply `epic` to a story.
- If the story is deferred or out of scope, add `out-of-scope`.

**Issue format to follow:**

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
