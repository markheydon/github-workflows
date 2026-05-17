# Export-OssSuitabilityAudit.ps1
# Read-only audit for OSS suitability across repositories.

param(
  [string]$Owner = "markheydon",
  [int]$Limit = 200,
  [string]$ParticipationFile = "plan/REPO_PM_PARTICIPATION.md",
  [string]$CsvPath = "./oss-suitability-audit.csv",
  [ValidateSet('Console', 'Markdown')][string]$OutputFormat = 'Console',
  [string]$MarkdownPath = "./oss-suitability-audit.md"
)

function Get-ParticipationOverride {
  param(
    [Parameter(Mandatory)][string]$FilePath
  )

  if (-not (Test-Path $FilePath)) {
    throw "Participation file not found: $FilePath"
  }

  $content = Get-Content -Raw -Path $FilePath
  $lines = $content -split "`r?`n"
  $inActiveOverrides = $false
  $overrides = @{}

  foreach ($line in $lines) {
    if ($line -match '^##\s+Active Overrides\s*$') {
      $inActiveOverrides = $true
      continue
    }

    if ($inActiveOverrides -and $line -match '^##\s+') {
      break
    }

    if (-not $inActiveOverrides) {
      continue
    }

    if ($line -notmatch '^\|') {
      continue
    }

    if ($line -match '^\|[-\s|]+\|$') {
      continue
    }

    if ($line -match '^\|\s*Repository\s*\|') {
      continue
    }

    $cells = $line.Trim('|').Split('|') | ForEach-Object { $_.Trim() }
    if ($cells.Count -lt 3) {
      continue
    }

    $repo = $cells[0].Trim('`')
    if ($repo -notmatch '^[^/]+/[^/]+$') {
      continue
    }

    $mode = $cells[1].Trim('`').ToLowerInvariant()
    $ossOverride = $cells[2].Trim('`').ToLowerInvariant()

    if ([string]::IsNullOrWhiteSpace($mode)) { $mode = 'full' }
    if ([string]::IsNullOrWhiteSpace($ossOverride)) { $ossOverride = 'default' }

    $overrides[$repo] = [pscustomobject]@{
      Mode = $mode
      OssOverride = $ossOverride
    }
  }

  return $overrides
}

function Invoke-GhApi {
  param(
    [Parameter(Mandatory)][string]$Path
  )

  $output = & gh api $Path 2>$null
  $code = $LASTEXITCODE

  [pscustomobject]@{
    Ok = ($code -eq 0)
    Output = $output
  }
}

function Test-AnyPath {
  param(
    [Parameter(Mandatory)][string]$RepoFull,
    [Parameter(Mandatory)][string[]]$Paths
  )

  foreach ($path in $Paths) {
    $check = Invoke-GhApi -Path "repos/$RepoFull/contents/$path"
    if ($check.Ok) {
      return $true
    }
  }

  return $false
}

function Test-IssueTemplate {
  param(
    [Parameter(Mandatory)][string]$RepoFull
  )

  $check = Invoke-GhApi -Path "repos/$RepoFull/contents/.github/ISSUE_TEMPLATE"
  if (-not $check.Ok) {
    return $false
  }

  try {
    $items = $check.Output | ConvertFrom-Json
    if ($items -isnot [System.Array]) {
      $items = @($items)
    }

    # Count as present when at least one non-config template file exists.
    $templates = @($items | Where-Object {
      $_.type -eq 'file' -and
      $_.name -ne 'config.yml' -and
      $_.name -ne '_config.yml'
    })

    return ($templates.Count -gt 0)
  }
  catch {
    return $false
  }
}

function Write-MarkdownReport {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Owner,
    [Parameter(Mandatory)][object[]]$Results,
    [Parameter(Mandatory)][string[]]$OptOutRepos,
    [Parameter(Mandatory)][string[]]$PrivateRepos,
    [Parameter(Mandatory)][string[]]$ExcludedRepos,
    [Parameter(Mandatory)][string]$CsvPath
  )

  $lines = New-Object System.Collections.Generic.List[string]
  $timestamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss K')
  $missingRepos = @($Results | Where-Object { $_.MissingCount -gt 0 })
  $cleanRepos = @($Results | Where-Object { $_.MissingCount -eq 0 })

  $lines.Add('# OSS Suitability Audit')
  $lines.Add('')
  $lines.Add("Generated: $timestamp")
  $lines.Add("")
  $lines.Add("Owner: $Owner")
  $lines.Add("OSS repos audited: $($Results.Count)")
  $lines.Add("Repos missing one or more assets: $($missingRepos.Count)")
  $lines.Add("Public non-OSS opt-outs: $($OptOutRepos.Count)")
  $lines.Add("Private repos excluded: $($PrivateRepos.Count)")
  $lines.Add("Participation excludes skipped: $($ExcludedRepos.Count)")
  $lines.Add("CSV output: $CsvPath")
  $lines.Add('')

  if ($missingRepos.Count -gt 0) {
    $lines.Add('## Missing Assets By Repo')
    $lines.Add('')
    $lines.Add('| Repository | Missing Count | Missing Assets |')
    $lines.Add('|---|---:|---|')

    foreach ($row in ($missingRepos | Sort-Object MissingCount -Descending, Repository)) {
      $safeAssets = "$($row.MissingAssets)" -replace '\|', '\|'
      $lines.Add("| $($row.Repository) | $($row.MissingCount) | $safeAssets |")
    }

    $lines.Add('')
  }
  else {
    $lines.Add('## Missing Assets By Repo')
    $lines.Add('')
    $lines.Add('No missing assets found across audited OSS repos.')
    $lines.Add('')
  }

  if ($cleanRepos.Count -gt 0) {
    $lines.Add('## Repos With Full OSS Asset Set')
    $lines.Add('')
    foreach ($repo in ($cleanRepos.Repository | Sort-Object)) {
      $lines.Add("- $repo")
    }
    $lines.Add('')
  }

  if ($OptOutRepos.Count -gt 0) {
    $lines.Add('## OSS Opt-Outs')
    $lines.Add('')
    foreach ($repo in ($OptOutRepos | Sort-Object)) {
      $lines.Add("- $repo")
    }
    $lines.Add('')
  }

  if ($PrivateRepos.Count -gt 0) {
    $lines.Add('## Private Repos Excluded')
    $lines.Add('')
    foreach ($repo in ($PrivateRepos | Sort-Object)) {
      $lines.Add("- $repo")
    }
    $lines.Add('')
  }

  if ($ExcludedRepos.Count -gt 0) {
    $lines.Add('## Participation Excludes')
    $lines.Add('')
    foreach ($repo in ($ExcludedRepos | Sort-Object)) {
      $lines.Add("- $repo")
    }
    $lines.Add('')
  }

  Set-Content -Path $Path -Value $lines -Encoding UTF8
}

