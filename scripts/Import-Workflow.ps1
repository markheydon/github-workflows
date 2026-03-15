param(
  [string]$Owner = "markheydon",
  [string]$WorkflowSource = "markheydon/github-workflows",
  [string]$WorkflowPath = ".github/workflows/add-to-personal-project.yml",
  [string]$BranchName = "chore/migrate-project-workflow",
  [int]$Limit = 200,
  [int]$MaxRepos = 200,
  [switch]$DryRun
)

# Repos to always skip.
$excludeRepos = @(
  "github-workflows"
)

$workflowTemplate = @'
name: Trigger Add to Personal Project

on:
  issues:
    types: [labeled, unlabeled]
  pull_request_target:
    types: [labeled, unlabeled]

jobs:
  add-to-personal-project:
    uses: {0}/.github/workflows/add-to-personal-project.yml@main
    secrets:
      PERSONAL_ACCESS_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
'@

$workflowContent = $workflowTemplate -f $WorkflowSource

function Test-RepoFileExistence {
  param(
    [Parameter(Mandatory)][string]$Owner,
    [Parameter(Mandatory)][string]$Repo,
    [Parameter(Mandatory)][string]$Path
  )

  gh api "repos/$Owner/$Repo/contents/$Path" --silent 2>$null | Out-Null
  return ($LASTEXITCODE -eq 0)
}

function Test-OpenPrExistence {
  param(
    [Parameter(Mandatory)][string]$Owner,
    [Parameter(Mandatory)][string]$Repo,
    [Parameter(Mandatory)][string]$BranchName
  )

  $headRef = "{0}:{1}" -f $Owner, $BranchName
  $prCountRaw = gh pr list --repo "$Owner/$Repo" --state open --head $headRef --json number --jq "length" 2>$null
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($prCountRaw)) {
    return $false
  }

  return ([int]$prCountRaw -gt 0)
}

$repoRaw = gh repo list $Owner --json name,isArchived,defaultBranchRef --limit $Limit 2>$null
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($repoRaw)) {
  throw "Failed to list repos for '$Owner'. Check gh auth status."
}

$repos = $repoRaw | ConvertFrom-Json
$activeRepos = $repos | Where-Object {
  -not $_.isArchived -and $_.name -notin $excludeRepos
}

if (-not $activeRepos) {
  Write-Output "No active repos found for owner '$Owner'."
  exit 0
}

$targets = [System.Collections.ArrayList]@()
$skipArchived = 0
$skipExcluded = 0
$skipExists = 0

foreach ($repo in $repos) {
  if ($repo.name -in $excludeRepos) {
    $skipExcluded++
    continue
  }

  if ($repo.isArchived) {
    $skipArchived++
    continue
  }

  if (Test-RepoFileExistence -Owner $Owner -Repo $repo.name -Path $WorkflowPath) {
    Write-Output ("Skipping {0}: {1} already exists" -f $repo.name, $WorkflowPath)
    $skipExists++
    continue
  }

  $null = $targets.Add([pscustomobject]@{
    Name = $repo.name
    DefaultBranch = $repo.defaultBranchRef.name
  })
}

$targets = $targets | Select-Object -First $MaxRepos

Write-Output "`nDiscovery summary:"
Write-Output "  Total repos scanned: $($repos.Count)"
Write-Output "  Skipped archived: $skipArchived"
Write-Output "  Skipped excluded: $skipExcluded"
Write-Output "  Skipped existing workflow: $skipExists"
Write-Output "  Targets to process: $($targets.Count)"

if (-not $targets) {
  Write-Output "No repos need importing."
  exit 0
}

$workRoot = Join-Path $PWD "_workflow-import"
New-Item -ItemType Directory -Path $workRoot -Force | Out-Null

foreach ($target in $targets) {
  $repo = $target.Name
  $defaultBranch = $target.DefaultBranch
  $repoDir = Join-Path $workRoot $repo

  Write-Output "`n=== Processing $repo ==="

  if (Test-OpenPrExistence -Owner $Owner -Repo $repo -BranchName $BranchName) {
    Write-Output ("Skipping {0}: open PR already exists for branch '{1}'" -f $repo, $BranchName)
    continue
  }

  if ($DryRun) {
    Write-Output "[DRY RUN] Would create '$WorkflowPath' and open PR against '$defaultBranch'"
    continue
  }

  if (Test-Path $repoDir) {
    Remove-Item $repoDir -Recurse -Force
  }

  gh repo clone "$Owner/$repo" $repoDir -- --depth 1
  if ($LASTEXITCODE -ne 0) {
    Write-Warning ("Clone failed: {0}" -f $repo)
    continue
  }

  Push-Location $repoDir
  try {
    git checkout -b $BranchName | Out-Null

    New-Item -ItemType Directory -Path ".github/workflows" -Force | Out-Null
    Set-Content -Path $WorkflowPath -Value $workflowContent -Encoding utf8

    git add $WorkflowPath

    if (-not (git status --porcelain)) {
      Write-Output "No changes required for $repo"
      continue
    }

    git commit -m "chore: import project workflow trigger" | Out-Null
    git push -u origin $BranchName | Out-Null

    gh pr create `
      --repo "$Owner/$repo" `
      --base $defaultBranch `
      --head $BranchName `
      --assignee "@me" `
      --title "chore: migrate project workflow to central reusable workflow" `
      --body "Adds/updates .github/workflows/add-to-personal-project.yml to call markheydon/github-workflows/.github/workflows/add-to-personal-project.yml@main, and removes legacy project workflow files." | Out-Null

    Write-Output "PR created for $repo"
  }
  catch {
    Write-Warning ("Failed for {0}: {1}" -f $repo, $_)
  }
  finally {
    Pop-Location
  }
}

Write-Output "`nImport workflow run complete."
