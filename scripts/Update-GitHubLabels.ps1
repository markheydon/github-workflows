<#
.SYNOPSIS
    Upserts repository labels from plan/LABEL_STRATEGY.md.

.DESCRIPTION
    Source of truth: plan/LABEL_STRATEGY.md
    Auto-maintained by the repo-update-from-strategy prompt.
    Do not edit label names, colours, or descriptions here directly -
    update plan/LABEL_STRATEGY.md and run repo-update-from-strategy instead.
    See also: .github/instructions/label-script-update.instructions.md

.PARAMETER Repo
    The target repository in owner/repo format (e.g. markheydon/my-repo).

.EXAMPLE
    ./scripts/Update-GitHubLabels.ps1 markheydon/my-repo
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

function Set-Label {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Color,
        [Parameter(Mandatory)][string]$Description
    )

    if (-not $PSCmdlet.ShouldProcess($Repo, "Upsert label '$Name'")) {
        Write-Output "Skipped (WhatIf): $Name"
        return
    }

    & gh label create $Name --color $Color --description $Description --repo $Repo --force | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create or update label '$Name' in '$Repo'."
    }
}

Write-Output "Updating labels in $Repo..."

# --- Core labels ---
Set-Label -Name 'epic' -Color '3E4B9E' -Description 'A large body of work made up of multiple stories.'
Set-Label -Name 'story' -Color '0E8A16' -Description 'A user-facing feature, improvement, or technical task.'
Set-Label -Name 'bug' -Color 'd73a4a' -Description "Something isn't working as expected."

# --- Modifier labels ---
Set-Label -Name 'priority-high' -Color 'FBCA04' -Description 'High priority - address before other items.'
Set-Label -Name 'blocked' -Color 'cfd3d7' -Description 'Blocked by another issue or external dependency.'
Set-Label -Name 'not-started' -Color 'ffffff' -Description 'Work has not yet started.'
Set-Label -Name 'out-of-scope' -Color 'ededed' -Description 'Intentionally deferred - may be revisited in future.'
Set-Label -Name 'feedback-required' -Color 'd9d4f5' -Description 'Waiting for feedback before work can proceed.'
Set-Label -Name 'waiting-for-details' -Color 'd9d4f5' -Description 'Further details required before work can start.'

# --- GitHub default labels ---
Set-Label -Name 'documentation' -Color '0075ca' -Description 'Improvements or additions to documentation.'
Set-Label -Name 'duplicate' -Color 'cfd3d7' -Description 'This issue or pull request already exists.'
Set-Label -Name 'enhancement' -Color 'a2eeef' -Description 'An improvement to existing functionality.'
Set-Label -Name 'good first issue' -Color '7057ff' -Description 'Good for newcomers.'
Set-Label -Name 'help wanted' -Color '008672' -Description 'Extra attention is needed.'
Set-Label -Name 'invalid' -Color 'e4e669' -Description "This doesn't seem right."
Set-Label -Name 'question' -Color 'd876e3' -Description 'Further information is requested.'
Set-Label -Name 'wontfix' -Color 'ffffff' -Description 'This will not be worked on.'

Write-Output 'Done.'