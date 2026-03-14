<#
.SYNOPSIS
    Installs Copilot agents, skills, and instructions from the Awesome Copilot repository
    into a target project's .github folder.

.DESCRIPTION
    Clones the GitHub Awesome Copilot repository (https://github.com/github/awesome-copilot)
    into a local directory, or updates it with a git pull if it already exists. Then reads
    a JSON configuration file listing which agents, skills, and instructions to copy, and
    installs them into the target project's .github folder.

    Agents and instructions are treated as single files; skills are folders and are copied
    recursively. All paths in the configuration file are relative to the root of the Awesome
    Copilot repository. The same relative paths are preserved under the target .github folder.

    Requires GitHub CLI (gh) for the clone operation. If gh is not installed, the script
    will exit with a human-readable error and instructions for how to install it.

    This is designed as a project kick-starter: maintain a set of JSON configuration files
    for different project types and run this script to bootstrap a new project with the
    Copilot agents, skills, and instructions it needs.

.PARAMETER TargetFolder
    Path to the target project folder. Assets will be copied into its .github subfolder,
    which will be created if it does not already exist.

.PARAMETER ConfigFile
    Path to a JSON file listing the agents, skills, and instructions to copy.
    See scripts/copilot-assets.example.json for the expected format.

.PARAMETER CloneRoot
    Directory in which to clone (or look for an existing clone of) the Awesome Copilot
    repository. Defaults to the current working directory.

.EXAMPLE
    .\Install-CopilotAssets.ps1 -TargetFolder ../my-project -ConfigFile ./my-config.json

.EXAMPLE
    .\Install-CopilotAssets.ps1 `
        -TargetFolder C:\Projects\my-app `
        -ConfigFile ./starter-kit.json `
        -CloneRoot C:\Tools\copilot-repos
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$TargetFolder,

    [Parameter(Mandatory)]
    [string]$ConfigFile,

    [string]$CloneRoot = $PWD
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --- Verify GitHub CLI is available ---
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error @"
GitHub CLI (gh) is not installed or could not be found on the PATH.

To install it, follow the instructions for your platform:
  https://cli.github.com/manual/installation

Quick-start options:
  Linux (Debian/Ubuntu):  sudo apt install gh
  macOS:                  brew install gh
  Windows:                winget install --id GitHub.cli

After installing, authenticate with: gh auth login
"@
    exit 1
}

# --- Resolve and validate TargetFolder ---
$resolvedTarget = Resolve-Path $TargetFolder -ErrorAction SilentlyContinue
if (-not $resolvedTarget) {
    Write-Error "Target folder '$TargetFolder' does not exist."
    exit 1
}
$TargetFolder = $resolvedTarget.Path

# --- Resolve and validate ConfigFile ---
$resolvedConfig = Resolve-Path $ConfigFile -ErrorAction SilentlyContinue
if (-not $resolvedConfig) {
    Write-Error "Config file '$ConfigFile' does not exist."
    exit 1
}
$ConfigFile = $resolvedConfig.Path

# --- Resolve CloneRoot, creating it if necessary ---
if (-not (Test-Path $CloneRoot)) {
    Write-Host "Creating clone root directory: $CloneRoot" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $CloneRoot -Force | Out-Null
}
$CloneRoot = (Resolve-Path $CloneRoot).Path

# --- Read and validate the config file ---
Write-Host "Reading config from: $ConfigFile" -ForegroundColor Cyan
$configRaw = Get-Content $ConfigFile -Raw
$config = $configRaw | ConvertFrom-Json

if ($config.PSObject.Properties['_comment']) {
    Write-Warning "The config file contains a '_comment' key. This is for documentation only — remove it before use to keep your configuration clean."
}

$agents = @(if ($config.PSObject.Properties['agents']) { $config.agents } else { @() })
$skills = @(if ($config.PSObject.Properties['skills']) { $config.skills } else { @() })
$instructions = @(if ($config.PSObject.Properties['instructions']) { $config.instructions } else { @() })

if ($agents.Count -eq 0 -and $skills.Count -eq 0 -and $instructions.Count -eq 0) {
    Write-Warning "Config file contains no agents, skills, or instructions. Nothing to do."
    exit 0
}

Write-Host "  Agents:       $($agents.Count)" -ForegroundColor DarkGray
Write-Host "  Skills:       $($skills.Count)" -ForegroundColor DarkGray
Write-Host "  Instructions: $($instructions.Count)" -ForegroundColor DarkGray

# --- Clone or update the Awesome Copilot repository ---
$awesomeCopilotDir = Join-Path $CloneRoot "awesome-copilot"

if (Test-Path (Join-Path $awesomeCopilotDir ".git")) {
    Write-Host "`nUpdating Awesome Copilot repository..." -ForegroundColor Cyan
    Push-Location $awesomeCopilotDir
    try {
        git pull
        if ($LASTEXITCODE -ne 0) {
            Write-Error "git pull failed for the Awesome Copilot repository at '$awesomeCopilotDir'."
            exit 1
        }
    }
    finally {
        Pop-Location
    }
}
else {
    Write-Host "`nCloning Awesome Copilot repository into '$awesomeCopilotDir'..." -ForegroundColor Cyan
    if (Test-Path $awesomeCopilotDir) {
        # Directory exists but is not a git repo — remove it so the clone can proceed.
        Remove-Item $awesomeCopilotDir -Recurse -Force
    }
    gh repo clone "github/awesome-copilot" $awesomeCopilotDir
    if ($LASTEXITCODE -ne 0) {
        Write-Error @"
Failed to clone 'github/awesome-copilot'.

Possible causes:
  - Not authenticated: run 'gh auth status' to check, then 'gh auth login' if needed.
  - No internet connection: verify network access and try again.
  - GitHub is unreachable: try opening https://github.com in a browser.
"@
        exit 1
    }
}

