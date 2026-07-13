<#
.SYNOPSIS
    Batch-run label updates across local repositories.

.DESCRIPTION
    Scans a local folder for child directories and treats each directory name as a GitHub repository name.
    For each repo folder found, this script calls the sibling `Update-GitHubLabels.ps1` script with
    `-Repo "<Owner>/<RepoName>"`.

    If `-Path` is omitted, the script scans the current working directory.
    Use `-Limit` to process only the first N folders, which is useful for testing or batching.

.PARAMETER Owner
    The GitHub owner for the target repositories.

.PARAMETER Path
    Optional path to the folder containing repository directories.
    If omitted, the current working directory is used.

.PARAMETER Limit
    Optional maximum number of repositories to process.
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Owner,

    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Path = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [int]$Limit
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Setup the Update-GitHubLabels.ps1 script path.
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$updateLabelsScript = Join-Path $scriptDir 'Update-GitHubLabels.ps1'

if (-not (Test-Path -Path $updateLabelsScript -PathType Leaf)) {
    throw "Could not find sibling script '$updateLabelsScript'. Ensure `Update-GitHubLabels.ps1` exists in the same folder."
}

try {
    $resolvedPath = Resolve-Path -Path $Path -ErrorAction Stop
}
catch {
    throw "The specified path '$Path' does not exist or is not accessible."
}

if (-not (Test-Path -Path $resolvedPath -PathType Container)) {
    throw "The specified path '$Path' is not a directory."
}

# Get all child directories in the specified path, sorted by name.
$repoFolders = Get-ChildItem -Path $resolvedPath -Directory | Sort-Object -Property Name

if ($Limit -ne $null) {
    if ($Limit -le 0) {
        throw "The Limit parameter must be a positive integer."
    }
    $repoFolders = $repoFolders | Select-Object -First $Limit
}

Write-Output "Scanning repository folders in '$resolvedPath'..."
Write-Output "Owner: $Owner"
Write-Output "Found ($repoFolders.Count) folder(s) to process."

# Process each repository folder.
$processedCount = 0
foreach ($folder in $repoFolders) {
    $repositoryName = "$Owner/$($folder.Name)"

    if ($PSCmdlet.ShouldProcess($repositoryName, 'Update labels')) {
        Write-Output "Processing $repositoryName..."
        & $updateLabelsScript -Repo $repositoryName

        if ($LASTEXITCODE -ne 0) {
            throw "Update-GitHubLabels.ps1 failed for repository '$repositoryName'."
        }

        $processedCount++
    }
    else {
        Write-Output "Skipped $repositoryName"
    }
}

Write-Output "Done. Processed $processedCount repository(ies)."
