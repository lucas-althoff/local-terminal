return {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { -- Motor HTTP isolado, essencial para gerenciar a conexão e o envio de arquivos
    "selimacerbas/live-server.nvim"},
    -- Carregamento sob demanda (Lazy Loading) focado na redução do tempo de inicialização (startup time)
    ft = {"markdown", "md", "mmd", "mermaid"},
    config = function()
        require("markdown_preview").setup({
            -- Configurações padrão; ajuste os valores de acordo com a sua latência desejada
            port = 8421, -- Porta estática do servidor local
            open_browser = true, -- Abre o navegador padrão via chamadas do sistema operacional
            debounce_ms = 300, -- Controle de throttling para evitar saturação de I/O em digitação contínua
            mermaid_renderer = "auto" -- Estratégia de renderização de gráficos ("auto", "rust", ou "browser")
        })
    end,
    -- Atalhos (Opcionais, recomendados para orquestração da visualização)
    keys = {{
        "<leader>mp",
        "<cmd>MarkdownPreview<CR>",
        desc = "Markdown Preview: Iniciar"
    }, {
        "<leader>ms",
        "<cmd>MarkdownPreviewStop<CR>",
        desc = "Markdown Preview: Parar Servidor"
    }, {
        "<leader>mr",
        "<cmd>MarkdownPreviewRefresh<CR>",
        desc = "Markdown Preview: Forçar Atualização"
    }}
}
