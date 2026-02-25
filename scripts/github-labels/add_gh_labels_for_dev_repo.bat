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

gh label create "dependency" --color "cfd3d7" --description "Has a dependency to one or more other Issues" --repo %REPO%
gh label create "feature" --color "ed6cb6" --description "New feature, requirement or functionality." --repo %REPO%
gh label create "feedback required" --color "d9d4f5" --description "Waiting for feedback." --repo %REPO%
gh label create "improvement" --color "ed6cb6" --description "Enhancement or change to an existing feature." --repo %REPO%
gh label create "spike" --color "f19cce" --description "Research or exploration type activities needed to gain more knowledge." --repo %REPO%
gh label create "technical" --color "8f629e" --description "Internal debt, refactoring of code or other internal type issues that supports a feature." --repo %REPO%
gh label create "waiting for details" --color "d9d4f5" --description "Further details are required in some form or other." --repo %REPO%
