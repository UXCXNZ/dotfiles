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
}

-- Appearance
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_background_image = constants.bg_image
config.macos_window_background_blur = 40

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true

-- Custom commands
wezterm.on("augment-command-palette", function()
	return commands
end)

return config