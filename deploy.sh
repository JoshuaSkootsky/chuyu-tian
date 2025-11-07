#!/bin/bash

# if command fails, whole script stops
set -e

# function cleanup_at_exit {
#    # return to main branch
# }
# trap cleanup_at_exit EXIT

# Subtree method here: https://gohugo.io/hosting-and-deplooyment/hosting-on-github/

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/


echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Building site with Hugo..."
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Build the project with SEO
HUGO_ENV=production hugo

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi

# Prevent Jekyll
touch public/.nojekyll

echo "Updating gh-pages branch with message {$msg}"
cd public && git add --all && git commit -m "$msg" && cd ..

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Push source and build repos.
git push -f origin gh-pages

# Push source to main branch on github
git push origin main
