<!--
Sync Impact Report
==================
Version change: 0.0.0 → 1.0.0
Modified principles: none (initial ratification)
Added sections: Core Principles, Domain Constraints, Compliance Gates, Governance
Removed sections: none
Templates requiring updates:
  - .specify/templates/plan-template.md — Constitution Check must cover principles I–VIII
  - .specify/templates/spec-template.md — no change unless Domain Constraints demand it
  - .specify/templates/tasks-template.md — no change unless Domain Constraints demand it
Follow-up TODOs: Fill Domain Constraints for this project
-->

# [PROJECT_NAME] Constitution

## Core Principles

### I. Spec-Driven Traceability

Every feature MUST have a specification before implementation begins.
Specifications MUST define prioritized user stories, functional requirements, and
measurable success criteria. Plans, tasks, and pull requests MUST trace to spec
artifacts.

**Rationale**: Traceability prevents scope drift and makes every change auditable
against stated intent.

### II. Verifiable Testability (NON-NEGOTIABLE)

When testing is in scope for a feature, automated tests MUST exist and be
confirmed failing before implementation begins. Domain-critical and boundary
behavior (APIs, parsers, schemas, external integrations) MUST have automated
coverage. Tests MUST assert business outcomes, not implementation details.
Interfaces MUST NOT be created solely to enable mocking.

**Rationale**: Tests written after implementation confirm existing behavior, not
desired behavior. Failing-first tests prove the test is meaningful.

### III. Separation of Concerns

Each component MUST have one clear responsibility. Presentation, domain logic,
persistence, and infrastructure MUST NOT be entangled without documented
justification in the plan's Complexity Tracking table. Dependencies MUST flow
inward; business rules MUST NOT depend on transport or UI details.

**Rationale**: Clear boundaries reduce coupling, simplify testing, and keep
changes localized.

### IV. Explicit Error Handling

Every specified failure mode MUST have an explicit handling path. Errors MUST
NOT be swallowed, ignored, or replaced with silent defaults. Failures at system
boundaries MUST be observable to callers, operators, or users as appropriate.
User-facing failures MUST be actionable and MUST NOT expose secrets or raw
stack traces.

**Rationale**: Silent or undefined failures erode reliability and make incidents
harder to diagnose.

### V. Security by Design

Secrets MUST NEVER be committed, logged, or returned in responses. User input
MUST be validated at boundaries. Features that access sensitive data,
authenticate users, or expose external interfaces MUST identify threats and
access controls in the specification or plan before implementation. Dependencies
with known high/critical vulnerabilities MUST be remediated or explicitly waived.

**Rationale**: Security retrofitted after implementation consistently misses
threats that are cheaper to address during design.

### VI. Justified Complexity

Implementations MUST begin with the simplest design that meets the current
specification. Abstractions MUST NOT be introduced for anticipated future needs.
Any deviation MUST be documented in the plan's Complexity Tracking table with a
rejected simpler alternative and explicit justification.

**Rationale**: Unjustified complexity compounds maintenance cost and obscures
intent.

### VII. Documentation Contract

Specifications, contracts, and quickstart guides MUST match implemented behavior.
Public interfaces and non-obvious behavior MUST be documented. When
implementation diverges from docs, update the docs or revert the code—never
leave them out of sync. Documentation updates ship in the same change as
observable behavior changes.

**Rationale**: Stale documentation is worse than none; it erodes trust and
blocks onboarding.

### VIII. Consistent Operator/User Experience

Where the project has a user-facing surface, terminology MUST be consistent
across UI, API, logs, and docs. Error, empty, and loading states MUST be
handled consistently. Destructive or irreversible actions MUST require explicit
confirmation (and preview/dry-run when the domain involves external side
effects). New UI MUST reuse established patterns rather than one-off designs.

**Rationale**: Inconsistent UX recreates the confusion the product is meant to
remove. (For libraries/CLIs with no UI, mark N/A in Compliance Gates with
rationale.)

## Domain Constraints

> Fill per project. This is the only section that should normally differ.
> Keep rules binding and testable. Do not put stack, paths, or tool commands here.

- **Primary users**: [WHO]
- **In scope (current major)**: [WHAT]
- **Out of scope**: [WHAT NOT]
- **Domain-critical behavior**: [e.g. cooking calculations / billing writes / lottery suggestions]
- **Human control / safety rules**: [e.g. no unattended Stripe writes; food-safety minimums; entertainment-only disclaimer]
- **Determinism / explainability**: [e.g. same inputs → same outputs; every action must cite the rule that fired]
- **Other non-negotiables**: [e.g. self-hosted path required; no implied vendor endorsement]

## Compliance Gates

Every `plan.md` MUST include a Constitution Check with a yes/no result for each
principle before Phase 0 research and again after Phase 1 design. Plans that
fail any principle without Complexity Tracking justification MUST NOT proceed.

Every pull request MUST be reviewable against these gates:

| Gate | Question |
|------|----------|
| Traceability | Does every change trace to a spec requirement or task? |
| Testability | When tests are in scope, do they exist, fail first, and cover domain-critical + boundary behavior? |
| Separation | Does each module have a single, clear responsibility with inward dependencies? |
| Error handling | Is every specified failure mode handled explicitly and safely? |
| Security | Are secrets, input validation, and access controls addressed for sensitive or exposed features? |
| Complexity | Is added complexity justified with a rejected simpler alternative? |
| Documentation | Do specs, contracts, and quickstart match the implementation? |
| UX | If user-facing: are terminology, states, and destructive-action patterns consistent? |
| Domain | Does the change satisfy Domain Constraints? |

Technology choices, libraries, frameworks, naming conventions, directory maps,
and agent operating rules belong in `README.md`, `docs/tech-stack.md`,
`AGENTS.md`, or decision logs — **not** in this constitution.

## Governance

This constitution is the highest-order project governance document for Spec Kit
workflows. It supersedes ad-hoc practice when they conflict. Agent context files
(`AGENTS.md`, Copilot instructions, etc.) MAY point here; they MUST NOT override
these principles.

- Amendments MUST update this file via `/speckit.constitution` (or equivalent),
  bump the version, set `LAST_AMENDED_DATE`, and include a Sync Impact Report.
- Versioning: MAJOR = principle removal/redefinition; MINOR = new principle or
  materially expanded guidance; PATCH = clarifications only.
- Template impact from amendments MUST be recorded in the Sync Impact Report and
  applied in the same change when feasible.
- Complexity without documented justification is grounds for rejection.

**Version**: 1.0.0 | **Ratified**: [YYYY-MM-DD] | **Last Amended**: [YYYY-MM-DD]
