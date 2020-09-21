#!/bin/bash

# if command fails, whole script stops
set -e

# function cleanup_at_exit {
#    # return to main branch
# }
# trap cleanup_at_exit EXIT

# Subtree method here: https://gohugo.io/hosting-and-deployment/hosting-on-github/
printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# build
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi

cd public && git add --all && git commit -m "$msg" && cd ..


# Push source and build repos.
git push github gh-pages
