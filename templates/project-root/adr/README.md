# Architecture Decision Records

This directory contains the Architecture Decision Records (ADRs) for [Project Name].
Each ADR documents a significant architectural decision, the context in which it was made,
the decision itself, and the consequences.

## Format

Each ADR follows this format:

````
# ADR-XXXX: Title

**Date:** YYYY-MM-DD
**Status:** [Proposed | Accepted | Deprecated | Superseded by ADR-XXXX]

## Context
## Decision
## Rationale
## Consequences
````

## Index

| ADR | Title | Status |
|-----|-------|--------|
| [ADR-0001](0001-core-technology-stack.md) | Core Technology Stack Selection | Proposed |

## Adding a New ADR

1. Create a new file: `adr/XXXX-<kebab-case-title>.md` (increment the number).
2. Use the format above.
3. Add an entry to the index table in this file.
4. Reference the ADR from relevant documentation where appropriate.

## AI Collaborator Instructions

When an architectural decision is made during development:
1. Create a new ADR file following the format above.
2. Add it to the index table in this file.
3. If the decision supersedes an existing ADR, update the existing ADR's **Status** field to `Superseded by ADR-XXXX`.
4. Reference the new ADR from `SCOPE.md` or `CONVENTIONS.md` if it affects how the project is built.
