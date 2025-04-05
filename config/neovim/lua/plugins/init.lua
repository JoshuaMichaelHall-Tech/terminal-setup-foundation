local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugin modules
return require("lazy").setup({
  -- Load individual plugin modules
  { import = "plugins.lsp" },
  { import = "plugins.telescope" },
  { import = "plugins.treesitter" },
  { import = "plugins.navigation" },
  { import = "plugins.ui" },
  { import = "plugins.git" },
  { import = "plugins.ux_enhancements" },
  { import = "plugins.extra_utils" },
})
