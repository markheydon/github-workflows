# Audit-ProjectWorkflow.ps1
# Read-only audit: checks every repo for canonical workflow file and whether content is correct.

param(
  [string]$Owner = "markheydon",
  [string]$WorkflowRepo = "markheydon/github-workflows",
  [int]$Limit = 200
)

$expectedUses = "uses: $WorkflowRepo/.github/workflows/add-to-personal-project.yml@main"
$expectedFile = ".github/workflows/add-to-personal-project.yml"

function Invoke-GhApi {
  param(
    [Parameter(Mandatory)][string]$Path,
    [string]$Accept = "application/vnd.github+json"
  )

  $output = & gh api $Path -H "Accept: $Accept" 2>$null
  $code = $LASTEXITCODE

  [pscustomobject]@{
    Ok = ($code -eq 0)
    Output = $output
  }
}

# Get repo list
$repoRaw = & gh repo list $Owner --limit $Limit --json name,url 2>$null
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($repoRaw)) {
  throw "Failed to list repos for '$Owner'. Check gh auth status."
}
$repos = $repoRaw | ConvertFrom-Json

$results = @()

foreach ($repo in $repos) {
  $name = $repo.name
  $url = $repo.url

  # 1) Does workflows folder exist?
  $wfDir = Invoke-GhApi -Path "repos/$Owner/$name/contents/.github/workflows"
  if (-not $wfDir.Ok) {
    $results += [pscustomobject]@{
      Repository = $name
      Status = "Missing workflows folder"
      CanonicalFile = "No"
      CanonicalValid = "No"
      Notes = "Create $expectedFile"
      URL = $url
    }
    continue
  }

  $files = $wfDir.Output | ConvertFrom-Json
  if ($files -isnot [System.Array]) { $files = @($files) }

  $fileNames = @($files | ForEach-Object { $_.name })
  $hasCanonical = $fileNames -contains "add-to-personal-project.yml"

  # 2) Validate canonical file content if present
  $canonicalValid = $false
  if ($hasCanonical) {
    $canonical = Invoke-GhApi -Path "repos/$Owner/$name/contents/.github/workflows/add-to-personal-project.yml" -Accept "application/vnd.github.raw"
    if ($canonical.Ok -and $canonical.Output -match [regex]::Escape($expectedUses)) {
      $canonicalValid = $true
    }
  }

  # 3) Detect other potential old/misnamed project workflows
  $suspect = @($fileNames | Where-Object { $_ -match "personal|project|workboard|board" -and $_ -ne "add-to-personal-project.yml" })

  $status =
    if ($hasCanonical -and $canonicalValid -and $suspect.Count -eq 0) { "OK" }
    elseif ($hasCanonical -and -not $canonicalValid) { "Canonical file exists but content is wrong" }
    elseif ($hasCanonical -and $suspect.Count -gt 0) { "Canonical OK, but old/misnamed files also exist" }
    elseif (-not $hasCanonical -and $suspect.Count -gt 0) { "Has old/misnamed project workflow(s)" }
    else { "Missing canonical workflow" }

  $notes =
    if ($status -eq "OK") { "" }
    elseif ($status -eq "Canonical file exists but content is wrong") { "Update $expectedFile to call central workflow" }
    elseif ($status -eq "Canonical OK, but old/misnamed files also exist") { "Remove old file(s): $($suspect -join ', ')" }
    elseif ($status -eq "Has old/misnamed project workflow(s)") { "Replace with $expectedFile; found: $($suspect -join ', ')" }
    else { "Add $expectedFile" }

  $results += [pscustomobject]@{
    Repository = $name
    Status = $status
    CanonicalFile = $(if ($hasCanonical) { "Yes" } else { "No" })
    CanonicalValid = $(if ($canonicalValid) { "Yes" } else { "No" })
    Notes = $notes
    URL = $url
  }
}

$results |
  Sort-Object Status, Repository |
  Format-Table -AutoSize

$results | Export-Csv -NoTypeInformation -Path ".\project-workflow-audit.csv"
Write-Output "Audit written to .\project-workflow-audit.csv"