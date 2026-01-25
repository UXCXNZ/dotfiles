#!/bin/bash

# Terminal.app Configuration Script
# Applies Tokyo Night theme with MesloLGS Nerd Font to match WezTerm setup

echo "Configuring Terminal.app with Tokyo Night theme..."

# Main configuration AppleScript
osascript <<'EOF'
tell application "Terminal"
    -- Define color scheme (Tokyo Night inspired)
    set darkBackground to {1285, 1542, 2570}  -- Very dark with subtle blue tint
    set textColor to {49344, 49344, 49344}     -- Silver/gray (#c0c0c0)
    set cursorColor to {49344, 51914, 62965}   -- Tokyo Night blue (#c0caf5)
    set boldColor to {53456, 53456, 53456}     -- Bright silver (#d0d0d0)
    set selectionColor to {8738, 8738, 37008}  -- Tokyo Night selection
    
    -- Font settings
    set fontName to "MesloLGS Nerd Font Mono"
    set fontSize to 18
    
    -- List of profiles to update
    set profileList to {"Homebrew", "Basic", "Pro", "Ocean", "Grass", "Red Sands", "Silver Aerogel", "Solid Colors", "Man Page", "Novel"}
    
    -- Update each profile
    repeat with profileName in profileList
        try
            set targetSettings to settings set profileName
            
            -- Apply font
            set the font name of targetSettings to fontName
            set the font size of targetSettings to fontSize
            
            -- Apply colors
            set the background color of targetSettings to darkBackground
            set the normal text color of targetSettings to textColor
            set the cursor color of targetSettings to cursorColor
            set the bold text color of targetSettings to boldColor
            set the selection color of targetSettings to selectionColor
            
        on error
            -- Profile might not exist, skip it
        end try
    end repeat
    
    -- Also apply to current window for immediate effect
    try
        tell front window
            set its font name to fontName
            set its font size to fontSize
            set its background color to darkBackground
            set its normal text color to textColor
            set its cursor color to cursorColor
            set its bold text color to boldColor
        end tell
    end try
    
    return "Terminal configured successfully with Tokyo Night theme"
end tell
EOF

echo "✓ Terminal.app configuration complete!"
echo ""
echo "Note: You may need to:"
echo "  1. Create a new Terminal window (⌘N) to see the changes"
echo "  2. Set your preferred profile as default in Terminal → Settings → Profiles"