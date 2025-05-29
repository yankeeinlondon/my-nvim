vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.api.nvim_set_option("clipboard", "unnamedplus")
local lazy = require "lazy"

require "config.mason_tool"

lazy.setup({
  { import = "plugins" },
}, {
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
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
