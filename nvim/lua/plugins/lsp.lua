return {
{
    "williamboman/mason.nvim",
    dependencies = {"williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig", "b0o/schemastore.nvim"},
    -- ... dentro do config function do mason ...
    config = function()
        require("mason").setup()
        
        -- 1. PEGAR AS CAPACIDADES DO CMP
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "pyright", "jsonls", "html", "cssls", "emmet_ls" },
            handlers = {
                function(server_name)
                    -- 2. PASSAR ELAS PARA CADA SERVIDOR
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities 
                    })
                end,
                
                ["jsonls"] = function()
                    require("lspconfig").jsonls.setup({
                        capabilities = capabilities,
                        settings = {
                            json = {
                                schemas = require("schemastore").json.schemas(),
                                validate = { enable = true },
                            },
                        },
                    })
                end,

                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = capabilities, -- Não esqueça aqui também!
                        settings = {
                            Lua = {
                                diagnostics = { globals = { "vim" } }
                            }
                        }
                    })
                end,
            }
        })
    end
}}
