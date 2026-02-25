# GitHub Workflows & Scripts
This repo centralises and standardises my personal GitHub Actions workflows and utility scripts. Everything here is tailored to how I work, but feel free to use or adapt anything if it helps you!

## Workflows

### add-to-personal-project.yml
**Name:** Auto-add Issues & PRs to my Personal Project

**Purpose:**
- Adds Issues and Pull Requests (when labeled) to my personal MHCG Workboard project ([see project](https://github.com/users/markheydon/projects/6)).
- Automatically adds Dependabot PRs as Development User Stories with Status 'Up Next'.

**Trigger:**
- `workflow_call` (for reuse from other repositories)

**Minimal usage example:**
```yaml
jobs:
  add-to-personal-project:
  uses: markheydon/github-workflows/.github/workflows/add-to-personal-project.yml@main
  secrets:
    PERSONAL_ACCESS_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
```

## Scripts

### github-labels/add_gh_labels_for_dev_repo.bat
Creates a set of development-related labels in a GitHub repository using the GitHub CLI (`gh`).

**Usage:**
```sh
add_gh_labels_for_dev_repo.bat <repository>
```

### github-labels/add_gh_labels_for_service_desk_repo.bat
Creates a set of service desk-related labels in a GitHub repository using the GitHub CLI (`gh`).

**Usage:**
```sh
add_gh_labels_for_service_desk_repo.bat <repository>
```

## Setup

- For workflows: You must provide a `PERSONAL_ACCESS_TOKEN` secret with appropriate permissions to update your GitHub Project.
- For scripts: Requires the [GitHub CLI](https://cli.github.com/) (`gh`) to be installed and authenticated.

## License

MIT License

---
Last updated: 2026-02-25

## Setup

- For workflows: Add a `PERSONAL_ACCESS_TOKEN` secret with permissions to update your GitHub Project.
- For scripts: Install and authenticate the [GitHub CLI](https://cli.github.com/) (`gh`).

## License

MIT License

---
_Last updated: 2026-02-25_
