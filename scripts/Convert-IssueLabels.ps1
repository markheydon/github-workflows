<#
.SYNOPSIS
    Converts deprecated issue labels in a GitHub repository to align with plan/LABEL_STRATEGY.md.

.DESCRIPTION
    For each deprecated label, finds all issues carrying it, adds the replacement label,
    and removes the old one. Does NOT delete the old labels themselves — run
    delete_old_labels.bat separately once you are satisfied the conversion is clean.

    Note: the 'dependency' label is only converted on OPEN issues. Closed issues with
    'dependency' are left as-is — the label had a subtly different meaning and 'blocked'
    does not apply retroactively to completed work.

    Recommended order:
        1. scripts/update_github_labels.bat <repo>          — ensure new labels exist
        2. scripts/Convert-IssueLabels.ps1 <repo> -WhatIf  — preview changes
        3. scripts/Convert-IssueLabels.ps1 <repo>          — apply changes
        4. Review results, fix any errors
        5. scripts/delete_old_labels.bat <repo>             — delete old labels

.PARAMETER Repo
    The target repository in owner/repo format (e.g. markheydon/my-repo).

.PARAMETER WhatIf
    Preview what would be changed without making any modifications.

.EXAMPLE
    .\Convert-IssueLabels.ps1 markheydon/my-repo -WhatIf
    .\Convert-IssueLabels.ps1 markheydon/my-repo
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory, Position = 0)]
    [string]$Repo
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --- Label conversion map ---
# Source: plan/LABEL_STRATEGY.md
# Format: OldLabel -> @{ New = 'new-label'; State = 'all'|'open' }
#
# 'dependency' is open-only: 'blocked' does not apply retroactively to closed issues
# (the old label had a subtly different meaning and completed work should not be re-labelled).
$migrations = [ordered]@{
    'dependency'        = @{ New = 'blocked';             State = 'open' }
    'feedback required' = @{ New = 'feedback-required';   State = 'all'  }
    'waiting for details' = @{ New = 'waiting-for-details'; State = 'all'  }
    'waiting details'   = @{ New = 'waiting-for-details'; State = 'all'  }
    'feature'           = @{ New = 'story';               State = 'all'  }
    'improvement'       = @{ New = 'story';               State = 'all'  }
    'spike'             = @{ New = 'story';               State = 'all'  }
    'technical'         = @{ New = 'story';               State = 'all'  }
}

# --- Verify gh CLI is available ---
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "GitHub CLI (gh) could not be found. Please install it first."
    exit 1
}

$totalConverted = 0
$totalSkipped   = 0
$totalErrors    = 0

# --- Quick check: does the repo have any issues at all? ---
$anyIssues = @(gh issue list --repo $Repo --state all --json number --limit 1 2>$null | ConvertFrom-Json)
if ($anyIssues.Count -eq 0) {
    Write-Host "No issues found in $Repo — nothing to convert." -ForegroundColor DarkGray
    exit 0
}

foreach ($oldLabel in $migrations.Keys) {
    $newLabel = $migrations[$oldLabel].New
    $state    = $migrations[$oldLabel].State

    Write-Host ""
    $stateNote = if ($state -eq 'open') { ' (open issues only)' } else { '' }
    Write-Host "── '$oldLabel' → '$newLabel'$stateNote" -ForegroundColor Cyan

    $json = gh issue list `
        --repo $Repo `
        --label $oldLabel `
        --state $state `
        --json number,title `
        --limit 500 2>$null

    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($json)) {
        Write-Host "   No issues found (label may not exist in this repo)." -ForegroundColor DarkGray
        continue
    }

    $issues = @($json | ConvertFrom-Json)

    if ($issues.Count -eq 0) {
        Write-Host "   No issues carrying this label." -ForegroundColor DarkGray
        continue
    }

    Write-Host "   Found $($issues.Count) issue(s)."

    foreach ($issue in $issues) {
        $num   = $issue.number
        $title = $issue.title

        if ($PSCmdlet.ShouldProcess("#$num — $title", "Add '$newLabel', remove '$oldLabel'")) {
            try {
                gh issue edit $num `
                    --repo $Repo `
                    --add-label $newLabel `
                    --remove-label $oldLabel | Out-Null

                Write-Host "   ✓ #$num — $title" -ForegroundColor Green
                $totalConverted++
            }
            catch {
                Write-Host "   ✗ #$num — $title  [$_]" -ForegroundColor Red
                $totalErrors++
            }
        }
        else {
            Write-Host "   ~ #$num — $title" -ForegroundColor Yellow
            $totalSkipped++
        }
    }
}

Write-Host ""
Write-Host "── Summary ──────────────────────────────" -ForegroundColor Cyan
if ($WhatIfPreference) {
    Write-Host "   Would convert : $totalSkipped issue(s) (dry run — no changes made)" -ForegroundColor Yellow
}
else {
    Write-Host "   Converted : $totalConverted issue(s)" -ForegroundColor Green
    if ($totalErrors -gt 0) {
        Write-Host "   Errors    : $totalErrors issue(s) — review above and re-run if needed" -ForegroundColor Red
    }
}
Write-Host ""
if ($totalErrors -eq 0 -and -not $WhatIfPreference) {
    Write-Host "All done. When satisfied, run delete_old_labels.bat to remove the old labels." -ForegroundColor Cyan
}
