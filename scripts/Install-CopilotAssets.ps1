<#
.SYNOPSIS
    Installs Copilot agents, skills, and instructions from the Awesome Copilot repository
    into a target project's .github folder.

.DESCRIPTION
    Clones one or more source repositories into a local directory, or updates each with
    a git pull if it already exists. Then reads a JSON configuration file listing which
    agents, skills, and instructions to copy from each source repository, and installs
    them into the target project's .github folder.

    Agents, instructions, and prompts are treated as single files; skills are folders and are
    copied recursively. The same relative paths are preserved under the target .github folder.

    Requires GitHub CLI (gh) for the clone operation. If gh is not installed, the script
    will exit with a human-readable error and instructions for how to install it.

    This is designed as a project kick-starter: maintain a set of JSON configuration files
    for different project types and run this script to bootstrap a new project with the
    Copilot agents, skills, and instructions it needs.

.PARAMETER TargetFolder
    Path to the target project folder. Assets will be copied into its .github subfolder,
    which will be created if it does not already exist.

.PARAMETER ConfigFile
    Path to a JSON file listing one or more source repositories and their assets.
    Each source uses a repo slug in owner/repo format and can contain agents,
        skills, instructions, and prompts arrays.

        Each source can also include an optional `nameTransform` object:
        - `prefix`: optional token to prepend to installed asset names
        - `suffix`: optional token to append to installed asset names
        - `updateFrontmatter`: when true, update frontmatter `name` fields for
            renamed prompts, agents, and other single-file assets when present

    Agent and instruction entries are short names (for example "example-agent"),
    while skills are folder names (for example "example-skill").
    The script resolves these to standard paths automatically.
    See scripts/copilot-assets.example.json for the expected format.

.PARAMETER CloneRoot
    Directory in which to clone (or look for existing clones of) all configured source
    repositories. Defaults to ~/.copilot-assets-cache (per-user).
    Use -CloneRoot to override this location.

.PARAMETER Force
    Overwrite existing files and folders in the target .github folder.
    By default, existing assets are skipped.

.EXAMPLE
    .\Install-CopilotAssets.ps1 -TargetFolder ../my-project -ConfigFile ./my-config.json

.EXAMPLE
    .\Install-CopilotAssets.ps1 `
        -TargetFolder C:\Projects\my-app `
        -ConfigFile ./starter-kit.json `
        -CloneRoot C:\Tools\copilot-repos

.EXAMPLE
    .\Install-CopilotAssets.ps1 `
        -TargetFolder C:\Projects\my-app `
        -ConfigFile ./starter-kit.json `
        -Force
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
    Write-Information "Creating clone root directory: $CloneRoot" -InformationAction Continue
    New-Item -ItemType Directory -Path $CloneRoot -Force | Out-Null
}
$CloneRoot = (Resolve-Path $CloneRoot).Path

# --- Read and validate the config file ---
Write-Information "Reading config from: $ConfigFile" -InformationAction Continue
$configRaw = Get-Content $ConfigFile -Raw
try {
        $config = $configRaw | ConvertFrom-Json -ErrorAction Stop
}
catch {
        Write-Error @"
Config file '$ConfigFile' is not valid JSON.

Details: $($_.Exception.Message)

Hint: each entry in the 'sources' array must be an object wrapped in { }.
Example:
    "sources": [
        {
            "name": "Awesome Copilot",
            "repo": "github/awesome-copilot",
            "agents": ["CSharpExpert"],
            "skills": ["csharp-async", "csharp-docs"],
            "prompts": ["new-project-setup"]
        }
    ]
"@
        exit 1
}

if ($config.PSObject.Properties['_comment']) {
    Write-Warning "The config file contains a '_comment' key. This is for documentation only - remove it before use to keep your configuration clean."
}

$configName = if ($config.PSObject.Properties['name']) { [string]$config.name } else { '<not provided>' }
$configDescription = if ($config.PSObject.Properties['description']) { [string]$config.description } else { '<not provided>' }
$configVersion = if ($config.PSObject.Properties['version']) { [string]$config.version } else { '<not provided>' }

Write-Information "Configuration metadata:" -InformationAction Continue
Write-Information "  Name:        $configName" -InformationAction Continue
Write-Information "  Description: $configDescription" -InformationAction Continue
Write-Information "  Version:     $configVersion" -InformationAction Continue
Write-Information "  Overwrite:   $($Force.IsPresent)" -InformationAction Continue

