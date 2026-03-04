@echo off

:: Check if GitHub CLI is installed
where gh >nul 2>nul
if errorlevel 1 (
    echo GitHub CLI (gh) could not be found. Please install it first.
    exit /b 1
)

:: Check if repository is provided
if "%~1"=="" (
    echo Usage: %0 ^<repository^>
    exit /b 1
)

set REPO=%1

gh label create "feedback required" --color "d9d4f5" --description "Waiting for feedback." --repo "%REPO%" --force
gh label create "waiting for details" --color "d9d4f5" --description "Further details are required in some form or other." --repo "%REPO%" --force
gh label create "incident" --color "f99aa2" --description "Incident or fault reported either by an end-user, internal user or monitoring solution." --repo "%REPO%" --force
gh label create "service request" --color "d8e38e" --description "Request for something either new, change or maintenance." --repo "%REPO%" --force
gh label create "problem" --color "8777bf" --description "Underlying cause of one or more incidents requiring investigation and resolution." --repo "%REPO%" --force
gh label create "change request" --color "f12089" --description "Proposal for a change to a system, process, or service." --repo "%REPO%" --force
gh label create "epic" --color "3E4B9E" --description "A large body of work made up of multiple stories." --repo "%REPO%" --force
gh label create "story" --color "0E8A16" --description "A user-facing feature, improvement, or technical task." --repo "%REPO%" --force
gh label create "bug" --color "d73a4a" --description "Something isn't working as expected." --repo "%REPO%" --force
gh label create "out-of-scope" --color "ededed" --description "Intentionally deferred or out of scope." --repo "%REPO%" --force
gh label create "not-started" --color "ffffff" --description "Work has not yet started." --repo "%REPO%" --force
gh label create "priority-high" --color "e4e669" --description "High priority item." --repo "%REPO%" --force
gh label create "dependency" --color "cfd3d7" --description "Has a dependency on one or more other issues." --repo "%REPO%" --force
gh label create "feedback-required" --color "d9d4f5" --description "Waiting for feedback." --repo "%REPO%" --force
gh label create "waiting-for-details" --color "d9d4f5" --description "Further details are required." --repo "%REPO%" --force
