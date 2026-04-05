vim.g.mapleader = " "
vim.g.maplocalleader = " "

local config_writable = vim.fn.filewritable(vim.fn.stdpath("config")) == 2
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
vim.opt.clipboard = "unnamedplus"
local lazy = require "lazy"

require "config.mason_tool"

lazy.setup({
  { import = "plugins" },
}, {
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  checker = { enabled = config_writable, notify = false },
  change_detection = { enabled = config_writable }
})
require "options"
require('config.dadbod')
require "config.edit_text"
require "config.keymap_utils"
require "config.keymaps"
require "config.highlight_yank"
require "config.format_on_save"
require "config.toggle_eslint"
require "config.rotate_windows"
require "config.resize_windows"
require "config.vertical_help"
require "config.edit_text"

if os.getenv("SSH_TTY") and vim.fn.has("nvim-0.10") == 1 then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = function()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
      end,
      ["*"] = function()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
      end,
    },
  }
end
