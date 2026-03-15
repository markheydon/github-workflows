# Audit-PersonalAccessToken.ps1
param(
  [string]$Owner = "markheydon",
  [string]$SecretName = "PERSONAL_ACCESS_TOKEN",
  [int]$Limit = 200
)

function Invoke-GhApi {
  param([string]$Path, [string]$Accept = "application/vnd.github+json")
  $out = & gh api $Path -H "Accept: $Accept" 2>$null
  $code = $LASTEXITCODE
  [pscustomobject]@{ Ok = ($code -eq 0); Output = $out }
}

$reposRaw = & gh repo list $Owner --limit $Limit --json name,isArchived,url 2>$null
if ($LASTEXITCODE -ne 0) { throw "Failed to list repos. Check gh auth." }
$repos = $reposRaw | ConvertFrom-Json

$results = @()

foreach ($r in $repos) {
  if ($r.isArchived) {
    $results += [pscustomobject]@{
      Repository = $r.name
      Archived = "Yes"
      NeedsSecret = "No"
      SecretExists = "N/A"
      WorkflowFiles = ""
      Status = "Skipped (archived)"
      URL = $r.url
    }
    continue
  }

  $wfDir = Invoke-GhApi "repos/$Owner/$($r.name)/contents/.github/workflows"
  if (-not $wfDir.Ok) {
    $results += [pscustomobject]@{
      Repository = $r.name
      Archived = "No"
      NeedsSecret = "No"
      SecretExists = "N/A"
      WorkflowFiles = ""
      Status = "No workflows folder"
      URL = $r.url
    }
    continue
  }

  $files = $wfDir.Output | ConvertFrom-Json
  if ($files -isnot [System.Array]) { $files = @($files) }
  $yamlFiles = $files | Where-Object { $_.name -match '\.(yml|yaml)$' }

  $needsSecretFiles = @()
  foreach ($f in $yamlFiles) {
    $raw = Invoke-GhApi "repos/$Owner/$($r.name)/contents/.github/workflows/$($f.name)" "application/vnd.github.raw"
    if ($raw.Ok -and $raw.Output -match '\bPERSONAL_ACCESS_TOKEN\b') {
      $needsSecretFiles += $f.name
    }
  }

  if ($needsSecretFiles.Count -eq 0) {
    $results += [pscustomobject]@{
      Repository = $r.name
      Archived = "No"
      NeedsSecret = "No"
      SecretExists = "N/A"
      WorkflowFiles = ""
      Status = "No workflow references PERSONAL_ACCESS_TOKEN"
      URL = $r.url
    }
    continue
  }

  $secretCheck = Invoke-GhApi "repos/$Owner/$($r.name)/actions/secrets/$SecretName"
  $secretExists = $secretCheck.Ok

  $results += [pscustomobject]@{
    Repository = $r.name
    Archived = "No"
    NeedsSecret = "Yes"
    SecretExists = $(if ($secretExists) { "Yes" } else { "No" })
    WorkflowFiles = ($needsSecretFiles -join ", ")
    Status = $(if ($secretExists) { "OK" } else { "Missing secret" })
    URL = $r.url
  }
}

$results | Sort-Object Status, Repository | Format-Table -AutoSize
$results | Export-Csv ".\personal-access-token-audit.csv" -NoTypeInformation

Write-Output "Wrote personal-access-token-audit.csv"
$missingSecretCount = ($results | Where-Object { $_.Status -eq "Missing secret" }).Count
Write-Output "Missing secret count: $missingSecretCount"