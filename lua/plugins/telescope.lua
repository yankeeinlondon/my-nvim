return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- Only try to build if cmake is actually on PATH inside Neovim
        cond = function() return vim.fn.executable("cmake") == 1 end,
        build = function()
          local cmake = vim.fn.exepath("cmake")
          if cmake == "" then
            vim.notify("telescope-fzf-native: cmake not found in PATH", vim.log.levels.ERROR)
            return
          end

          -- fresh build dir (avoid stale cache)
          vim.fn.delete("build", "rf")

          -- Prefer Ninja if present (faster); otherwise default generator
          local args = { cmake, "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" }
          if vim.fn.executable("ninja") == 1 then
            table.insert(args, "-G"); table.insert(args, "Ninja")
          end

          -- Configure
          vim.fn.system(args)
          if vim.v.shell_error ~= 0 then
            vim.notify("telescope-fzf-native: CMake configure failed", vim.log.levels.ERROR)
            return
          end

          -- Build
          vim.fn.system({ cmake, "--build", "build", "--config", "Release" })
          if vim.v.shell_error ~= 0 then
            vim.notify("telescope-fzf-native: CMake build failed", vim.log.levels.ERROR)
            return
          end
        end,
      },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-x>"] = actions.delete_buffer,
            },
          },
          file_ignore_patterns = { "node_modules", "yarn.lock", ".git", ".sl", "_build", ".next" },
          hidden = true,
        },
      })
      -- load fzf if it built
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
}
