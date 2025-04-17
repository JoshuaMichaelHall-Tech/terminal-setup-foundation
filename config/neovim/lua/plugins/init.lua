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

-- Performance options for lazy.nvim
local lazy_options = {
  defaults = {
    lazy = true, -- Default to lazy-loading plugins
    version = false, -- Use latest stable release
  },
  install = {
    colorscheme = { "onedark" }, -- Install colorscheme
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  change_detection = {
    notify = false, -- Disable notifications on config change
  },
}

-- Load all plugin modules
return require("lazy").setup({
  -- Core experience
  { import = "plugins.ui" },           -- UI components and colorscheme
  { import = "plugins.treesitter" },   -- Syntax highlighting and code parsing
  { import = "plugins.lsp" },          -- Language Server Protocol
  { import = "plugins.completion" },   -- Auto-completion
  
  -- Navigation and file management
  { import = "plugins.telescope" },    -- Fuzzy finding and search
  { import = "plugins.navigation" },   -- File explorer and navigation

  -- Version control
  { import = "plugins.git" },          -- Git integration

  -- UX improvements
  { import = "plugins.ux_enhancements" }, -- General UX improvements
  { import = "plugins.terminal" },     -- Terminal integration
  
  -- Extra utilities
  { import = "plugins.extra_utils" },  -- Additional utilities
  
  -- Language-specific plugins
  { import = "plugins.lang.python" },  -- Python development
  { import = "plugins.lang.javascript" }, -- JavaScript/TypeScript
  { import = "plugins.lang.ruby" },    -- Ruby development
  { import = "plugins.lang.web" },     -- Web development
  { import = "plugins.lang.data" },    -- Data analysis

  -- Tmux integration
  { import = "plugins.tmux" },         -- Tmux integration
}, lazy_options)