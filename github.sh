#!/bin/bash
set -e

DEFAULT_BRANCH="main"

# Update and commit changes inside each submodule
git submodule foreach '
  current_branch=$(git symbolic-ref --short -q HEAD || true)
  current_commit=$(git rev-parse HEAD)

  if [ -z "$current_branch" ]; then
    echo "Detached HEAD detected in $name."

    # Check if current commit exists in DEFAULT_BRANCH
    if git branch -r --contains "$current_commit" | grep -q "origin/$DEFAULT_BRANCH"; then
      echo "Current commit exists on $DEFAULT_BRANCH. Checking out..."
      git checkout $DEFAULT_BRANCH
    else
      echo "Current commit is not part of $DEFAULT_BRANCH. Skipping $name to preserve correct submodule pointer."
      exit 0
    fi
  fi

  git add .

  if ! git diff --cached --quiet; then
    echo "Committing and pushing changes in $name..."
    git commit -m "Update submodule: $name"
    git push origin HEAD:$DEFAULT_BRANCH
  fi
'

# Back to parent repo
git submodule update --remote --merge
git add .
git commit -m "Update submodule pointers to latest commits"

# Push current branch
PARENT_BRANCH=$(git symbolic-ref --short HEAD)
git push origin "$PARENT_BRANCH"
