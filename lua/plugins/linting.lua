return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require "lint"

    lint.linters_by_ft = {
      ansible = { "ansible-lint" },
      javascript = { "eslint" },
      typescript = { "eslint" },
      javascriptreact = { "eslint" },
      typescriptreact = { "eslint" },
      html = { "htmlhint" },
      svelte = { "eslint_d" },
      python = { "pylint" },
      protobuf = { "protolint" },
      markdown = { "markdownlint" },
      nix = { "nix" },
      bash = { "shellcheck" },
      plain = { "vale" },
      text = { "vale" },
      yaml = { "yamllint" }
    }
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd(
      { "BufEnter", "BufWritePost", "InsertLeave" },
      {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      }
    )

    vim.keymap.set("n",
      "<leader>l",
      function()
        lint.try_lint()
      end,
      { desc = "Trigger linting for current file" }
    )

    vim.keymap.set(
      "n",
      "<C+l>",
      function()
        local linters = require("lint").get_running()
        if #linters == 0 then
          return "[]"
        end
        return "[] " .. table.concat(linters, ", ")
      end
    )
  end,
}
