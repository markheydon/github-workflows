---
name: Update Docs
description: Update README and plan docs/ content to reflect the current state of the repo.
agent: Repo Docs Writer
model: GPT-4.1
---

Use the Repo Docs Writer agent to update documentation for this repository.

Read `plan/GOALS.md` first to keep the documentation grounded in the repo's intent.

## README.md (internal / contributor-facing)

Regenerate `README.md` to accurately reflect the **current state** of the repo.

1. List all files in `.github/workflows/`, `scripts/`, `.github/prompts/`, `.github/agents/`, `.github/skills/`, and `.github/instructions/`.
2. **Ignore any workflow files starting with `trigger-`** — these are internal thin callers only.
3. Read the contents of non-trivial files as needed to write accurate summaries.
4. Overwrite `README.md` with newly generated content. The file must start immediately with the H1 header — no leading blank lines.
5. Keep the tone concise, friendly, and welcoming to anyone who might want to adopt or adapt the tooling.
6. Add a `Last updated: YYYY-MM-DD` line at the end.

The README should cover:
- Repo purpose and context (solo dev PM automation)
- Reusable GitHub Actions workflows (how to call them from other repos)
- Scripts (purpose, usage, recommended order where relevant)
- Copilot tooling overview: prompts, agents, skills, instructions
- Setup / prerequisites (GitHub CLI, secrets, project board)
- Label strategy (brief summary, link to `plan/LABEL_STRATEGY.md`)
- License

## docs/ (future GitHub Pages — end-user-facing)

The `docs/` folder does not yet exist. When asked to plan or draft content for it:

1. Propose a Diátaxis-structured site map before writing any content:
   - **Tutorials** — walkthrough for adopting this label/PM strategy from scratch
   - **How-to Guides** — specific tasks (add a new repo, migrate labels, triage issues)
   - **Reference** — label taxonomy, script parameters, workflow inputs/outputs
   - **Explanation** — why this strategy exists, design decisions, tradeoffs
2. Await approval of the site map before drafting individual pages.
3. Each page should be self-contained and written for a developer who is **not** familiar with this repo.

---

**When to run this prompt:**
- After any significant change to workflows, scripts, or PM tooling
- As part of a release or milestone review
- When planning the initial `docs/` GitHub Pages site
