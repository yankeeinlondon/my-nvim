return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require "conform"

            conform.setup {
                formatters_by_ft = {
                    javascript = { "prettierd" },
                    typescript = { "prettierd" },
                    json = { "jq" },
                    lua = { "stylua" },
                    sh = { "shfmt" },
                    bash = { "shfmt" },
                    markdown = { "prettier" },
                    python = { "isort", "black" },
                    xml = { "xmlformatter" },
                    yaml = { "yamlfmt" },
                },
                format_on_save = {
                    -- I recommend these options. See :help conform.format for details.
                    lsp_format = "fallback",
                    timeout_ms = 500,
                },
                -- If this is set, Conform will run the formatter asynchronously after save.
                -- It will pass the table to conform.format().
                -- This can also be a function that returns the table.
                format_after_save = {
                    lsp_format = "fallback",
                },
            }

            vim.keymap.set({ "n", "v" }, "<leader>F", function()
                conform.format { lsp_fallback = "fallback", async = false, timeout_ms = 500 }
            end)
        end,
    },
}
