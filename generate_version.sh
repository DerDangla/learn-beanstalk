#!/bin/bash

# Fetch the latest tag (or default to v1.0.0 if no tag exists)
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")

# Extract the version components
major=$(echo $latest_tag | cut -d. -f1 | cut -dv -f2)
minor=$(echo $latest_tag | cut -d. -f2)
patch=$(echo $latest_tag | cut -d. -f3)

# Increment the patch version
new_patch=$((patch + 1))
new_version="v${major}.${minor}.${new_patch}"

# Output the new version
echo "New version: $new_version"

# Tag the new version and push it
git tag -a "$new_version" -m "Release $new_version"
git push origin "$new_version"
