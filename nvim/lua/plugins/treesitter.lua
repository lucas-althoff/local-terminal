return {{
    "nvim-treesitter/nvim-treesitter",
    version = false, -- Atualiza para a última versão sempre, não apenas releases
    build = ":TSUpdate",
    event = {"BufReadPost", "BufNewFile"}, -- Carrega apenas ao abrir um arquivo (Lazy Loading real)
    cmd = {"TSUpdateSync", "TSUpdate", "TSInstall"},
    keys = {{
        "<c-space>",
        desc = "Increment Selection"
    }, {
        "<bs>",
        desc = "Decrement Selection",
        mode = "x"
    }},

    config = function()
        -- Proteção: Verifica se o plugin carregou antes de configurar
        local status_ok, configs = pcall(require, "nvim-treesitter.configs")
        if not status_ok then
            return
        end

        configs.setup({
            ensure_installed = {"lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "bash", "python", "json", "jsonc", "html", "css", "javascript", "typescript"},
            sync_install = false, -- Instala síncrono (bloqueia UI) = false
            auto_install = true, -- Tenta instalar parsers automaticamente

            highlight = {
                enable = true
            },
            indent = {
                enable = true
            }
        })
    end
}}
