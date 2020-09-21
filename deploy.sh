#!/bin/bash

# if command fails, whole script stops
set -e

function cleanup_at_exit {
    # return to main branch
    git checkout main

    #remove the deploy branch
    git branch -D deploy
}
trap cleanup_at_exit EXIT

git checkout -b deploy

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# build
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

git add -f public/

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"


# Push source and build repos.
git push github deploy

