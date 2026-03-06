return {{
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Formatar Arquivo" },
    },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_format", "ruff_organize_imports" },
            json = { "biome" },
            jsonc = { "biome" },
            javascript = { "biome" },
            typescript = { "biome" },
            css = { "biome" },
        },
        format_on_save = {
            timeout_ms = 3000,
            lsp_fallback = true,
        },
    },
}, {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
        ensure_installed = { "stylua", "ruff", "biome" },
    },
}}