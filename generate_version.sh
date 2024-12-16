#!/bin/bash

# Fetch the latest tag
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")

# Extract version components
major=$(echo $latest_tag | cut -d. -f1 | cut -dv -f2)
minor=$(echo $latest_tag | cut -d. -f2)
patch=$(echo $latest_tag | cut -d. -f3)

# Increment the patch version
new_patch=$((patch + 1))
new_version="v${major}.${minor}.${new_patch}"

# Check if the tag already exists
if git rev-parse "$new_version" >/dev/null 2>&1; then
    echo "Tag $new_version already exists. Skipping tag creation."
else
    # Create and push the new tag
    echo "New version: $new_version"
    git tag -a "$new_version" -m "Release $new_version"
    git push origin "$new_version"
fi