# --- Read multi-source config and keep legacy compatibility ---
function Convert-ToRepoSlug {
    param(
        [Parameter(Mandatory)][string]$Repository
    )

    $candidate = $Repository.Trim()

    if ($candidate -match '^https?://github\.com/([^/]+)/([^/]+?)(?:\.git)?/?$') {
        return "$($Matches[1])/$($Matches[2])"
    }

    if ($candidate -match '^github\.com/([^/]+)/([^/]+?)(?:\.git)?/?$') {
        return "$($Matches[1])/$($Matches[2])"
    }

    return $candidate
}

function Get-NameTransform {
    param(
        [Parameter(Mandatory)]$SourceConfig
    )

    $prefix = $null
    $suffix = $null
    $updateFrontmatter = $false

    if ($SourceConfig.PSObject.Properties['nameTransform'] -and $SourceConfig.nameTransform) {
        $transform = $SourceConfig.nameTransform

        if ($transform.PSObject.Properties['prefix']) {
            $prefix = [string]$transform.prefix
        }

        if ($transform.PSObject.Properties['suffix']) {
            $suffix = [string]$transform.suffix
        }

        if ($transform.PSObject.Properties['updateFrontmatter']) {
            $updateFrontmatter = [bool]$transform.updateFrontmatter
        }
    }

    foreach ($tokenName in @('prefix', 'suffix')) {
        $value = if ($tokenName -eq 'prefix') { $prefix } else { $suffix }

        if ([string]::IsNullOrWhiteSpace($value)) {
            if ($tokenName -eq 'prefix') { $prefix = $null } else { $suffix = $null }
            continue
        }

        $normalised = $value.Trim().Trim('-')
        if ([string]::IsNullOrWhiteSpace($normalised)) {
            Write-Error "nameTransform.$tokenName must contain at least one non-separator character."
            exit 1
        }

        if ($normalised -match '[\\/\s]') {
            Write-Error "nameTransform.$tokenName cannot contain slashes or whitespace: '$value'"
            exit 1
        }

        if ($tokenName -eq 'prefix') { $prefix = $normalised } else { $suffix = $normalised }
    }

    return [PSCustomObject]@{
        prefix = $prefix
        suffix = $suffix
        updateFrontmatter = $updateFrontmatter
    }
}

function Get-TransformedName {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)]$NameTransform
    )

    $parts = @()
    if ($NameTransform.prefix) {
        $parts += $NameTransform.prefix
    }

    $parts += $Name

    if ($NameTransform.suffix) {
        $parts += $NameTransform.suffix
    }

    return ($parts -join '-')
}

function Get-InstalledRelativePath {
    param(
        [Parameter(Mandatory)][ValidateSet('agents', 'skills', 'instructions', 'prompts')][string]$AssetType,
        [Parameter(Mandatory)][string]$ResolvedPath,
        [Parameter(Mandatory)]$NameTransform
    )

    if (-not $NameTransform.prefix -and -not $NameTransform.suffix) {
        return $ResolvedPath
    }

    $segments = $ResolvedPath -split '[\\/]+'
    $parentSegments = if ($segments.Length -gt 1) { $segments[0..($segments.Length - 2)] } else { @() }
    $leaf = $segments[-1]

    if ($AssetType -eq 'skills') {
        $transformedLeaf = Get-TransformedName -Name $leaf -NameTransform $NameTransform
        return (@($parentSegments) + $transformedLeaf) -join '/'
    }

    $pattern = switch ($AssetType) {
        'agents' { '\.agent\.md$' }
        'instructions' { '\.instructions\.md$' }
        'prompts' { '\.prompt\.md$' }
    }

    $baseName = [regex]::Replace($leaf, $pattern, '')
    $extension = $leaf.Substring($baseName.Length)
    $transformedLeaf = (Get-TransformedName -Name $baseName -NameTransform $NameTransform) + $extension

    return (@($parentSegments) + $transformedLeaf) -join '/'
}

