@echo off

:: Source of truth: plan/LABEL_STRATEGY.md
:: Auto-maintained by the repo-update-from-strategy prompt.
:: Do not edit label names, colours, or descriptions here directly —
:: update plan/LABEL_STRATEGY.md and run repo-update-from-strategy instead.
:: See also: .github/instructions/label-script-update.instructions.md

:: Check if GitHub CLI is installed
where gh >nul 2>nul
if errorlevel 1 (
    echo GitHub CLI ^(gh^) could not be found. Please install it first.
    exit /b 1
)

:: Check if repository is provided
if "%~1"=="" (
    echo Usage: %0 ^<repository^>
    exit /b 1
)

set REPO=%~1

:: --- Core labels ---
gh label create "epic" --color "3E4B9E" --description "A large body of work made up of multiple stories." --repo "%REPO%" --force
gh label create "story" --color "0E8A16" --description "A user-facing feature, improvement, or technical task." --repo "%REPO%" --force
gh label create "bug" --color "d73a4a" --description "Something isn't working as expected." --repo "%REPO%" --force

:: --- Modifier labels ---
gh label create "priority-high" --color "FBCA04" --description "High priority — address before other items." --repo "%REPO%" --force
gh label create "blocked" --color "cfd3d7" --description "Blocked by another issue or external dependency." --repo "%REPO%" --force
gh label create "not-started" --color "ffffff" --description "Work has not yet started." --repo "%REPO%" --force
gh label create "out-of-scope" --color "ededed" --description "Intentionally deferred — may be revisited in future." --repo "%REPO%" --force
gh label create "feedback-required" --color "d9d4f5" --description "Waiting for feedback before work can proceed." --repo "%REPO%" --force
gh label create "waiting-for-details" --color "d9d4f5" --description "Further details required before work can start." --repo "%REPO%" --force

:: --- GitHub default labels ---
gh label create "documentation" --color "0075ca" --description "Improvements or additions to documentation." --repo "%REPO%" --force
gh label create "duplicate" --color "cfd3d7" --description "This issue or pull request already exists." --repo "%REPO%" --force
gh label create "enhancement" --color "a2eeef" --description "An improvement to existing functionality." --repo "%REPO%" --force
gh label create "good first issue" --color "7057ff" --description "Good for newcomers." --repo "%REPO%" --force
gh label create "help wanted" --color "008672" --description "Extra attention is needed." --repo "%REPO%" --force
gh label create "invalid" --color "e4e669" --description "This doesn't seem right." --repo "%REPO%" --force
gh label create "question" --color "d876e3" --description "Further information is requested." --repo "%REPO%" --force
gh label create "wontfix" --color "ffffff" --description "This will not be worked on." --repo "%REPO%" --force