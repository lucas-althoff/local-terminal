-- Define a tecla líder (Leader Key) para Espaço. CRÍTICO fazer isso antes de carregar plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options") -- Carrega as opções básicas
require("config.lazy")    -- Carrega os plugins