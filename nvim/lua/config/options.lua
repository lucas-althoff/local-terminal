-- ~/.config/nvim/lua/config/options.lua

-- Numeração Híbrida
vim.opt.number = true         -- Mostra o número real na linha onde o cursor está
vim.opt.relativenumber = true -- Mostra a distância relativa nas outras linhas

-- Outras opções visuais úteis para navegação
vim.opt.scrolloff = 25        -- Mantém sempre 25 linhas de margem ao rolar (o cursor nunca fica colado no topo/fundo)
vim.opt.signcolumn = "yes"    -- Mantém a coluna lateral fixa (evita que o texto pule quando o GitSigns ou LSP mostram ícones)
vim.opt.cursorline = true     -- Destaca a linha inteira onde o cursor está (ajuda a se localizar rápido)