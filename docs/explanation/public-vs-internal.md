# Explanation: Public vs Internal Documentation

This system is designed to be transparent and reusable. All the details needed to use, adapt, or extend the workflow are included in the public documentation (this site). However, some information is only relevant to contributors or maintainers of this specific repository.

## Public Documentation (docs/)
- Focuses on how to use the workflow, prompts, and Copilot assets.
- Explains the label strategy, board automation, and setup steps.
- Omits implementation details that are only relevant to this repo's maintenance.

## Internal Documentation (README.md)
- Covers contributor-facing details, implementation notes, and maintenance guidance.
- Documents the structure and rationale for the repo's layout.
- May include details not needed by end users.

## Principle

Nothing is hidden from public docs, but irrelevant details are omitted for clarity. If you're adapting this system, start with the public docs and refer to the repo README for deeper implementation notes.
