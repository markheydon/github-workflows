@echo off

:: Deletes deprecated labels from a GitHub repository to align with plan/LABEL_STRATEGY.md.
:: Run Convert-IssueLabels.ps1 first to re-label existing issues before deleting old labels.
:: Safe to run multiple times — gh label delete exits cleanly if the label does not exist.

:: Check if GitHub CLI is installed
where gh >nul 2>nul
if errorlevel 1 (
    echo GitHub CLI ^(gh^) could not be found. Please install it first.
    exit /b 1
)

:: Check if repository is provided
if "%~1"=="" (
    echo Usage: %0 ^<owner/repository^>
    exit /b 1
)

set REPO=%~1

echo Removing deprecated labels from %REPO%...

:: --- Renamed labels (replacements already exist) ---
:: dependency -> blocked
gh label delete "dependency" --repo "%REPO%" --yes 2>nul && echo Deleted: dependency || echo Skipped ^(not found^): dependency

:: feedback required (space) -> feedback-required
gh label delete "feedback required" --repo "%REPO%" --yes 2>nul && echo Deleted: feedback required || echo Skipped ^(not found^): feedback required

:: waiting details (old malformed name) -> waiting-for-details
gh label delete "waiting details" --repo "%REPO%" --yes 2>nul && echo Deleted: waiting details || echo Skipped ^(not found^): waiting details

:: waiting for details (spaced variant, as created by old label scripts) -> waiting-for-details
gh label delete "waiting for details" --repo "%REPO%" --yes 2>nul && echo Deleted: waiting for details || echo Skipped ^(not found^): waiting for details

:: --- Superseded labels (replaced by 'story') ---
gh label delete "feature" --repo "%REPO%" --yes 2>nul && echo Deleted: feature || echo Skipped ^(not found^): feature
gh label delete "improvement" --repo "%REPO%" --yes 2>nul && echo Deleted: improvement || echo Skipped ^(not found^): improvement
gh label delete "spike" --repo "%REPO%" --yes 2>nul && echo Deleted: spike || echo Skipped ^(not found^): spike
gh label delete "technical" --repo "%REPO%" --yes 2>nul && echo Deleted: technical || echo Skipped ^(not found^): technical

echo Done.