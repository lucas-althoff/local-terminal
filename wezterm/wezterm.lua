local wezterm = require 'wezterm'
local utils = require 'lua.utils'
local theme = require 'lua.theme'
local keys = require 'lua.keybindings'
local commands = require 'lua.commands'

local config = wezterm.config_builder()

-- Janela
config.initial_cols = 100
config.initial_rows = 28
config.window_padding = theme.formatting.window.padding
config.window_decorations = theme.formatting.window.decorations

-- Efeito Acrílico (Windows 11)
config.window_background_opacity = theme.formatting.window.opacity
config.win32_system_backdrop = theme.formatting.window.backdrop
config.enable_scroll_bar = theme.formatting.window.scrollbar

-- Fonte
config.font = theme.formatting.fonts.main
config.font_size = theme.formatting.fonts.size

-- Tema: Tokyo Night
config.color_scheme = theme.colorscheme.get()

-- Cores personalizadas
config.colors = {
    scrollbar_thumb = '#caacfb'
}

-- Tab bar
config.hide_tab_bar_if_only_one_tab = theme.formatting.tab_bar.hide_if_single
config.tab_bar_at_bottom = (theme.formatting.tab_bar.position == "bottom")
config.use_fancy_tab_bar = theme.formatting.tab_bar.fancy

-- Atalhos
config.keys = keys.keys

-- Comandos no palette
commands.setup()

-- Shell (Windows)
if wezterm.target_triple:find("windows") then
    config.default_prog = utils.shell.get_best_shell()
end

-- Diretório padrão
config.default_cwd = wezterm.home_dir

return config
