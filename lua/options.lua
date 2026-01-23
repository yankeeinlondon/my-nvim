-- Enable relative line numbers
vim.opt.nu            = true
vim.opt.rnu           = true

-- Set tabs to 2 spaces
vim.opt.tabstop       = 2
vim.opt.softtabstop   = 2
vim.opt.expandtab     = true

-- Enable auto indenting and set it to spaces
vim.opt.smartindent   = true
vim.opt.shiftwidth    = 2

-- Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
vim.opt.breakindent   = true

-- Enable incremental searching
vim.opt.incsearch     = true
vim.opt.hlsearch      = true

-- Disable text wrap
vim.opt.wrap          = false

-- Set leader key to space
vim.g.mapleader       = " "
vim.g.maplocalleader  = " "

-- Better splitting
vim.opt.splitbelow    = true
vim.opt.splitright    = true

-- Enable mouse mode
vim.opt.mouse         = "a"

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase    = true
vim.opt.smartcase     = true

-- Decrease updatetime to 200ms
vim.opt.updatetime    = 50

-- Set completeopt to have a better completion experience
vim.opt.completeopt   = { "menuone", "noselect" }

-- Enable persistent undo history
vim.opt.undofile      = true

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Enable the sign column to prevent the screen from jumping
vim.opt.signcolumn    = "yes"

-- Enable access to System Clipboard
-- vim.opt.clipboard = "unnamed,unnamedplus"
-- local function is_ssh()
-- 	return os.getenv("SSH_CONNECTION") ~= nil
-- end

local env             = vim.env
local is_ssh          = (env.SSH_TTY ~= nil) or (env.SSH_CONNECTION ~= nil) or (env.TERMUX_VERSION ~= nil)
local is_tmux         = (env.TMUX ~= nil)
local has_gui         = (env.DISPLAY ~= nil) or (env.WAYLAND_DISPLAY ~= nil) or
    (env.NVIM_QT_RUNTIME_PATH ~= nil) -- heuristics

local ok_osc, osc     = pcall(function()
  return require('vim.ui.clipboard.osc52') -- Neovim ≥ 0.10 preferred path
end)
if not ok_osc then
  ok_osc, osc = pcall(function()
    return require('vim.clipboard.osc52') -- some builds expose this path
  end)
end

if is_ssh and ok_osc then
  -- In SSH sessions, prefer OSC52 copy-only to push yanks to the *local terminal* clipboard.
  -- Copy-only avoids terminals that block paste-query (common on iPad terminals).
  vim.g.clipboard = {
    name  = 'osc52-copy-only',
    copy  = { ['+'] = osc.copy, ['*'] = osc.copy },
    paste = {
      ['+'] = function() return { {}, 'v' } end, -- return empty to skip paste-query
      ['*'] = function() return { {}, 'v' } end,
    },
  }

  -- Route normal yanks through +/* like your existing setup
  vim.opt.clipboard = 'unnamed,unnamedplus'

  -- Optional: mirror plain 'y' into + so you don’t have to use "+y
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
        local reg = vim.v.register
        vim.fn.setreg('+', vim.fn.getreg(reg), vim.fn.getregtype(reg))
        vim.fn.setreg('*', vim.fn.getreg(reg), vim.fn.getregtype(reg))
      end
    end,
  })
else
  -- Local machine (GUI clipboard available) or OSC52 module not present:
  -- keep your existing behavior
  vim.g.clipboard = nil
  vim.opt.clipboard = 'unnamed,unnamedplus'
end



-- Function to get the operating system name
local function get_os_name()
  local handle = io.popen("uname")
  local result = handle:read("*a")
  handle:close()
  return result:match("^%s*(.-)%s*$") -- Trim whitespace
end

-- if is_ssh() and get_os_name() == "Linux" then
--   vim.g.clipboard = {
--     name = 'osc52',
--     copy = {
--       ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--       ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--     },
--     paste = {
--       ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--       ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--     },
--   }
-- end

-- vim.clipboard = "unnamedplus"

-- Enable cursor line highlight
vim.opt.cursorline = true

-- Set fold settings
-- These options were reccommended by nvim-ufo
-- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Place a column line
vim.opt.colorcolumn = "80"

-- Always show the sign column
vim.opt.signcolumn = "yes"

-- Disable vim-kitty-navigator default mappings
-- vim.g.kitty_navigator_no_mappings = 1

vim.opt.guicursor = {
  "n-v-c:block",                                  -- Normal, visual, command-line: block cursor
  "i-ci-ve:ver25",                                -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
  "r-cr:hor20",                                   -- Replace, command-line replace: horizontal bar cursor with 20% height
  "o:hor50",                                      -- Operator-pending: horizontal bar cursor with 50% height
  "a:blinkwait700-blinkoff400-blinkon250",        -- All modes: blinking settings
  "sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
}
