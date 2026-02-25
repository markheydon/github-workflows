---
description: Update README to match the current repo workflows and scripts.
agent: Mark's Workflows Tech Writer
model: GPT-4.1 (copilot)
---

You are updating documentation to accurately reflect the **current state of the repo's workflows and scripts**.

Whenever workflows or scripts are added, removed, or changed in this repository, use the Tech Writer Agent to regenerate the `README.md` so it always reflects the current state of the repo.

**Steps:**

1. List all files in `.github/workflows/` and `scripts/`.
2. Pass the filenames and (optionally) their contents to the Tech Writer Agent.
3. Overwrite the root `README.md` with the newly generated documentation.
4. Ensure the documentation is concise, accurate, and up to date.
5. (Optional) Add a "Last updated: YYYY-MM-DD" line at the end of the README.

**When to run:**  

- After any significant change to workflows or scripts  
- As part of your release or maintenance process  
- Or automate this process if possible

---

This will help keep your documentation always in sync with your automation!
