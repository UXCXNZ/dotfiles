# Basic PATH configurations
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export PATH="$HOME/.local/share/bin:$PATH"

# Python alias
alias python='/usr/bin/python3'

# pnpm configuration
export PNPM_HOME="/Users/chris/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun configuration
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Git information setup
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'

# Prompt with git information
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} $ '