# --- Ensure the target .github folder exists ---
$dotGithubDir = Join-Path $TargetFolder ".github"
if (-not (Test-Path $dotGithubDir)) {
    Write-Host "`nCreating .github folder in target: $dotGithubDir" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $dotGithubDir -Force | Out-Null
}

# --- Helper: copy a single asset (file or folder) ---
function Copy-Asset {
    param(
        [Parameter(Mandatory)][string]$RelativePath,
        [Parameter(Mandatory)][bool]$Recurse
    )

    $source = Join-Path $awesomeCopilotDir $RelativePath
    $dest   = Join-Path $dotGithubDir $RelativePath

    if (-not (Test-Path $source)) {
        Write-Warning "Source not found, skipping: $source"
        return $false
    }

    $destParent = Split-Path $dest -Parent
    if (-not (Test-Path $destParent)) {
        New-Item -ItemType Directory -Path $destParent -Force | Out-Null
    }

    if ($Recurse) {
        Copy-Item -Path $source -Destination $dest -Recurse -Force
    }
    else {
        Copy-Item -Path $source -Destination $dest -Force
    }

    Write-Host "  Copied: $RelativePath" -ForegroundColor Green
    return $true
}

$copiedCount = 0
$skippedCount = 0

# --- Copy agents (single files) ---
if ($agents.Count -gt 0) {
    Write-Host "`nCopying agents..." -ForegroundColor Cyan
    foreach ($agent in $agents) {
        if (Copy-Asset -RelativePath $agent -Recurse $false) {
            $copiedCount++
        }
        else {
            $skippedCount++
        }
    }
}

# --- Copy skills (recursive folders) ---
if ($skills.Count -gt 0) {
    Write-Host "`nCopying skills..." -ForegroundColor Cyan
    foreach ($skill in $skills) {
        if (Copy-Asset -RelativePath $skill -Recurse $true) {
            $copiedCount++
        }
        else {
            $skippedCount++
        }
    }
}

# --- Copy instructions (single files) ---
if ($instructions.Count -gt 0) {
    Write-Host "`nCopying instructions..." -ForegroundColor Cyan
    foreach ($instruction in $instructions) {
        if (Copy-Asset -RelativePath $instruction -Recurse $false) {
            $copiedCount++
        }
        else {
            $skippedCount++
        }
    }
}

# --- Summary ---
Write-Host "`nDone. $copiedCount item(s) copied to '$dotGithubDir'." -ForegroundColor Green
if ($skippedCount -gt 0) {
    Write-Warning "$skippedCount item(s) could not be found and were skipped. Check the warnings above."
}
