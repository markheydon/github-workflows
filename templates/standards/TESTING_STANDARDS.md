# Testing Standards

Unless explicitly requested, all generated tests must follow these standards.

## Unit Testing

- Use xUnit v3 for all automated tests.
- Use NSubstitute for mocks, stubs, and test doubles.
- Use built-in xUnit Assert methods only.
- Keep test dependencies to a minimum.

Do not introduce:

- FluentAssertions.
- AwesomeAssertions.
- Shouldly.
- Moq.
- NUnit.
- MSTest.

## AppHost Testing

.NET Aspire AppHost modelling and orchestration will not be tested.

## End-to-End Testing

Where end-to-end testing is required: Use Playwright.

- Focus on key user journeys and business-critical workflows.
- Do not use Playwright as a replacement for unit tests.
- Prefer a small number of high-value end-to-end tests over large numbers of brittle UI tests.
- End-to-end tests should validate complete user workflows rather than individual UI elements.
