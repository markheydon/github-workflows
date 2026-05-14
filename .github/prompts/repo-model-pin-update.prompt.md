---
description: This prompt is used to update model pinning across the repository according to specific strategy. It searches for all files that reference models, checks if they align with the new model strategy, and updates them accordingly while preserving the original intent and structure of each file. This came about after analysis of the upcoming pricing changes for GitHub Copilot in June 2026. My analysis found that using 'Auto' for model selection in serious coding and agentic workflows is risky due to potential cost spikes, and that pinning to more 'just good enough' models like GPT-5.3-Codex for implementation and GPT-5.4 for planning can provide better cost predictability while still delivering consistent results.
model: GPT-5.4
tools: [read, edit, search, execute]
---

Search this repository for any prompts, agents, skills, instructions, templates, or config files that either:
- contain a `model:` key, or
- describe model selection behaviour.

Update them to follow this model strategy:

- `GPT-5.4` for planning, specification, requirements shaping, task creation, and other pre-implementation reasoning.
- `GPT-5.3-Codex` for implementation, refactoring, code generation, repo-aware technical writing, and structured documentation generated from repository sources, including `README.md`.
- `GPT-5 mini` may be used only as an optional low-cost model for very lightweight, low-risk tasks such as quick summaries, simple explanations, or disposable boilerplate drafts. It must not be the default for serious repository work.
- Avoid `Auto` as the default for serious coding, repo-wide analysis, or agentic workflows unless a file has a clear and specific reason to allow automatic model selection.

Rules for the update:
- Keep edits minimal and preserve the existing structure, tone, and intent.
- Use concise, practical UK English.
- Do not invent extra workflow rules beyond this policy.
- If a file already matches this policy closely, leave it unchanged.
- Where a `model:` value exists, update it to the closest appropriate model from this strategy.
- Where model guidance is described in prose, revise the wording to reflect this policy without unnecessary rewrites.

After editing, provide:
1. a list of files changed
2. a short summary of what was updated in each file
3. any places where model choice was ambiguous and required judgement
