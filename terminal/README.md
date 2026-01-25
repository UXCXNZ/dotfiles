# Terminal.app Configuration

This directory contains configuration scripts for macOS Terminal.app to match the Tokyo Night theme used in WezTerm.

## Features

- **Font**: MesloLGS Nerd Font Mono (size 18)
- **Color Scheme**: Tokyo Night inspired
  - Very dark background with subtle blue tint (#0a0b10)
  - Silver/gray text for better readability (#c0c0c0)
  - Tokyo Night cursor and selection colors
- **Profiles Updated**: Homebrew, Basic, Pro, and others
- **Starship Integration**: Simplified prompt for Terminal.app compatibility

## Installation

### Using Stow

From the dotfiles directory:

```bash
# This won't symlink anything since Terminal.app doesn't use dotfiles
# But keeps the script organized in your dotfiles
cd ~/dotfiles
stow terminal
```

### Manual Configuration

Run the configuration script directly:

```bash
~/.config/terminal/configure-terminal.sh
```

Or from the dotfiles directory:

```bash
./terminal/.config/terminal/configure-terminal.sh
```

## What It Does

The script uses AppleScript to:
1. Set the font to MesloLGS Nerd Font Mono at size 18
2. Apply Tokyo Night color scheme
3. Update all common Terminal profiles
4. Apply changes to the current window immediately

## Customization

To adjust settings, edit `configure-terminal.sh`:
- **Font size**: Change `fontSize` variable (currently 18)
- **Background darkness**: Adjust RGB values in `darkBackground`
- **Colors**: Modify the color variables at the top of the script

## Font Requirements

Ensure MesloLGS Nerd Font is installed:
```bash
# Check if font is installed
fc-list | grep -i "MesloLGS"
```

If not installed, download from [Nerd Fonts](https://www.nerdfonts.com/).

## Notes

- Changes apply to new Terminal windows immediately
- Current window is also updated when script runs
- Terminal.app doesn't use traditional dotfiles, so this script must be run manually
- Consider adding an alias to your `.zshrc`:
  ```bash
  alias terminal-theme='~/.config/terminal/configure-terminal.sh'
  ```