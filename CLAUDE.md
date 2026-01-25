# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Dotfiles Architecture

This is a personal dotfiles repository managed with GNU Stow. The repository follows a modular structure where each directory represents a set of configuration files that can be symlinked to the home directory.

### Key Components

- **tmux/**: Tmux configuration with Tokyo Night theme, vim-tmux-navigator, session persistence plugins, and custom status bar
  - Prefix key: `Ctrl-a` (remapped from `Ctrl-b`)
  - Custom status bar showing directory, git branch, and time
- **wezterm/**: WezTerm terminal configuration with custom key bindings for opacity, blur, and tab management
  - Font: MesloLGS Nerd Font Mono (size 19)
  - Tokyo Night color scheme
- **zsh/**: Zsh configuration with git integration, nvm, pnpm, bun, and zoxide setup
  - Auto-detects terminal for appropriate Starship config
- **starship/**: Multiple Starship prompt configurations
  - Default: Fancy powerline style with backgrounds
  - Terminal: Simple pure-style for Terminal.app
  - Minimal: Just prompt character for tmux
- **terminal/**: Terminal.app configuration script
  - Applies Tokyo Night colors and MesloLGS Nerd Font
- **scripts/**: Custom scripts, including Browser MCP for web debugging integration

## Common Commands

### Stow Management
```bash
# Symlink a configuration (from dotfiles directory)
stow tmux
stow wezterm
stow zsh
stow starship
stow terminal

# Remove symlinks
stow -D tmux

# Restow (useful after adding new files)
stow -R tmux
```

### Terminal Configuration
```bash
# Apply Terminal.app theme and font settings
terminal-theme

# Switch Starship prompts
starship-terminal  # Use simple prompt for Terminal.app
starship-default    # Use fancy powerline prompt
```

### Browser MCP
```bash
# Global Browser MCP commands (after installation)
browser-mcp start     # Start the MCP server
browser-mcp stop      # Stop the server
browser-mcp status    # Check server status
browser-mcp restart   # Restart the server
browser-mcp logs      # View server logs
browser-mcp brave     # Open Brave with DevTools
```

## Repository Structure

The repository uses GNU Stow's convention where each top-level directory mirrors the structure it should have relative to the home directory. For example:
- `tmux/.tmux.conf` → `~/.tmux.conf`
- `wezterm/.config/wezterm/wezterm.lua` → `~/.config/wezterm/wezterm.lua`
- `zsh/.zshrc` → `~/.zshrc`

## Key Configurations

### WezTerm Custom Commands
- `CMD+B`: Toggle transparency (10% ↔ 90%)
- `CMD+OPT+←/→`: Adjust opacity (±10%)
- `CMD+SHIFT+B`: Toggle blur
- `CMD+SHIFT+←/→`: Adjust blur (±10)
- `CMD+CTRL+B`: Toggle background image
- `CMD+[/]`: Navigate tabs
- `CMD+1-5`: Direct tab switching

### Tmux Configuration
- Prefix: `C-a` (remapped from `C-b`)
- Split panes: `|` (horizontal), `-` (vertical)
- Resize panes: `hjkl` with prefix
- Vi mode for copy/paste
- Mouse support enabled
- TPM plugin manager with automatic session saving/restoration

### Zsh Aliases
- `python`: Points to `/usr/bin/python3`
- `transcript-processor`: YouTube transcript processor script
- `claude`: Claude CLI tool
- `brave`: Brave browser command
- `fz`: Enhanced fzf + zoxide directory navigation

## Development Notes

- The repository contains tmux plugin submodules in `tmux/.tmux/plugins/`
- Browser MCP installation script creates a global command at `~/.local/bin/browser-mcp`
- Zsh configuration includes environment variables for various tokens (GitHub, CF_AIG) that should be kept secure
- WezTerm configuration uses Lua modules for organization (commands/, constants.lua)