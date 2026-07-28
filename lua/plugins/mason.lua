return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup {
            ui = {
                border = "rounded",
            },
        }
        require("mason-tool-installer").setup {
            ensure_installed = {
                -- LSP servers
                "lua-language-server",
                "vim-language-server",
                "bash-language-server",
                "css-lsp",
                "dockerfile-language-server",
                "html-lsp",
                "json-lsp",
                "markdownlint",
                "pyright",
                "rust-analyzer",
                "svelte-language-server",
                "taplo",
                "typescript-language-server",
                "yaml-language-server",
                -- Formatters (used by conform.nvim)
                "prettierd",
                "stylua",
                "shfmt",
                -- "isort",
                -- "black",
                "yamlfmt",
            },
        }
    end,
}
