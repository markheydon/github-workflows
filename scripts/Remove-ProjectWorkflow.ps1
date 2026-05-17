<#
.SYNOPSIS
    Removes the legacy add-to-personal-project workflow and PERSONAL_ACCESS_TOKEN secret.

.DESCRIPTION
    For each non-archived repository under the specified owner, this script:
    1) Deletes .github/workflows/add-to-personal-project.yml if present
    2) Deletes the PERSONAL_ACCESS_TOKEN Actions secret if present

.PARAMETER Owner
    GitHub owner/org whose repositories will be scanned.

.PARAMETER WorkflowPath
    Path to the workflow file to remove inside each repository.

.PARAMETER Limit
    Maximum number of repositories to scan.

.EXAMPLE
    ./scripts/Remove-ProjectWorkflow.ps1
#>

[CmdletBinding()]
param(
    [string]$Owner = 'markheydon',
    [string]$WorkflowPath = '.github/workflows/add-to-personal-project.yml',
    [int]$Limit = 200
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "GitHub CLI (gh) could not be found. Please install it first."
    exit 1
}

Write-Output 'Fetching repo list...'
$repoList = & gh repo list $Owner --limit $Limit --json name,isArchived --jq '.[] | select(.isArchived == false) | .name'

if ($LASTEXITCODE -ne 0) {
    throw "Failed to fetch repository list for '$Owner'."
}

foreach ($repo in $repoList) {
    if ([string]::IsNullOrWhiteSpace($repo)) {
        continue
    }

    $full = "$Owner/$repo"
    $sha = & gh api "repos/$full/contents/$WorkflowPath" --jq '.sha' 2>$null

    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($sha) -or $sha -eq 'null') {
        continue
    }

    Write-Output ''
    Write-Output "--- $repo ---"

    & gh api --method DELETE "repos/$full/contents/$WorkflowPath" -f message='chore: remove add-to-personal-project workflow' -f sha=$sha 1>$null 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Output "  [OK] Deleted $WorkflowPath"
    }
    else {
        Write-Output "  [FAIL] Failed to delete $WorkflowPath"
    }

    & gh secret delete PERSONAL_ACCESS_TOKEN --repo $full --app actions 1>$null 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Output '  [OK] Deleted PERSONAL_ACCESS_TOKEN secret'
    }
    else {
        Write-Output '  [SKIP] Secret not present'
    }
}

Write-Output ''
Write-Output 'Done.'