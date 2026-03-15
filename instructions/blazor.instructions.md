---
description: 'Blazor component and application patterns'
applyTo: '**/*.razor, **/*.razor.cs, **/*.razor.css'
---

# Blazor Component and App Patterns

Use this guidance for Blazor UI and component development. Prefer repository conventions first, then these defaults.

## Core Priorities

- Keep components small, readable, and focused on one responsibility.
- Favor predictable behavior and maintainability over clever abstractions.
- Keep changes scoped to the requested outcome.
- Do not change SDK, target framework, or major architecture unless asked.

## Component Structure

- Use .razor for markup and lightweight UI logic.
- Move complex logic to code-behind (.razor.cs) or services.
- Keep rendering logic simple and avoid large inline code blocks in markup.
- Use meaningful component and parameter names with consistent conventions.

## Parameters and Data Flow

- Use [Parameter] and [EditorRequired] where appropriate.
- Use EventCallback or EventCallback<T> for child-to-parent communication.
- Prefer explicit parameters over tightly coupled cascading state unless shared context is intentional.
- Keep two-way binding clear and minimal; avoid hidden side effects.

## Lifecycle and Async

- Use OnInitializedAsync and OnParametersSetAsync when async work is required.
- Use async end-to-end for I/O operations.
- Accept and propagate CancellationToken where long-running work is possible.
- Avoid blocking calls and avoid fire-and-forget tasks in components.

## Rendering and Performance

- Minimize unnecessary re-renders by avoiding frequent state churn.
- Use ShouldRender only when there is a clear measured benefit.
- Prefer immutable view models or stable references where practical.
- Use virtualization for large lists and grids when applicable.

## Error Handling and UX Reliability

- Validate user input and provide actionable feedback.
- Use ErrorBoundary where appropriate for resilient UI sections.
- Log meaningful errors with context, without leaking sensitive data.
- Handle transient failures in API calls with clear user-facing states.

## Forms and Validation

- Use EditForm with DataAnnotations or FluentValidation based on project conventions.
- Keep validation messages clear and specific.
- Validate both client-side UX flow and server-side correctness.
- Do not rely solely on UI validation for business rules.

## Dependency Injection and Services

- Inject services via standard Blazor patterns and keep components thin.
- Keep domain/business logic out of UI components.
- Prefer interfaces where they improve testability or abstraction clarity.
- Reuse existing services before introducing new layers.

## State Management

- Start with simple local component state.
- Use cascading values or scoped state containers for shared UI state when justified.
- Introduce external state libraries only when complexity requires them.
- Keep state transitions explicit and testable.

## Styling and .razor.css

- Use component-scoped styles in .razor.css for local styling concerns.
- Prefer design system tokens and existing style primitives over ad hoc values.
- Keep selectors shallow and avoid overly specific rules.
- Maintain responsive behavior for common viewport sizes.

## Testing Guidance

- Use the test framework already present in the solution.
- Test component behavior, parameter handling, and event callbacks.
- Keep tests deterministic and independent.
- Prefer bUnit or equivalent component testing tools when aligned with repo conventions.
- Use CLI-based test execution by default unless the repository specifies otherwise.

## API Integration

- Use HttpClient and typed clients per repository conventions.
- Handle loading, success, empty, and error states explicitly in UI.
- Avoid duplicate calls and race conditions in rapid UI interactions.
- Serialize and deserialize with stable contracts and explicit null handling.

## Security

- Treat all external input as untrusted.
- Avoid exposing secrets, tokens, or sensitive data in UI or logs.
- Apply authorization checks consistently in UI and backend layers.
- Use HTTPS and secure defaults for API communication.

## Decision Priority

When guidance conflicts, use this order:

1. User request
2. Repository conventions
3. This instruction file
4. General Blazor/.NET defaults
