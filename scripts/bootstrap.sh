#!/bin/bash
# Bootstrap a new macOS machine with dotfiles and dev tools
# Usage: curl the repo, then run: ./scripts/bootstrap.sh

set -e

DOTFILES_DIR="$HOME/dotfiles"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

step() { echo -e "\n${GREEN}==> $1${NC}"; }
warn() { echo -e "${YELLOW}    $1${NC}"; }
fail() { echo -e "${RED}    $1${NC}"; }

# ── Preflight ──────────────────────────────────────────────

if [[ "$(uname)" != "Darwin" ]]; then
  fail "This script is for macOS only."
  exit 1
fi

# ── Homebrew ───────────────────────────────────────────────

step "Installing Homebrew (if needed)"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Add brew to PATH — Apple Silicon: /opt/homebrew, Intel: /usr/local
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  fail "Homebrew not found after install"
  exit 1
fi

# ── CLI tools ──────────────────────────────────────────────

step "Installing CLI tools"
brew install \
  stow \
  tmux \
  zoxide \
  starship \
  fzf \
  git \
  gh \
  eza \
  ripgrep \
  jq \
  zsh-autosuggestions \
  zsh-syntax-highlighting

# ── Cask apps ─────────────────────────────────────────────

step "Installing apps"
brew install --cask wezterm 2>/dev/null || warn "WezTerm already installed"
brew install --cask ghostty 2>/dev/null || warn "Ghostty already installed or not available"

# ── Font ──────────────────────────────────────────────────

step "Installing Nerd Font"
brew install --cask font-meslo-lg-nerd-font 2>/dev/null || warn "Font already installed"

# ── Clone dotfiles (if not already here) ──────────────────

step "Setting up dotfiles"
if [[ ! -d "$DOTFILES_DIR" ]]; then
  git clone git@github.com:UXCXNZ/dotfiles.git "$DOTFILES_DIR"
else
  warn "Dotfiles already cloned at $DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# ── Stow everything ──────────────────────────────────────

step "Stowing configurations"
for pkg in zsh tmux wezterm starship ghostty terminal ssh; do
  if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
    echo "  Stowing $pkg..."
    stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg" 2>/dev/null || warn "  $pkg had conflicts (check existing files)"
  fi
done

# ── nvm ───────────────────────────────────────────────────

step "Installing nvm"
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install --lts
else
  warn "nvm already installed"
fi

# ── pnpm ──────────────────────────────────────────────────

step "Installing pnpm"
if ! command -v pnpm &>/dev/null; then
  npm install -g pnpm
else
  warn "pnpm already installed"
fi

# ── bun ───────────────────────────────────────────────────

step "Installing bun"
if ! command -v bun &>/dev/null; then
  curl -fsSL https://bun.sh/install | bash
else
  warn "bun already installed"
fi

# ── Tmux plugins ─────────────────────────────────────────

step "Setting up tmux plugins"
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  warn "Open tmux and press prefix+I to install plugins"
else
  warn "TPM already installed"
fi

# ── Git identity ─────────────────────────────────────────

step "Configuring git"
if [[ -z "$(git config --global user.email)" ]]; then
  read -p "  Git email: " git_email
  read -p "  Git name: " git_name
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
else
  warn "Git already configured as $(git config --global user.name) <$(git config --global user.email)>"
fi

# ── Clone repos (optional) ───────────────────────────────

step "Clone project repos?"
echo "  Run ~/dotfiles/scripts/clone-repos.sh when ready"

# ── Done ─────────────────────────────────────────────────

step "Bootstrap complete!"
echo ""
echo "  Next steps:"
echo "    1. Restart your shell (or: source ~/.zshrc)"
echo "    2. Open tmux and press C-a + I to install plugins"
echo "    3. Run ~/dotfiles/scripts/clone-repos.sh to clone repos"
echo "    4. Copy ~/.secrets from your other machine (API keys, tokens)"
echo ""
