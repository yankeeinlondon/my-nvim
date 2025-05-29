return {
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup {
        init = function()
          require("hover.providers.lsp")
          require("hover.providers.fold_preview")
          require("hover.providers.diagnostic")
          require("hover.providers.man")
          require("hover.providers.dictionary")
        end,
        preview_opts = {
          border = 'single'
        },
        -- whether to contents of a currently open hover window should
        -- be moved to a :h preview-window when pressing the hover keymap
        preview_window = false,
        title = true,
        mouse_providers = {
          'LSP'
        },
        mouse_delay = 1000,
      }

      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
      vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
      vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, { desc = "previous source" })
      vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, { desc = "next source" })
    end
  }
}
