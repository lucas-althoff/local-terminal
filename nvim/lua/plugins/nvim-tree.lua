return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons" -- Necessário para os ícones de pasta/arquivo
    },
    config = function()
        -- Desabilita o explorador padrão do Vim (netrw) para evitar conflitos
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            view = {
                width = 30, -- Largura da janela
                side = "left"
            },
            filters = {
                dotfiles = false -- Mostra arquivos ocultos (começados com .)
            },
            actions = {
                open_file = {
                    quit_on_open = false -- Mantém a árvore aberta ao abrir um arquivo?
                }
            }
        })

        -- Atalho: <Espaço> + e (de Explorer) para abrir/fechar
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {
            desc = "Toggle Explorer"
        })
    end
}