$overrides = Get-ParticipationOverride -FilePath $ParticipationFile

$repoRaw = & gh repo list $Owner --limit $Limit --json name,visibility,isArchived,url 2>$null
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($repoRaw)) {
  throw "Failed to list repos for '$Owner'. Check gh auth status."
}

$repos = $repoRaw | ConvertFrom-Json

$results = @()
$optOutRepos = @()
$privateRepos = @()
$excludedRepos = @()

foreach ($repo in $repos) {
  $repoFull = "$Owner/$($repo.name)"
  $override = $overrides[$repoFull]

  $mode = 'full'
  $ossOverride = 'default'

  if ($null -ne $override) {
    $mode = $override.Mode
    $ossOverride = $override.OssOverride
  }

  if ($mode -eq 'exclude') {
    $excludedRepos += $repoFull
    continue
  }

  if ($repo.visibility -ne 'PUBLIC') {
    $privateRepos += $repoFull
    continue
  }

  if ($ossOverride -eq 'non-oss') {
    $optOutRepos += $repoFull
    continue
  }

  $missing = New-Object System.Collections.Generic.List[string]

  if (-not (Test-AnyPath -RepoFull $repoFull -Paths @('.github/CONTRIBUTING.md', 'CONTRIBUTING.md', 'docs/CONTRIBUTING.md'))) {
    $missing.Add('CONTRIBUTING.md')
  }

  if (-not (Test-AnyPath -RepoFull $repoFull -Paths @('.github/CODE_OF_CONDUCT.md', 'CODE_OF_CONDUCT.md', 'docs/CODE_OF_CONDUCT.md'))) {
    $missing.Add('CODE_OF_CONDUCT.md')
  }

  if (-not (Test-AnyPath -RepoFull $repoFull -Paths @('.github/SECURITY.md', 'SECURITY.md', 'docs/SECURITY.md'))) {
    $missing.Add('SECURITY.md')
  }

  if (-not (Test-AnyPath -RepoFull $repoFull -Paths @('.github/SUPPORT.md', 'SUPPORT.md', 'docs/SUPPORT.md'))) {
    $missing.Add('SUPPORT.md')
  }

  if (-not (Test-IssueTemplate -RepoFull $repoFull)) {
    $missing.Add('.github/ISSUE_TEMPLATE/*')
  }

  if (-not (Test-AnyPath -RepoFull $repoFull -Paths @('.github/pull_request_template.md', 'pull_request_template.md', 'docs/pull_request_template.md'))) {
    $missing.Add('pull_request_template.md')
  }

  if (-not (Test-AnyPath -RepoFull $repoFull -Paths @('.github/FUNDING.yml'))) {
    $missing.Add('.github/FUNDING.yml')
  }

  $results += [pscustomobject]@{
    Repository = $repoFull
    Url = $repo.url
    Mode = $mode
    Visibility = $repo.visibility
    OssOverride = $ossOverride
    MissingCount = $missing.Count
    MissingAssets = ($missing -join '; ')
    OssSuitable = $(if ($missing.Count -eq 0) { 'Yes' } else { 'No' })
  }
}

$results = $results | Sort-Object MissingCount -Descending, Repository

$results | Export-Csv -NoTypeInformation -Path $CsvPath

if ($OutputFormat -eq 'Markdown') {
  Write-MarkdownReport -Path $MarkdownPath -Owner $Owner -Results $results -OptOutRepos $optOutRepos -PrivateRepos $privateRepos -ExcludedRepos $excludedRepos -CsvPath $CsvPath
}

Write-Output "=== OSS Suitability Audit ==="
Write-Output "Owner: $Owner"
Write-Output "OSS repos audited: $($results.Count)"
Write-Output "Public non-OSS opt-outs: $($optOutRepos.Count)"
Write-Output "Private repos excluded: $($privateRepos.Count)"
Write-Output "Participation excludes skipped: $($excludedRepos.Count)"
Write-Output "CSV written to: $CsvPath"
if ($OutputFormat -eq 'Markdown') {
  Write-Output "Markdown written to: $MarkdownPath"
}
Write-Output ""

$results |
  Select-Object Repository, MissingCount, OssSuitable, MissingAssets |
  Format-Table -AutoSize

if ($optOutRepos.Count -gt 0) {
  Write-Output ""
  Write-Output "OSS opt-outs (public repos with OSS Override = non-oss):"
  $optOutRepos | Sort-Object | ForEach-Object { Write-Output "- $_" }
}

if ($privateRepos.Count -gt 0) {
  Write-Output ""
  Write-Output "Private repos excluded from OSS checks:"
  $privateRepos | Sort-Object | ForEach-Object { Write-Output "- $_" }
}