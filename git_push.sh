#!/bin/bash

# Git push script that converts local dependencies to git dependencies before pushing
# Usage: ./git_push.sh [commit message]

set -e

PUBSPEC="pubspec.yaml"
PUBSPEC_BACKUP=".pubspec.yaml.local"

# Dependency mappings: local path -> github repo
declare -A DEP_MAP=(
  ["/Users/brianfopiano/Developer/RemoteGit/ArcaneArts/arcane_jaspr"]="https://github.com/ArcaneArts/arcane_jaspr"
)

# Save the original pubspec with local deps
cp "$PUBSPEC" "$PUBSPEC_BACKUP"

echo "Converting local dependencies to git dependencies..."

# Process each dependency mapping
for local_path in "${!DEP_MAP[@]}"; do
  github_url="${DEP_MAP[$local_path]}"
  repo_name=$(basename "$local_path")

  # Use perl for multi-line replacement (more portable than sed for this)
  perl -i -0pe "s/${repo_name}:\s*\n\s*path:\s*${local_path//\//\\/}/${repo_name}:\n    git:\n      url: ${github_url//\//\\/}\n      ref: master/g" "$PUBSPEC"
done

echo "Local dependencies converted to git dependencies"

# Stage pubspec.yaml
git add "$PUBSPEC"

# Check if there are any staged changes
if git diff --cached --quiet; then
  echo "No changes to commit"
  # Restore local deps
  mv "$PUBSPEC_BACKUP" "$PUBSPEC"
  exit 0
fi

# Commit with provided message or default
COMMIT_MSG="${1:-Update dependencies}"
git commit -m "$COMMIT_MSG"

# Push to remote
git push

echo "Pushed successfully!"

# Restore local dependencies for development
echo "Restoring local dependencies..."
mv "$PUBSPEC_BACKUP" "$PUBSPEC"

echo "Done! Local dependencies restored for development."
