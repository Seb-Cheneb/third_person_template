#!/bin/bash
set -e

# Update and commit changes inside each submodule
git submodule foreach '
  git add .
  if ! git diff --cached --quiet; then
    git commit -m "Update submodule: $name"
    git push origin HEAD
  fi
'

# Back to parent repo
git submodule update --remote --merge
git add .
git commit -m "Update submodule pointers to latest commits"
git push origin main