function Update-FrontmatterNameField {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string]$NewName,
        [switch]$Required
    )

    if (-not (Test-Path $FilePath)) {
        if ($Required) {
            Write-Error "Expected frontmatter file was not found: $FilePath"
            exit 1
        }

        return $false
    }

    $content = Get-Content -Path $FilePath -Raw
    $match = [regex]::Match($content, '^(---\r?\n)(?<frontmatter>.*?)(\r?\n---\r?\n?)', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    if (-not $match.Success) {
        if ($Required) {
            Write-Error "Required frontmatter block was not found in '$FilePath'."
            exit 1
        }

        return $false
    }

    $frontmatter = $match.Groups['frontmatter'].Value
    $nameMatch = [regex]::Match($frontmatter, '^(?<indent>\s*)name\s*:\s*(?<value>.+?)\s*$', [System.Text.RegularExpressions.RegexOptions]::Multiline)

    if (-not $nameMatch.Success) {
        if ($Required) {
            Write-Error "Required frontmatter name field was not found in '$FilePath'."
            exit 1
        }

        return $false
    }

    $updatedFrontmatter = $frontmatter.Substring(0, $nameMatch.Index) + $nameMatch.Groups['indent'].Value + "name: $NewName" + $frontmatter.Substring($nameMatch.Index + $nameMatch.Length)

    $updatedContent = $content.Substring(0, $match.Groups['frontmatter'].Index) + $updatedFrontmatter + $content.Substring($match.Groups['frontmatter'].Index + $match.Groups['frontmatter'].Length)

    if ($PSCmdlet.ShouldProcess($FilePath, "Update frontmatter name to '$NewName'")) {
        Set-Content -Path $FilePath -Value $updatedContent -NoNewline
        return $true
    }

    return $false
}

$defaultSourceRepo = 'github/awesome-copilot'
if ($config.PSObject.Properties['repository'] -and $config.repository) {
    $defaultSourceRepo = Convert-ToRepoSlug -Repository ([string]$config.repository)
}

$legacyAgents = @(if ($config.PSObject.Properties['agents']) { $config.agents } else { @() })
$legacySkills = @(if ($config.PSObject.Properties['skills']) { $config.skills } else { @() })
$legacyInstructions = @(if ($config.PSObject.Properties['instructions']) { $config.instructions } else { @() })
$legacyPrompts = @(if ($config.PSObject.Properties['prompts']) { $config.prompts } else { @() })
$hasLegacyAssets = $legacyAgents.Count -gt 0 -or $legacySkills.Count -gt 0 -or $legacyInstructions.Count -gt 0 -or $legacyPrompts.Count -gt 0

$configuredSources = @(if ($config.PSObject.Properties['sources']) { $config.sources } else { @() })
$sourceConfigs = @($configuredSources)

if ($hasLegacyAssets) {
    Write-Information "Legacy top-level asset keys found; treating them as source repo '$defaultSourceRepo'." -InformationAction Continue
    $sourceConfigs += [PSCustomObject]@{
        repo = $defaultSourceRepo
        name = $defaultSourceRepo
        agents = $legacyAgents
        skills = $legacySkills
        instructions = $legacyInstructions
        prompts = $legacyPrompts
        nameTransform = $null
    }
}

$sources = @()
foreach ($sourceConfig in $sourceConfigs) {
    if (-not $sourceConfig.PSObject -or -not $sourceConfig.PSObject.Properties) {
        Write-Warning "A source entry is not an object and will be skipped. Check your 'sources' array format."
        continue
    }

    $repo = if ($sourceConfig.PSObject.Properties['repo'] -and $sourceConfig.repo) { [string]$sourceConfig.repo } else { $defaultSourceRepo }
    $repo = Convert-ToRepoSlug -Repository $repo
    $name = if ($sourceConfig.PSObject.Properties['name'] -and $sourceConfig.name) { [string]$sourceConfig.name } else { $repo }
    $agents = @(if ($sourceConfig.PSObject.Properties['agents']) { $sourceConfig.agents } else { @() })
    $skills = @(if ($sourceConfig.PSObject.Properties['skills']) { $sourceConfig.skills } else { @() })
    $instructions = @(if ($sourceConfig.PSObject.Properties['instructions']) { $sourceConfig.instructions } else { @() })
    $prompts = @(if ($sourceConfig.PSObject.Properties['prompts']) { $sourceConfig.prompts } else { @() })
    $nameTransform = Get-NameTransform -SourceConfig $sourceConfig

    if ($agents.Count -eq 0 -and $skills.Count -eq 0 -and $instructions.Count -eq 0 -and $prompts.Count -eq 0) {
        Write-Warning "Source '$repo' has no agents, skills, instructions, or prompts and will be skipped."
        continue
    }

    $sources += [PSCustomObject]@{
        repo = $repo
        name = $name
        agents = $agents
        skills = $skills
        instructions = $instructions
        prompts = $prompts
        nameTransform = $nameTransform
    }
}

