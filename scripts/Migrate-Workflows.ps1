param(
  [string]$Owner = "markheydon",
  [string]$WorkflowSource = "markheydon/github-workflows",
  [string]$AuditCsv = ".\project-workflow-audit.csv",
  [string]$BranchName = "chore/migrate-project-workflow",
  [int]$MaxRepos = 20,
  [switch]$DryRun
)

# Add any repos you want to skip (e.g. the central source repo, archived forks, or special-purpose repos)
$excludeRepos = @(
  "github-workflows"         # central source repo — always exclude
)

# Customise this list to match any legacy workflow file names you want removed during migration
$legacyFiles = @(
  ".github/workflows/trigger-add-to-personal-project.yml"
)

$workflowContent = @"
name: Trigger Add to Personal Project

on:
  issues:
    types: [labeled, unlabeled]
  pull_request_target:
    types: [labeled, unlabeled]

jobs:
  add-to-personal-project:
    uses: $WorkflowSource/.github/workflows/add-to-personal-project.yml@main
    secrets:
      PERSONAL_ACCESS_TOKEN: `${{ secrets.PERSONAL_ACCESS_TOKEN }}
"@

# 1) Load audit and pre-filter per your rules
$audit = Import-Csv $AuditCsv

$candidates = $audit | Where-Object {
  $_.Status -ne "OK" -and
  $_.Status -ne "Missing workflows folder" -and
  $_.Repository -notin $excludeRepos
} | Select-Object -ExpandProperty Repository -Unique

# 2) Remove archived repos
$activeTargets = @()
foreach ($repo in $candidates) {
  $repoJson = gh repo view "$Owner/$repo" --json name,isArchived,defaultBranchRef 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Skipping $repo (could not query repo metadata)"
    continue
  }

  $meta = $repoJson | ConvertFrom-Json
  if ($meta.isArchived) {
    Write-Host "Skipping archived repo: $repo" -ForegroundColor Yellow
    continue
  }

  $activeTargets += [pscustomobject]@{
    Name = $meta.name
    DefaultBranch = $meta.defaultBranchRef.name
  }
}

$activeTargets = $activeTargets | Select-Object -First $MaxRepos

if (-not $activeTargets) {
  Write-Host "No eligible active repos to process after filtering."
  exit 0
}

$workRoot = Join-Path $PWD "_workflow-migration"
New-Item -ItemType Directory -Path $workRoot -Force | Out-Null

foreach ($target in $activeTargets) {
  $repo = $target.Name
  $defaultBranch = $target.DefaultBranch
  $repoDir = Join-Path $workRoot $repo

  Write-Host "`n=== Processing $repo ===" -ForegroundColor Cyan

  if ($DryRun) {
    Write-Host "[DRY RUN] Would create PR against $defaultBranch for $repo"
    continue
  }

  if (Test-Path $repoDir) { Remove-Item $repoDir -Recurse -Force }

  gh repo clone "$Owner/$repo" $repoDir -- --depth 1
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Clone failed: $repo"
    continue
  }

  Push-Location $repoDir
  try {
    git checkout -b $BranchName

    New-Item -ItemType Directory -Path ".github/workflows" -Force | Out-Null
    Set-Content -Path ".github/workflows/add-to-personal-project.yml" -Value $workflowContent -Encoding utf8

    foreach ($legacy in $legacyFiles) {
      if (Test-Path $legacy) {
        git rm $legacy | Out-Null
      }
    }

    git add .github/workflows/add-to-personal-project.yml

    if (-not (git status --porcelain)) {
      Write-Host "No changes required for $repo"
      Pop-Location
      continue
    }

    git commit -m "chore: migrate to central add-to-personal-project workflow"
    git push -u origin $BranchName

    gh pr create `
      --base $defaultBranch `
      --head $BranchName `
      --assignee "@me" `
      --title "chore: migrate project workflow to central reusable workflow" `
      --body "Adds/updates .github/workflows/add-to-personal-project.yml to call markheydon/github-workflows/.github/workflows/add-to-personal-project.yml@main, and removes legacy project workflow files."
  }
  catch {
    Write-Warning "Failed for ${repo}: $_"
  }
  finally {
    Pop-Location
  }
}