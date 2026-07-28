vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Detect filetype from shebang for extensionless files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*",
    callback = function(args)
        if vim.bo[args.buf].filetype ~= "" then
            return
        end
        local firstline = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ""
        local shebang = firstline:match "^%s*#!(.*)"
        if not shebang then
            return
        end
        if shebang:match "bash" then
            vim.bo[args.buf].filetype = "bash"
        elseif shebang:match "zsh" then
            vim.bo[args.buf].filetype = "zsh"
        elseif shebang:match "/sh" then
            vim.bo[args.buf].filetype = "sh"
        elseif shebang:match "python" then
            vim.bo[args.buf].filetype = "python"
        end
    end,
})

local config_writable = vim.fn.filewritable(vim.fn.stdpath "config") == 2
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
    lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json",
    checker = { enabled = config_writable, notify = false },
    change_detection = { enabled = config_writable },
})
require "options"
require "config.dadbod"
require "config.edit_text"
require "config.keymap_utils"
require "config.keymaps"
require "config.highlight_yank"
require "config.toggle_eslint"
require "config.rotate_windows"
require "config.resize_windows"
require "config.vertical_help"

local is_ssh = vim.env.SSH_TTY ~= nil
local is_wsl = vim.fn.has "wsl" == 1

if is_ssh and vim.fn.has "nvim-0.10" == 1 then
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy "+",
            ["*"] = require("vim.ui.clipboard.osc52").copy "*",
        },
        paste = {
            ["+"] = function()
                return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" }
            end,
            ["*"] = function()
                return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" }
            end,
        },
    }
elseif is_wsl and vim.fn.executable "win32yank.exe" == 1 then
    vim.g.clipboard = {
        name = "win32yank-wsl",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end

vim.opt.clipboard = "unnamedplus"
