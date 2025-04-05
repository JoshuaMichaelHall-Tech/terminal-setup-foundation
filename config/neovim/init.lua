-- init.lua
-- Load core modules
require('core.options')
require('core.keymaps')
require('core.autocmds')

-- Global variables
vim.g.autoformat = false -- Set to true to enable auto-formatting on save

-- Load plugins
require('plugins')

-- Load utilities
require('utils')

-- Load custom modules
if vim.fn.exists('$TMUX') == 1 then
  require('plugins.custom.tmux')
end

-- Colorscheme setup
vim.cmd('colorscheme onedark')

-- Commands
vim.api.nvim_create_user_command('ToggleAutoFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  print("Auto format on save: " .. tostring(vim.g.autoformat))
end, {})
