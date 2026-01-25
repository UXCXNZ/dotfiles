#!/bin/bash
# Script to get Starship-like info for tmux status bar

# Get current directory (shortened)
DIR=$(pwd | sed "s|$HOME|~|" | awk -F/ '{if (NF>3) {print $(NF-1)"/"$NF} else print $0}')

# Get git branch if in a git repo
GIT_BRANCH=$(git branch --show-current 2>/dev/null)
if [ -n "$GIT_BRANCH" ]; then
    # Check for uncommitted changes
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        GIT_STATUS=" $GIT_BRANCH*"
    else
        GIT_STATUS=" $GIT_BRANCH"
    fi
else
    GIT_STATUS=""
fi

# Output format similar to Starship
echo " $DIR$GIT_STATUS"