return {
    "barrett-ruth/live-server.nvim",
    build = "npm install -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
    ft = { "html" },
    keys = {
        { "<leader>ls", "<cmd>LiveServerStart<CR>", desc = "Live Server: Iniciar" },
        { "<leader>lx", "<cmd>LiveServerStop<CR>", desc = "Live Server: Parar" },
        { "<leader>lt", "<cmd>LiveServerToggle<CR>", desc = "Live Server: Toggle" },
    },
    opts = {},
}