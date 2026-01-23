-- lua/config/quiet_start.lua
local orig = vim.notify
local quiet = true

-- buffer or drop notifications until we're ready
vim.notify = function(...)
  if quiet then
    -- comment the next line to *drop* startup notifies instead of buffering
    -- (keeping them means you'll still see them, just after UI load)
    return
  end
  return orig(...)
end

-- flip quiet off after plugins/UI are settled. Prefer the VeryLazy event if you use lazy.nvim.
vim.api.nvim_create_autocmd({ "UIEnter" }, {
  once = true,
  callback = function()
    quiet = false
  end,
})
