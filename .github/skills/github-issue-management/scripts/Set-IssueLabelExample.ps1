<#
.SYNOPSIS
    Example: apply one or more labels to a GitHub issue with validation.

.DESCRIPTION
    Illustrative script showing how github-issue-management triage decisions
    translate to GitHub CLI commands.

.PARAMETER Repo
    Repository in owner/repo format.

.PARAMETER Issue
    Issue number.

.PARAMETER Labels
    One or more labels to apply.

.EXAMPLE
    ./Set-IssueLabelExample.ps1 -Repo markheydon/my-repo -Issue 42 -Labels story

.EXAMPLE
    ./Set-IssueLabelExample.ps1 -Repo markheydon/my-repo -Issue 42 -Labels bug,priority-high
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Repo,

    [Parameter(Mandatory)]
    [int]$Issue,

    [Parameter(Mandatory)]
    [string[]]$Labels
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) is required."
}

$coreLabels = @('epic', 'story', 'bug')
$modifierLabels = @('priority-high', 'blocked', 'not-started', 'out-of-scope', 'feedback-required', 'waiting-for-details')
$allAllowed = @($coreLabels + $modifierLabels)

foreach ($label in $Labels) {
    if ($allAllowed -contains $label) {
        continue
    }

    Write-Warning "'$label' is not in the approved label taxonomy."
    Write-Output "Approved labels: $($allAllowed -join ', ')"
    $confirm = Read-Host "Apply anyway? (y/N)"

    if ($confirm -notin @('y', 'Y')) {
        Write-Output "Skipping label '$label'."
        continue
    }

    Write-Output "Continuing with non-standard label '$label'."
}

foreach ($label in $Labels) {
    Write-Output "Applying label '$label' to $Repo#$Issue..."
    & gh issue edit $Issue --repo $Repo --add-label $label | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to apply label '$label' to $Repo#$Issue."
    }
}

Write-Output "Done. Issue #$Issue in $Repo updated."
Write-Output "View: https://github.com/$Repo/issues/$Issue"