#!/bin/bash
set -e

DEFAULT_BRANCH="main"

# Update and commit changes inside each submodule
git submodule foreach '
  # Ensure we are on a branch (not in detached HEAD)
  current_branch=$(git symbolic-ref --short -q HEAD || true)

  if [ -z "$current_branch" ]; then
    echo "Detached HEAD detected in $name. Attempting to check out $DEFAULT_BRANCH..."
    git checkout $DEFAULT_BRANCH || {
      echo "Branch $DEFAULT_BRANCH does not exist in $name. Skipping..."
      exit 0
    }
  fi

  git add .

  if ! git diff --cached --quiet; then
    echo "Committing and pushing changes in $name..."
    git commit -m "Update submodule: $name"
    git push origin HEAD:'"$DEFAULT_BRANCH"'
  fi
'

# Back to parent repo
git submodule update --remote --merge
git add .
git commit -m "Update submodule pointers to latest commits"
git push origin main