if ($sources.Count -eq 0) {
    Write-Warning "Config file contains no source assets to copy. Nothing to do."
    exit 0
}

$totalAgents = ($sources | ForEach-Object { $_.agents.Count } | Measure-Object -Sum).Sum
$totalSkills = ($sources | ForEach-Object { $_.skills.Count } | Measure-Object -Sum).Sum
$totalInstructions = ($sources | ForEach-Object { $_.instructions.Count } | Measure-Object -Sum).Sum
$totalPrompts = ($sources | ForEach-Object { $_.prompts.Count } | Measure-Object -Sum).Sum

Write-Information "  Sources:      $($sources.Count)" -InformationAction Continue
Write-Information "  Agents:       $totalAgents" -InformationAction Continue
Write-Information "  Skills:       $totalSkills" -InformationAction Continue
Write-Information "  Instructions: $totalInstructions" -InformationAction Continue
Write-Information "  Prompts:      $totalPrompts" -InformationAction Continue

# --- Resolve shorthand config entries to Awesome Copilot relative paths ---
function Resolve-AssetRelativePath {
    param(
        [Parameter(Mandatory)][ValidateSet('agents', 'skills', 'instructions', 'prompts')][string]$AssetType,
        [Parameter(Mandatory)][string]$AssetName
    )

    if ($AssetName -match '[\\/]') {
        return $AssetName
    }

    switch ($AssetType) {
        'agents' {
            return "agents/$AssetName.agent.md"
        }
        'skills' {
            return "skills/$AssetName"
        }
        'instructions' {
            return "instructions/$AssetName.instructions.md"
        }
        'prompts' {
            return "prompts/$AssetName.prompt.md"
        }
    }
}

# --- Clone or update a source repository ---
function Get-RepoFolderName {
    param(
        [Parameter(Mandatory)][string]$Repo
    )

    # Keep clone folder names deterministic and filesystem-safe.
    return ($Repo -replace '[^A-Za-z0-9._-]', '-')
}

function Get-RepoCheckout {
    param(
        [Parameter(Mandatory)][string]$Repo
    )

    $repoDir = Join-Path $CloneRoot (Get-RepoFolderName -Repo $Repo)

    if (Test-Path (Join-Path $repoDir '.git')) {
        Write-Information "`nUpdating repository '$Repo'..." -InformationAction Continue
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
            Write-Error @"
Git is required to update the repository '$Repo', but 'git' was not found on PATH.

Please install Git from https://git-scm.com/downloads and ensure 'git' is available on your PATH, then re-run this script.
"@
            exit 1
        }
        Push-Location $repoDir
        try {
            $null = git pull
            if ($LASTEXITCODE -ne 0) {
                Write-Error "git pull failed for repository '$Repo' at '$repoDir'."
                exit 1
            }
        }
        finally {
            Pop-Location
        }
    }
    else {
        Write-Information "`nCloning repository '$Repo' into '$repoDir'..." -InformationAction Continue
        if (Test-Path $repoDir) {
            Write-Error @"
Cannot clone '$Repo' into '$repoDir' because the directory already exists and is not a git repository.

To avoid accidental data loss, this script will not delete existing non-repository folders.

Either:
  - Move or remove the existing '$repoDir' directory manually, then re-run this script; or
  - Choose a different clone root so that '$repoDir' can be created safely.
"@
            exit 1
        }

        gh repo clone $Repo $repoDir
        if ($LASTEXITCODE -ne 0) {
            Write-Error @"
Failed to clone '$Repo'.

Possible causes:
  - Not authenticated: run 'gh auth status' to check, then 'gh auth login' if needed.
  - No internet connection: verify network access and try again.
  - GitHub is unreachable: try opening https://github.com in a browser.
"@
            exit 1
        }
    }

    return $repoDir
}

# --- Ensure the target .github folder exists ---
$dotGithubDir = Join-Path $TargetFolder ".github"
if (-not (Test-Path $dotGithubDir)) {
    Write-Information "`nCreating .github folder in target: $dotGithubDir" -InformationAction Continue
    New-Item -ItemType Directory -Path $dotGithubDir -Force | Out-Null
}
$dotGithubDirFull = [System.IO.Path]::GetFullPath($dotGithubDir)

