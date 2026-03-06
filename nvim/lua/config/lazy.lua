local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {"git", "clone",
            "--filter=blob:none", 
            "https://github.com/folke/lazy.nvim.git", 
            "--branch=stable", -- latest stable release
        lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- Aqui dizemos ao Lazy para carregar os plugins da pasta 'lua/plugins'
require("lazy").setup({
    spec = {{
        import = "plugins"
    } -- Importa tudo dentro de lua/plugins/*
    },
    checker = {
        enabled = true
    } -- Verifica updates automaticamente
})
