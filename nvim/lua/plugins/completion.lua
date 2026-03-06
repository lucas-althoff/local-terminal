return { -- O Motor de Autocomplete
{
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Só carrega quando você entra em modo de inserção (performance)
    dependencies = { -- Fontes de sugestão
    "hrsh7th/cmp-nvim-lsp", -- Sugestões do LSP
    "hrsh7th/cmp-buffer", -- Sugestões de palavras no arquivo atual
    "hrsh7th/cmp-path", -- Sugestões de caminhos de arquivo/pastas
    -- Motor de Snippets (Obrigatório para o nvim-cmp funcionar)
    "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", -- Conecta o LuaSnip ao nvim-cmp
    "rafamadriz/friendly-snippets", -- Coleção pronta de snippets (como boilerplate de React, main em C, etc)
    -- Ícones (opcional, mas deixa bonito)
    "onsails/lspkind.nvim"},
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        -- Carrega os snippets prontos (VSCode style)
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- Necessário para expandir snippets
                end
            },
            window = {
                completion = cmp.config.window.bordered(), -- Borda arredondada no menu
                documentation = cmp.config.window.bordered()
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(), -- Força abrir o menu
                ["<C-e>"] = cmp.mapping.abort(), -- Fecha o menu

                -- A lógica do ENTER: Confirma a seleção. 
                -- Se nada estiver selecionado, ele apenas dá enter (não seleciona o primeiro item automaticamente para evitar erros)
                ["<CR>"] = cmp.mapping.confirm({
                    select = false
                }),

                -- A lógica do TAB (Super Tab):
                -- Se menu aberto -> vai pro próximo item
                -- Se tem snippet expansível -> expande
                -- Se não -> dá TAB normal
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, {"i", "s"}),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {"i", "s"})
            }),

            -- Ordem de prioridade das fontes
            sources = cmp.config.sources({{
                name = "nvim_lsp"
            }, -- LSP é prioridade máxima
            {
                name = "luasnip"
            }, -- Depois snippets
            {
                name = "buffer"
            }, -- Depois texto do arquivo
            {
                name = "path"
            } -- Por fim, caminhos
            }),

            -- Configuração dos ícones na lista
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol_text',
                    maxwidth = 50,
                    ellipsis_char = '...'
                })
            }
        })
    end
}}
