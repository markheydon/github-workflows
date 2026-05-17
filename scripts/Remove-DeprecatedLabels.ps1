<#
.SYNOPSIS
    Deletes deprecated labels from a GitHub repository.

.DESCRIPTION
    Deletes labels that are no longer part of plan/LABEL_STRATEGY.md.
    Run Convert-IssueLabels.ps1 first so existing issues are re-labelled before deletion.
    Safe to run multiple times.

.PARAMETER Repo
    The target repository in owner/repo format (e.g. markheydon/my-repo).

.EXAMPLE
    ./scripts/Remove-DeprecatedLabels.ps1 markheydon/my-repo
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0)]
    [string]$Repo
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "GitHub CLI (gh) could not be found. Please install it first."
    exit 1
}

function Remove-DeprecatedLabel {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$LabelName
    )

    if (-not $PSCmdlet.ShouldProcess($Repo, "Delete label '$LabelName'")) {
        Write-Output "Skipped (WhatIf): $LabelName"
        return
    }

    & gh label delete $LabelName --repo $Repo --yes 2>$null | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Output "Deleted: $LabelName"
    }
    else {
        Write-Output "Skipped (not found): $LabelName"
    }
}

Write-Output "Removing deprecated labels from $Repo..."

# --- Renamed labels (replacements already exist) ---
# dependency -> blocked
Remove-DeprecatedLabel -LabelName 'dependency'

# feedback required (space) -> feedback-required
Remove-DeprecatedLabel -LabelName 'feedback required'

# waiting details (old malformed name) -> waiting-for-details
Remove-DeprecatedLabel -LabelName 'waiting details'

# waiting for details (spaced variant) -> waiting-for-details
Remove-DeprecatedLabel -LabelName 'waiting for details'

# --- Superseded labels (replaced by 'story') ---
Remove-DeprecatedLabel -LabelName 'feature'
Remove-DeprecatedLabel -LabelName 'improvement'
Remove-DeprecatedLabel -LabelName 'spike'
Remove-DeprecatedLabel -LabelName 'technical'

Write-Output 'Done.'