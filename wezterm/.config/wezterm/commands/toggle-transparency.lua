local wezterm = require("wezterm")
local constants = require("constants")

-- Define opacity levels we want to cycle through
local opacity_levels = {
	{ opacity = 1.0, bg = constants.bg_image },    -- Fully opaque with bg image
	{ opacity = 0.8, bg = "" },                    -- 80% opacity, no bg
	{ opacity = 0.5, bg = "" },                    -- 50% opacity, no bg
}

local command = {
	brief = "Toggle terminal transparency",
	icon = "md_circle_opacity",
	action = wezterm.action_callback(function(window)
		local overrides = window:get_config_overrides() or {}
		local current_opacity = overrides.window_background_opacity or 1.0
		
		-- Find next opacity level
		local next_level = opacity_levels[1] -- default to first if not found
		for i, level in ipairs(opacity_levels) do
			if current_opacity == level.opacity then
				next_level = opacity_levels[i + 1] or opacity_levels[1] -- cycle back to first
				break
			end
		end
		
		-- Apply the new settings
		overrides.window_background_opacity = next_level.opacity
		overrides.window_background_image = next_level.bg
		
		window:set_config_overrides(overrides)
	end),
}

return command