return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.add({
        -- Group labels
        { "<leader>c", group = "Quickfix" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>l", group = "LSP" },
        { "<leader>o", group = "Open" },
        { "<leader>r", group = "Refactor" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Terminal" },

        -- Standalone keymaps (not defined in keymaps.lua)
        { "<leader>f", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", desc = "Find Files" },
        { "<leader>a", "<cmd>Alpha<cr>", desc = "Alpha" },
        { "<leader>b", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>", desc = "Buffers" },
        { "<leader>P", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },

        -- Git (not in keymaps.lua)
        { "<leader>gB", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
        { "<leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<cr>", desc = "Reset Buffer" },
        { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
        { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
        { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit" },
        { "<leader>gj", "<cmd>lua require('gitsigns').next_hunk()<cr>", desc = "Next Hunk" },
        { "<leader>gk", "<cmd>lua require('gitsigns').prev_hunk()<cr>", desc = "Prev Hunk" },
        { "<leader>gl", "<cmd>lua require('gitsigns').blame_line()<cr>", desc = "Blame Line" },
        { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Changed Files" },
        { "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", desc = "Preview Hunk" },
        { "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", desc = "Reset Hunk" },
        { "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<cr>", desc = "Stage Hunk" },
        { "<leader>gu", "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },

        -- LSP
        { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
        { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
        { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer Diagnostics" },
        { "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", desc = "Format (LSP)" },
        { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP Info" },
        { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" },
        { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
        { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens" },
        { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
        { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },

        -- Search (unique, not in keymaps.lua)
        { "<leader>sC", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
        { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
        { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
        { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },

        -- Terminal
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
        { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal" },
        { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node" },
        { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python" },
        { "<leader>tt", "<cmd>lua _HTOP_TOGGLE()<cr>", desc = "Htop" },
        { "<leader>tu", "<cmd>lua _NCDU_TOGGLE()<cr>", desc = "NCDU" },
        { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical" },
      })
    end,
  }
}
