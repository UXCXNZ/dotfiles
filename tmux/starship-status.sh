#!/bin/bash
# Use actual Starship prompt in tmux status bar

# Create a minimal Starship config for status bar
export STARSHIP_CONFIG=/dev/stdin
export STARSHIP_SHELL=bash

# Get Starship output with just the modules we want
starship prompt --status=0 --jobs=0 <<EOF
format = "\$directory\$git_branch\$git_status"

[directory]
format = "[$path]($style)"
style = "blue bold"
truncation_length = 2
truncation_symbol = "…/"

[git_branch]
format = " [$symbol$branch]($style)"
style = "purple"
symbol = ""

[git_status]
format = "[$all_status$ahead_behind]($style)"
style = "red"
conflicted = "="
ahead = "⇡"
behind = "⇣"
diverged = "⇕"
untracked = "?"
modified = "!"
staged = "+"
EOF