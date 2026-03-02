# Load secrets (API keys, tokens) from separate file
[ -f ~/.secrets ] && source ~/.secrets

# Basic PATH configurations
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export PATH="$HOME/.local/share/bin:$PATH"

# Python alias
alias python='/usr/bin/python3'

# Quick machine identifier — shows hostname and local IP
alias whereami='echo "$(hostname): $(ipconfig getifaddr en0)"'

# pnpm configuration
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun configuration
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Git information setup with better resize handling
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git

# More robust precmd function
precmd() {
  vcs_info
  # Clear any potential terminal artifacts
  print -Pn "\e[?25h"  # Ensure cursor is visible
}

# Terminal resize handling
TRAPWINCH() {
  # Only call zle commands if ZLE is active and we're in an interactive context
  if [[ -o zle ]] && [[ $ZLE_STATE == *insert* || $ZLE_STATE == *overwrite* || -z $ZLE_STATE ]]; then
    zle reset-prompt 2>/dev/null
    zle -R 2>/dev/null
  fi
}

# Prompt with git information - disabled in favor of Starship
# setopt PROMPT_SUBST
# PROMPT='%F{blue}%~%f${vcs_info_msg_0_} $ '

# Ensure clean prompt on resize
setopt NO_PROMPT_SP

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Orbstack path
export PATH="/opt/orbstack/bin:$PATH"


# YouTube transcript processor alias
alias transcript-processor="cd $HOME/Code/orion/orion-future-of-work && ./transcript-processor.sh"
export PATH="$HOME/.local/bin:$PATH"

# Claude CLI wrapper - supports --dsp/-dsp as shorthand for --dangerously-skip-permissions
unalias claude 2>/dev/null
claude() {
  local args=()
  for arg in "$@"; do
    case "$arg" in
      --dsp|-dsp) args+=("--dangerously-skip-permissions") ;;
      *) args+=("$arg") ;;
    esac
  done
  ~/.local/bin/claude "${args[@]}"
}
alias brave="/Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser"

# Terminal Configuration
alias terminal-theme='~/.config/terminal/configure-terminal.sh'

# Starship prompt switching
alias starship-terminal='export STARSHIP_CONFIG=~/.config/starship-terminal.toml && exec zsh'
alias starship-default='unset STARSHIP_CONFIG && exec zsh'

# Auto-detect terminal and use appropriate Starship config
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    export STARSHIP_CONFIG=~/.config/starship-terminal.toml
elif [[ -n "$TMUX" ]] && [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    # Only use minimal prompt in Terminal.app's tmux
    export STARSHIP_CONFIG=~/.config/starship-minimal.toml
fi

# Optional: Right-side prompt with time (uncomment to enable)
# RPS1='%F{yellow}%T%f'  # Shows time on the right side
export BROWSER="brave"
# Autojump — Apple Silicon: /opt/homebrew, Intel: /usr/local
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Zoxide config (init is at the end of this file — it must be last)
export _ZO_ECHO=1

# Enhanced fzf + zoxide integration with preview
fz() {
  local dir
  # Set terminal to handle resize better
  printf '\033[?1049h'  # Save screen

  dir=$(zoxide query --list | fzf \
    --preview 'ls -la --color=always {}' \
    --height 100% \
    --layout reverse \
    --border \
    --prompt "Select directory: " \
    --bind 'resize:clear-screen+reload(zoxide query --list)' \
    --no-mouse \
    --ansi \
    --cycle) && cd "$dir"

  # Restore screen
  printf '\033[?1049l'
}

# Simple prompt for testing resize issues (uncomment to test)
simple_prompt() {
  PROMPT='%~ $ '
  unset precmd_functions
  unset TRAPWINCH
}

# Minimal test prompt - completely clean
minimal_prompt() {
  PROMPT='$ '
  unset precmd_functions
  unset TRAPWINCH
  unset vcs_info_msg_0_
}

# Starship prompt
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"
# Homebrew — Apple Silicon: /opt/homebrew, Intel: /usr/local
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version="$(cat "$nvmrc_path")"
    if [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use "$nvmrc_node_version"
    fi
  else
    if [ "$(nvm version)" != "$(nvm version default)" ]; then
      nvm use default >/dev/null
    fi
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

alias claude-mem='bun "$HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

alias oscar-workspace="~/clawd/bin/oscar-workspace"

# Zsh plugins — Apple Silicon: /opt/homebrew/share, Intel: /usr/local/share
for share_dir in /opt/homebrew/share /usr/local/share; do
  [ -f "$share_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$share_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$share_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$share_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
done

# Zoxide init (must be last — nothing should modify cd/prompt hooks after this)
eval "$(zoxide init zsh)"