# --- Helper: copy a single asset (file or folder) ---
function Copy-Asset {
    param(
        [Parameter(Mandatory)][string]$SourceRoot,
        [Parameter(Mandatory)][string]$SourceRelativePath,
        [Parameter(Mandatory)][string]$DestinationRelativePath,
        [Parameter(Mandatory)][bool]$Recurse,
        [string]$FrontmatterName,
        [switch]$UpdateFrontmatter,
        [switch]$RequireFrontmatterName
    )

    # Validate that the relative path cannot escape the expected directories
    if ([System.IO.Path]::IsPathRooted($SourceRelativePath)) {
        Write-Warning "Skipping asset with rooted source path (not allowed): $SourceRelativePath"
        return 'invalid'
    }

    if ([System.IO.Path]::IsPathRooted($DestinationRelativePath)) {
        Write-Warning "Skipping asset with rooted destination path (not allowed): $DestinationRelativePath"
        return 'invalid'
    }

    $sourceSegments = $SourceRelativePath -split '[\\/]+'
    if ($sourceSegments -contains '..') {
        Write-Warning "Skipping asset with traversal segments (not allowed): $SourceRelativePath"
        return 'invalid'
    }

    $destinationSegments = $DestinationRelativePath -split '[\\/]+'
    if ($destinationSegments -contains '..') {
        Write-Warning "Skipping asset with traversal segments (not allowed): $DestinationRelativePath"
        return 'invalid'
    }

    $source = Join-Path $SourceRoot $SourceRelativePath
    $dest   = Join-Path $dotGithubDirFull $DestinationRelativePath
    $dest   = [System.IO.Path]::GetFullPath($dest)

    # Ensure the destination path stays under the .github directory
    $basePath = [System.IO.Path]::GetFullPath($dotGithubDirFull)
    $separator = [System.IO.Path]::DirectorySeparatorChar
    if (-not ($dest.StartsWith($basePath + $separator) -or $dest -eq $basePath)) {
        Write-Warning "Destination path escapes .github directory, skipping: $DestinationRelativePath"
        return 'invalid'
    }

    if (-not (Test-Path $source)) {
        Write-Warning "Source not found, skipping: $source"
        return 'missing'
    }

    $destParent = Split-Path $dest -Parent
    if (-not (Test-Path $destParent)) {
        New-Item -ItemType Directory -Path $destParent -Force | Out-Null
    }

    if (Test-Path $dest) {
        if (-not $Force.IsPresent) {
            Write-Information "  Skipped (exists): $DestinationRelativePath" -InformationAction Continue
            return 'existing'
        }

        Remove-Item -Path $dest -Recurse -Force
    }

    if ($Recurse) {
        Copy-Item -Path $source -Destination $dest -Recurse -Force
    }
    else {
        Copy-Item -Path $source -Destination $dest -Force
    }

    if ($FrontmatterName -and ($UpdateFrontmatter.IsPresent -or $RequireFrontmatterName.IsPresent)) {
        $frontmatterFile = if ($Recurse) { Join-Path $dest 'SKILL.md' } else { $dest }
        $null = Update-FrontmatterNameField -FilePath $frontmatterFile -NewName $FrontmatterName -Required:$RequireFrontmatterName.IsPresent
    }

    Write-Information "  Copied: $DestinationRelativePath" -InformationAction Continue
    return 'copied'
}

$copiedCount = 0
$skippedCount = 0
$missingCount = 0

