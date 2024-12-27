-- Pull in the wezterm API
local wezterm = require("wezterm")
local commands = require("commands")
local constants = require("constants")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Font settings

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19
config.line_height= 1.2

-- Colors
config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
	indexed = { [239] = "lightslategrey" },

	-- Add tab bar color customization
	tab_bar = {
		-- The color of the inactive tab bar edge/background
		background = 'rgba(0,0,0,0.35)',

		-- The active tab is the one that has focus in the window
		active_tab = {
			-- The color of the background area for the tab
			bg_color = 'rgba(0,0,0,0.5)',
			-- The color of the text for the tab
			fg_color = '#c0c0c0',
		},

		-- Inactive tabs are the tabs that do not have focus
		inactive_tab = {
			bg_color = 'rgba(0,0,0,0.3)',
			fg_color = '#808080',
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over inactive tabs
		inactive_tab_hover = {
			bg_color = 'rgba(0,0,0,0.4)',
			fg_color = '#909090',
		},
	},
}

-- Appearance
config.window_decorations = "RESIZE"  -- Only show resize handles, no buttons
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_background_image = constants.bg_image
config.macos_window_background_blur = 40

-- Add window opacity setting
config.window_background_opacity = 0.9  -- Set initial opacity (0.0 to 1.0)

-- Add key binding to toggle opacity
config.keys = {
  --------------------------------------------------
  -- Opacity/Transparency Controls
  --------------------------------------------------
  -- CMD+B: Toggle between transparent (10%) and default opacity
  {
    key = 'b',
    mods = 'CMD',
    action = wezterm.action_callback(function(window)
      wezterm.log_info("Toggle transparency pressed")
      local overrides = window:get_config_overrides() or {}
      if not overrides.window_background_opacity then
        overrides.window_background_opacity = 0.1
      else
        overrides.window_background_opacity = nil
      end
      window:set_config_overrides(overrides)
    end),
  },
  
  -- CMD+OPT+Left: Decrease opacity by 10%
  {
    key = 'LeftArrow',
    mods = 'CMD|OPT',
    action = wezterm.action_callback(function(window)
      wezterm.log_info("Decrease opacity pressed")
      local overrides = window:get_config_overrides() or {}
      local current = overrides.window_background_opacity or 0.9
      overrides.window_background_opacity = math.max(0.1, current - 0.1)
      window:set_config_overrides(overrides)
    end),
  },

  -- CMD+OPT+Right: Increase opacity by 10%
  {
    key = 'RightArrow',
    mods = 'CMD|OPT',
    action = wezterm.action_callback(function(window)
      wezterm.log_info("Increase opacity pressed")
      local overrides = window:get_config_overrides() or {}
      local current = overrides.window_background_opacity or 0.9
      overrides.window_background_opacity = math.min(1.0, current + 0.1)
      window:set_config_overrides(overrides)
    end),
  },

  --------------------------------------------------
  -- Background Blur Controls
  --------------------------------------------------
  -- CMD+SHIFT+B: Toggle between no blur and default blur
  {
    key = 'b',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window)
      wezterm.log_info("Toggle blur pressed")
      local overrides = window:get_config_overrides() or {}
      if not overrides.macos_window_background_blur then
        overrides.macos_window_background_blur = 0
      else
        overrides.macos_window_background_blur = nil  -- Reset to default (40)
      end
      window:set_config_overrides(overrides)
    end),
  },

  -- CMD+SHIFT+Left: Decrease blur by 10
  {
    key = 'LeftArrow',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window)
      wezterm.log_info("Decrease blur pressed")
      local overrides = window:get_config_overrides() or {}
      local current = overrides.macos_window_background_blur or 40  -- Default is 40
      local new_blur = math.max(0, current - 10)  -- Don't go below 0
      overrides.macos_window_background_blur = new_blur
      window:set_config_overrides(overrides)
    end),
  },

  -- CMD+SHIFT+Right: Increase blur by 10
  {
    key = 'RightArrow',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window)
      wezterm.log_info("Increase blur pressed")
      local overrides = window:get_config_overrides() or {}
      local current = overrides.macos_window_background_blur or 40  -- Default is 40
      local new_blur = math.min(100, current + 10)  -- Don't go above 100
      overrides.macos_window_background_blur = new_blur
      window:set_config_overrides(overrides)
    end),
  },

  --------------------------------------------------
  -- Tab Management
  --------------------------------------------------
  -- CMD+[: Switch to previous tab
  {
    key = '[',
    mods = 'CMD',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  
  -- CMD+]: Switch to next tab
  {
    key = ']',
    mods = 'CMD',
    action = wezterm.action.ActivateTabRelative(1),
  },
  
  -- CMD+W: Close current tab (with confirmation)
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  
  --------------------------------------------------
  -- Direct Tab Switching
  --------------------------------------------------
  -- CMD+1: Switch to Tab 1
  {
    key = '1',
    mods = 'CMD',
    action = wezterm.action.ActivateTab(0),
  },
  -- CMD+2: Switch to Tab 2
  {
    key = '2',
    mods = 'CMD',
    action = wezterm.action.ActivateTab(1),
  },
  -- CMD+3: Switch to Tab 3
  {
    key = '3',
    mods = 'CMD',
    action = wezterm.action.ActivateTab(2),
  },
  -- CMD+4: Switch to Tab 4
  {
    key = '4',
    mods = 'CMD',
    action = wezterm.action.ActivateTab(3),
  },
  -- CMD+5: Switch to Tab 5
  {
    key = '5',
    mods = 'CMD',
    action = wezterm.action.ActivateTab(4),
  },
}

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true

-- Custom commands
wezterm.on("augment-command-palette", function()
	return commands
end)

-- Optional: If you want to customize the tab bar appearance
config.use_fancy_tab_bar = false        -- Makes the tab bar more compact
-- config.tab_bar_at_bottom = true      -- Remove or comment this line to keep tabs at top

return config