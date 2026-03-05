# Project Goals

This repository was created to solve a real problem: as a solo developer managing multiple personal, commercial, and open-source projects, I needed a way to keep all my GitHub issues organised and actionable—without drowning in admin work.

The core challenge is **visibility and curation across multiple repos**. It's easy to focus on active, exciting projects and let older ones go stale—older repos quietly accumulate issues that never get actioned because they're out of sight and out of mind. I needed a system that:

- Forces me to regularly review *all* my repos, not just the ones I'm currently excited about.
- Actively surfaces neglected work so nothing gets accidentally forgotten.
- Distils that into a lean, curated board of what I should actually work on in the next few days.
- Requires minimal manual triage — automation should do the heavy lifting.

At the same time, I recognise that good project management is essential for delivering quality work, even if it's not my favourite part of the job. This repo is my attempt to automate the boring bits, centralise best practices, and make it easy for future me (or anyone else) to keep things running smoothly.

> For a description of how the system is used day-to-day, see [`OPERATING_MODEL.md`](OPERATING_MODEL.md).

## High-Level Goals

- **Centralise project management automation** for all my GitHub repositories, using a single source of truth for labels and workflows.
- **Minimise manual admin** by automating issue triage, board updates, and label consistency.
- **Make the project board the single pane of glass** — a curated, intentional view of what I'm working on this week, populated by PM Mode and maintained through automation.
- **Prevent repo stagnation** by forcing cross-repo visibility in every PM Mode session — prompts must scan *all* repos and flag which ones haven't had attention recently.
- **Keep the board lean and intentional** — only bugs and stories go on the board (never epics), and only those I've actively committed to working on. No passive auto-add noise.
- **Board state must drive PM decisions** — prompts should read the board first, detect stalled or overloaded items, and help clear the decks before adding more work.
- **Automate Status transitions** — labels drive board status changes automatically: `blocked` moves items to the Blocked column; `out-of-scope` moves them to Ice Box. Removing those labels returns items to Backlog. Items that are In Progress, In Review, or Done are never touched by this automation.
- **Support both personal and commercial projects** with a flexible, extensible system.
- **Enable easy reuse and adaptation** of my workflow patterns, skills, and prompts for other repos or developers.
- **Document the strategy and architecture** so future work (by me or by AI agents) is always aligned with the original intent.
- **Embrace AI-powered tooling** (agents and prompts) to keep everything in sync, surface neglected work, and reduce cognitive load.