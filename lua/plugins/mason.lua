return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-tool-installer").setup {
            ensure_installed = {
                "lua-language-server",
                "vim-language-server",
                "bash-language-server",
                "css-lsp",
                "dockerfile-language-server",
                "html-lsp",
                "json-lsp",
                "julia-lsp",
                "markdownlint",
                "pyright",
                "rust-analyzer",
                "svelte-language-server",
                "taplo",
                "ts_ls",
                "yaml-language-server",
            },
        }
    end,
}
