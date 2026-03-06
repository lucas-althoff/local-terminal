local wezterm = require 'wezterm'
local M = {}

M.fonts = {
  main = wezterm.font_with_fallback {
    { family = 'JetBrainsMono Nerd Font', weight = 'Regular' },
    'Cascadia Code NF',
    'Consolas',
  },
  size = 10,
}

M.window = {
  opacity = 0.70,
  backdrop = 'Acrylic',
  padding = { left = 12, right = 12, top = 12, bottom = 12 },
  decorations = "RESIZE",
  scrollbar = true,
}

M.tab_bar = {
  position = "top",
  hide_if_single = false,
  fancy = true,
}

return M