foreach ($source in $sources) {
    Write-Information "`nProcessing source: $($source.name) ($($source.repo))" -InformationAction Continue
    $sourceRoot = Get-RepoCheckout -Repo $source.repo

    # --- Copy agents (single files) ---
    if ($source.agents.Count -gt 0) {
        Write-Information "Copying agents from '$($source.repo)'..." -InformationAction Continue
        foreach ($agent in $source.agents) {
            $assetName = [string]$agent
            $resolvedPath = Resolve-AssetRelativePath -AssetType 'agents' -AssetName $assetName
            $installedPath = Get-InstalledRelativePath -AssetType 'agents' -ResolvedPath $resolvedPath -NameTransform $source.nameTransform
            $frontmatterName = if ($source.nameTransform.updateFrontmatter -and ($source.nameTransform.prefix -or $source.nameTransform.suffix)) { Get-TransformedName -Name $assetName -NameTransform $source.nameTransform } else { $null }
            $result = Copy-Asset -SourceRoot $sourceRoot -SourceRelativePath $resolvedPath -DestinationRelativePath $installedPath -Recurse $false -FrontmatterName $frontmatterName -UpdateFrontmatter:$source.nameTransform.updateFrontmatter

            switch ($result) {
                'copied' { $copiedCount++ }
                'existing' { $skippedCount++ }
                'missing' { $missingCount++ }
            }
        }
    }

    # --- Copy skills (recursive folders) ---
    if ($source.skills.Count -gt 0) {
        Write-Information "Copying skills from '$($source.repo)'..." -InformationAction Continue
        foreach ($skill in $source.skills) {
            $assetName = [string]$skill
            $resolvedPath = Resolve-AssetRelativePath -AssetType 'skills' -AssetName $assetName
            $installedPath = Get-InstalledRelativePath -AssetType 'skills' -ResolvedPath $resolvedPath -NameTransform $source.nameTransform
            $renamedSkill = $installedPath -ne $resolvedPath
            $frontmatterName = if ($renamedSkill) { Get-TransformedName -Name $assetName -NameTransform $source.nameTransform } else { $null }
            $result = Copy-Asset -SourceRoot $sourceRoot -SourceRelativePath $resolvedPath -DestinationRelativePath $installedPath -Recurse $true -FrontmatterName $frontmatterName -RequireFrontmatterName:$renamedSkill

            switch ($result) {
                'copied' { $copiedCount++ }
                'existing' { $skippedCount++ }
                'missing' { $missingCount++ }
            }
        }
    }

    # --- Copy instructions (single files) ---
    if ($source.instructions.Count -gt 0) {
        Write-Information "Copying instructions from '$($source.repo)'..." -InformationAction Continue
        foreach ($instruction in $source.instructions) {
            $assetName = [string]$instruction
            $resolvedPath = Resolve-AssetRelativePath -AssetType 'instructions' -AssetName $assetName
            $installedPath = Get-InstalledRelativePath -AssetType 'instructions' -ResolvedPath $resolvedPath -NameTransform $source.nameTransform
            $frontmatterName = if ($source.nameTransform.updateFrontmatter -and ($source.nameTransform.prefix -or $source.nameTransform.suffix)) { Get-TransformedName -Name $assetName -NameTransform $source.nameTransform } else { $null }
            $result = Copy-Asset -SourceRoot $sourceRoot -SourceRelativePath $resolvedPath -DestinationRelativePath $installedPath -Recurse $false -FrontmatterName $frontmatterName -UpdateFrontmatter:$source.nameTransform.updateFrontmatter

            switch ($result) {
                'copied' { $copiedCount++ }
                'existing' { $skippedCount++ }
                'missing' { $missingCount++ }
            }
        }
    }

    # --- Copy prompts (single files) ---
    if ($source.prompts.Count -gt 0) {
        Write-Information "Copying prompts from '$($source.repo)'..." -InformationAction Continue
        foreach ($prompt in $source.prompts) {
            $assetName = [string]$prompt
            $resolvedPath = Resolve-AssetRelativePath -AssetType 'prompts' -AssetName $assetName
            $installedPath = Get-InstalledRelativePath -AssetType 'prompts' -ResolvedPath $resolvedPath -NameTransform $source.nameTransform
            $frontmatterName = if ($source.nameTransform.updateFrontmatter -and ($source.nameTransform.prefix -or $source.nameTransform.suffix)) { Get-TransformedName -Name $assetName -NameTransform $source.nameTransform } else { $null }
            $result = Copy-Asset -SourceRoot $sourceRoot -SourceRelativePath $resolvedPath -DestinationRelativePath $installedPath -Recurse $false -FrontmatterName $frontmatterName -UpdateFrontmatter:$source.nameTransform.updateFrontmatter

            switch ($result) {
                'copied' { $copiedCount++ }
                'existing' { $skippedCount++ }
                'missing' { $missingCount++ }
            }
        }
    }
}

# --- Summary ---
Write-Information "`nDone. $copiedCount item(s) copied to '$dotGithubDir'." -InformationAction Continue
if ($skippedCount -gt 0) {
    Write-Information "$skippedCount item(s) already existed and were skipped. Use -Force to overwrite." -InformationAction Continue
}
if ($missingCount -gt 0) {
    Write-Warning "$missingCount item(s) could not be found in source repositories and were skipped. Check the warnings above."
}
