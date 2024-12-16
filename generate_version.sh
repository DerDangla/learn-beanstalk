#!/bin/bash

# Extract the last version from Git tags
last_version=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")

# Increment the patch version
major=$(echo $last_version | cut -d. -f1 | cut -dv -f2)
minor=$(echo $last_version | cut -d. -f2)
patch=$(echo $last_version | cut -d. -f3)
new_patch=$((patch + 1))
new_version="v${major}.${minor}.${new_patch}"

# Create a new tag and push it
git tag -a $new_version -m "Release $new_version"
git push origin $new_version

# Output the new version
echo $new_version
