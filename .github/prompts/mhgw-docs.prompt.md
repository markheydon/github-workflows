---
description: Update README to match the current repo workflows and scripts.
agent: Mark's Workflows Tech Writer
model: GPT-4.1 (copilot)
---

You are updating documentation to accurately reflect the **current state of the repo's workflows and scripts**.

Whenever workflows or scripts are added, removed, or changed in this repository, use the Tech Writer Agent to regenerate the `README.md` so it always reflects the current state of the repo.

As this is a personal repo with my own personal workflows and scripts, the documentation should make it clear that stuff in this repo is very specific to how I work. But should also be clear that I don't mind anybody using them if they find them useful.

The documentation should be concise and to the point, but also friendly and welcoming to others who might want to use or adapt the workflows and scripts for their own use.

**Steps:**

NOTE: Any `.github/workflows/` files that start with `trigger-*` are to be ignored as these are internal only workflow files that are used to trigger any of the standardised workflow files in this repo. They should not be included in any documentation.

1. List all files in `.github/workflows/` and `scripts/`.
2. Pass the filenames and (optionally) their contents to the Tech Writer Agent.
3. Overwrite the root `README.md` with the newly generated documentation. Ensure the README starts immediately with the H1 header (no leading blank lines).
4. Ensure the documentation is concise, accurate, and up to date.
5. (Optional) Add a "Last updated: YYYY-MM-DD" line at the end of the README.

**When to run:**  

- After any significant change to workflows or scripts  
- As part of your release or maintenance process  
- Or automate this process if possible

---

When including YAML code examples, always use spaces for indentation (never tabs) to ensure valid YAML.

This will help keep your documentation always in sync with your automation!
