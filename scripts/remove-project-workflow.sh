#!/usr/bin/env bash
# Removes add-to-personal-project.yml workflow and PERSONAL_ACCESS_TOKEN secret
# from all repos where the file exists.
# Usage: bash scripts/remove-project-workflow.sh

FILE=".github/workflows/add-to-personal-project.yml"
OWNER="markheydon"

echo "Fetching repo list..."
REPOS=$(gh repo list $OWNER --limit 200 --json name,isArchived \
  --jq '.[] | select(.isArchived == false) | .name')

for repo in $REPOS; do
  FULL="$OWNER/$repo"

  # Check file exists and get SHA
  SHA=$(gh api "repos/$FULL/contents/$FILE" --jq '.sha' 2>/dev/null)
  if [ -z "$SHA" ] || [ "$SHA" = "null" ]; then
    continue
  fi

  echo ""
  echo "--- $repo ---"

  # Delete the workflow file
  gh api --method DELETE "repos/$FULL/contents/$FILE" \
    -f message="chore: remove add-to-personal-project workflow" \
    -f sha="$SHA" > /dev/null 2>&1 \
    && echo "  ✓ Deleted $FILE" \
    || echo "  ✗ FAILED to delete $FILE"

  # Delete the secret (ok if it doesn't exist)
  gh secret delete PERSONAL_ACCESS_TOKEN --repo "$FULL" --app actions 2>/dev/null \
    && echo "  ✓ Deleted PERSONAL_ACCESS_TOKEN secret" \
    || echo "  - Secret not present (skipped)"
done

echo ""
echo "Done."
