return {{
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Carrega primeiro para garantir que o UI não pisque
    config = function()
        -- O que rodar quando o plugin carregar
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            transparent_background = true -- Útil para terminais com fundo customizado
        })
        vim.cmd.colorscheme("catppuccin")
    end
}}
