#!/usr/bin/env bash
# triage-example.sh
#
# Example: Apply a label to a GitHub issue using the GitHub CLI.
# This is an illustrative script showing how the github-issue-management
# skill's triage decisions translate to CLI commands.
#
# Requirements: GitHub CLI (gh) installed and authenticated.
# Usage: ./triage-example.sh <owner/repo> <issue-number> <label>
#
# Example:
#   ./triage-example.sh markheydon/my-repo 42 story
#   ./triage-example.sh markheydon/my-repo 42 bug priority-high

set -euo pipefail

REPO="${1:-}"
ISSUE="${2:-}"
shift 2 || true
LABELS=("$@")

if [[ -z "$REPO" || -z "$ISSUE" || ${#LABELS[@]} -eq 0 ]]; then
  echo "Usage: $0 <owner/repo> <issue-number> <label> [additional-labels...]"
  exit 1
fi

# Validate labels against allowed taxonomy
CORE_LABELS=("epic" "story" "bug")
MODIFIER_LABELS=("priority-high" "blocked" "not-started" "out-of-scope" "feedback-required" "waiting-for-details")
ALL_ALLOWED=("${CORE_LABELS[@]}" "${MODIFIER_LABELS[@]}")

for label in "${LABELS[@]}"; do
  allowed=false
  for allowed_label in "${ALL_ALLOWED[@]}"; do
    if [[ "$label" == "$allowed_label" ]]; then
      allowed=true
      break
    fi
  done
  if [[ "$allowed" == false ]]; then
    echo "Warning: '$label' is not in the approved label taxonomy."
    echo "Approved labels: ${ALL_ALLOWED[*]}"
    read -r -p "Apply anyway? (y/N) " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
      echo "Skipping label '$label'."
      continue
    fi
  fi
done

# Apply each label to the issue
for label in "${LABELS[@]}"; do
  echo "Applying label '$label' to $REPO#$ISSUE..."
  gh issue edit "$ISSUE" --repo "$REPO" --add-label "$label"
done

echo "Done. Issue #$ISSUE in $REPO updated."
echo "View: https://github.com/$REPO/issues/$ISSUE"
