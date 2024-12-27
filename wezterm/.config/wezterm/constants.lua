local wezterm = require('wezterm')

local M = {}

-- Use wezterm.home_dir to get the correct home directory
M.bg_blurred_darker = wezterm.home_dir .. "/.config/wezterm/assets/bg-blurred-darker.png"
M.bg_blurred = wezterm.home_dir .. "/.config/wezterm/assets/bg-blurred.png"
M.bg_image = M.bg_blurred_darker

return M