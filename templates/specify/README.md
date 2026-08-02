# Spec Kit standards

Reusable Spec-Driven Development assets for repositories that use
[GitHub Spec Kit](https://github.com/github/spec-kit).

## Constitution

| Source in this repo | Install path in a project |
|---|---|
| `memory/constitution.md` | `.specify/memory/constitution.md` |

This is the **standard constitution** for Spec Kit projects: universal core
principles plus a per-project **Domain Constraints** section.

### How to adopt

1. Ensure Spec Kit is initialised (`specify init` or equivalent) so
   `.specify/memory/` exists.
2. Copy `memory/constitution.md` over the project's
   `.specify/memory/constitution.md` (replacing Spec Kit's empty scaffold).
3. Fill placeholders: `[PROJECT_NAME]`, Domain Constraints, ratification dates.
4. Prefer `/speckit.constitution` for later amendments so version bumps and the
   Sync Impact Report stay consistent.

### What belongs where

| Content | Location |
|---|---|
| Binding product/quality principles | Constitution (this template) |
| Project-specific non-negotiables | Constitution → **Domain Constraints** |
| Stack, tools, paths, naming | `docs/tech-stack.md`, `CONVENTIONS.md` |
| Agent operating rules | `AGENTS.md` (point at the constitution; do not override it) |

### Not installed by bootstrap

`Install-ProjectBootstrap.ps1` copies `templates/project-root` only. Spec Kit
owns `.specify/`; install this constitution deliberately after Spec Kit init.
