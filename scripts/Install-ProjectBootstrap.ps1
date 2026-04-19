<#
.SYNOPSIS
    Bootstraps a new project by copying root-level template files and installing Copilot assets.

.DESCRIPTION
    Copies the contents of templates/project-root into the target repository root, then
    invokes Install-CopilotAssets.ps1 to install prompts, agents, skills, and instructions
    into the target repository's .github folder.

    This script exists to keep root templates and .github assets on separate concerns:
    - templates/project-root -> copied to the target repo root
    - Copilot assets -> installed into the target repo's .github folder

    By default, existing files are preserved. Use -Force to overwrite both copied root
    templates and installed .github assets.

.PARAMETER TargetFolder
    Path to the target project folder. It must already exist.

.PARAMETER ConfigFile
    Path to the Copilot assets configuration file passed through to
    Install-CopilotAssets.ps1.

.PARAMETER CloneRoot
    Directory used by Install-CopilotAssets.ps1 for repository clones.

.PARAMETER Force
    Overwrite existing files and folders in the target repository root and .github folder.

.EXAMPLE
    .\Install-ProjectBootstrap.ps1 `
        -TargetFolder C:\Projects\my-app `
        -ConfigFile ..\copilot-packs\solo-dev-project-setup.json
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$TargetFolder,

    [Parameter(Mandatory)]
    [string]$ConfigFile,

    [string]$CloneRoot = (Join-Path ([System.Environment]::GetFolderPath('UserProfile')) '.copilot-assets-cache'),

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$resolvedTarget = Resolve-Path $TargetFolder -ErrorAction SilentlyContinue
if (-not $resolvedTarget) {
    Write-Error "Target folder '$TargetFolder' does not exist."
    exit 1
}
$TargetFolder = $resolvedTarget.Path

$resolvedConfig = Resolve-Path $ConfigFile -ErrorAction SilentlyContinue
if (-not $resolvedConfig) {
    Write-Error "Config file '$ConfigFile' does not exist."
    exit 1
}
$ConfigFile = $resolvedConfig.Path

$templateRoot = Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '../templates/project-root') -ErrorAction SilentlyContinue
if (-not $templateRoot) {
    Write-Error "Could not find templates/project-root relative to '$PSScriptRoot'."
    exit 1
}
$templateRoot = $templateRoot.Path

$copilotInstaller = Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath 'Install-CopilotAssets.ps1') -ErrorAction SilentlyContinue
if (-not $copilotInstaller) {
    Write-Error "Could not find Install-CopilotAssets.ps1 next to this script."
    exit 1
}
$copilotInstaller = $copilotInstaller.Path

Write-Information "Copying root templates from '$templateRoot' into '$TargetFolder'..." -InformationAction Continue

$copiedCount = 0
$skippedCount = 0

foreach ($item in Get-ChildItem -LiteralPath $templateRoot -Force) {
    $destination = Join-Path $TargetFolder $item.Name

    if (Test-Path $destination) {
        if (-not $Force.IsPresent) {
            Write-Information "  Skipped (exists): $($item.Name)" -InformationAction Continue
            $skippedCount++
            continue
        }

        Remove-Item -Path $destination -Recurse -Force
    }

    Copy-Item -Path $item.FullName -Destination $destination -Recurse -Force
    Write-Information "  Copied: $($item.Name)" -InformationAction Continue
    $copiedCount++
}

Write-Information "Copied $copiedCount root template item(s)." -InformationAction Continue
if ($skippedCount -gt 0) {
    Write-Information "$skippedCount root template item(s) already existed and were skipped. Use -Force to overwrite." -InformationAction Continue
}

Write-Information "Installing Copilot assets into '$TargetFolder/.github'..." -InformationAction Continue

& $copilotInstaller -TargetFolder $TargetFolder -ConfigFile $ConfigFile -CloneRoot $CloneRoot -Force:$Force.IsPresent
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}