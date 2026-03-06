return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = {'nvim-lua/plenary.nvim'},

    config = function()
        local builtin = require('telescope.builtin')
        local telescope = require('telescope')

        -- Configuração segura
        telescope.setup({
            defaults = {
                -- Desativa o previewer do Treesitter se ele estiver quebrado
                preview = {
                    treesitter = false
                },
                file_ignore_patterns = {"node_modules", ".git"}
            }
        })
        local builtin = require('telescope.builtin')
        -- Atalhos: <Espaço> + f + f = Find Files
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        -- Atalhos: <Espaço> + f + g = Find Grep (busca texto dentro de arquivos)
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        -- Atalhos: <Espaço> + f + b = Find Buffers (arquivos abertos)
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    end
}
