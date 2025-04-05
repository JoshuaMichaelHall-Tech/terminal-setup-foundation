-- init.lua
-- Path: ~/.config/nvim/init.lua
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

-- =======================================================================
-- Path: ~/.config/nvim/lua/core/options.lua

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Consider dash as part of word
opt.iskeyword:append("-")

-- Persistent undo
opt.undofile = true

-- Update time
opt.updatetime = 100

-- Scroll offset
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Better completion experience
opt.completeopt = "menu,menuone,noselect"

-- Fold settings (used with nvim-ufo)
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "0"

-- Time out on key codes but not mappings
opt.timeout = true
opt.timeoutlen = 300

-- Decrease redraw time
opt.redrawtime = 1500
opt.lazyredraw = true

-- Better buffer management
opt.hidden = true

-- Better UI
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 10

-- More space for messages
opt.cmdheight = 1

-- Don't show mode in command line (shown by lualine)
opt.showmode = false

-- Always show tabline
opt.showtabline = 2

-- Shorter messages
opt.shortmess:append("c")

-- Better diffing
opt.diffopt:append("algorithm:patience")
opt.diffopt:append("indent-heuristic")
opt.diffopt:append("linematch:60")

-- History and session settings
opt.history = 500

-- Mouse support in all modes
opt.mouse = "a"

-- File formats
opt.fileformats = "unix,dos,mac"

-- Use ripgrep if available
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Sane wild menu
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore:append("*/node_modules/*")
opt.wildignore:append("*/vendor/*")
opt.wildignore:append("*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store")
opt.wildignore:append("*.o,*.obj,*.bin,*.dll,*.exe")
opt.wildignore:append("*.jpg,*.jpeg,*.gif,*.png,*.pdf,*.ds_store,*.zip")
opt.wildignore:append("*~,*.swp,*.tmp")

-- Better formatting options
opt.formatoptions = opt.formatoptions
  - "t" -- Don't auto-wrap text
  + "c" -- Auto-wrap comments
  + "q" -- Allow formatting of comments with 'gq'
  - "a" -- Don't auto-format
  + "n" -- Recognize numbered lists
  + "j" -- Remove comment leader when joining lines
  - "2" -- Use indent of second line for paragraph
  + "r" -- Continue comments after return
  + "o" -- Continue comments with o/O

-- Disable some providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- =======================================================================
-- Path: ~/.config/nvim/lua/core/keymaps.lua

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- General keymaps
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "x", '"_x', { desc = "Delete single character without copying into register" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" })

-- Move text up and down
keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when scrolling
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Keep cursor centered when searching
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- Keep cursor position when joining lines
keymap.set("n", "J", "mzJ`z", opts)

-- Better indenting
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Paste over selection without copying
keymap.set("v", "p", '"_dP', opts)

-- Copy to system clipboard
keymap.set({"n", "v"}, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

-- Delete without yanking
keymap.set({"n", "v"}, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Visual mode text manipulation
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Better navigation
keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Prev quickfix item" })
keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location item" })
keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev location item" })

-- Buffer navigation
keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<leader>bb", ":b#<CR>", { desc = "Last buffer" })
keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer" })

-- Terminal mappings
keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)
keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)

-- LSP mappings (will be loaded in lsp.lua with on_attach)

-- File operations
keymap.set("n", "<leader>fs", ":w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>fS", ":wa<CR>", { desc = "Save all files" })
keymap.set("n", "<leader>fq", ":q<CR>", { desc = "Quit" })
keymap.set("n", "<leader>fQ", ":qa!<CR>", { desc = "Quit without saving" })
keymap.set("n", "<leader>fx", ":x<CR>", { desc = "Save and quit" })

-- Other useful mappings
keymap.set("n", "<leader>ch", ":checkhealth<CR>", { desc = "Check health" })
keymap.set("n", "<leader>cm", ":Mason<CR>", { desc = "Mason" })
keymap.set("n", "<leader>cl", ":Lazy<CR>", { desc = "Lazy" })

-- Resize windows
keymap.set("n", "<C-Up>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Replace the word under cursor
keymap.set("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word under cursor" })

-- Make file executable
keymap.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable", silent = true })

-- Source current file
keymap.set("n", "<leader>so", ":so %<CR>", { desc = "Source current file" })

-- Move through wrapped lines
keymap.set("n", "j", "gj", opts)
keymap.set("n", "k", "gk", opts)

-- Better command line editing
keymap.set("c", "<C-A>", "<Home>", { noremap = true })
keymap.set("c", "<C-E>", "<End>", { noremap = true })
keymap.set("c", "<C-K>", "<C-\\>e strpart(getcmdline(), 0, getcmdpos()-1)<CR>", { noremap = true })

-- Tmux integration
keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Launch tmux sessionizer" })

-- =======================================================================
-- Path: ~/.config/nvim/lua/core/autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
local yankGroup = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = yankGroup,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 300,
    })
  end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})

-- Don't auto comment new lines
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Set indentation for specific file types
autocmd("FileType", {
  pattern = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "yaml" },
  command = "setlocal tabstop=2 shiftwidth=2 expandtab",
})

autocmd("FileType", {
  pattern = { "python", "ruby", "java" },
  command = "setlocal tabstop=4 shiftwidth=4 expandtab",
})

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain filetypes with just q
autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
    "neotest-output",
    "neotest-summary",
    "toggleterm",
    "fugitive",
    "git",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Reload file when it changed outside of neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  pattern = "*",
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Set up tmux integration
autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    -- Only load if we're in tmux
    if vim.fn.exists('$TMUX') == 1 then
      require("plugins.custom.tmux").setup()
    end
  end,
})

-- Specific filetypes

-- Ruby specific settings
autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.commentstring = '# %s'
    
    -- Add ruby template markers
    vim.keymap.set("i", "<% ", "<% %><Left><Left><Left>", { buffer = true })
    vim.keymap.set("i", "<%= ", "<%= %><Left><Left><Left>", { buffer = true })
  end,
})

-- Python specific settings
autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.commentstring = '# %s'
    
    -- Add Python docstring template
    vim.keymap.set("i", '"""', '"""<CR><CR>"""<Up>', { buffer = true })
  end,
})

-- Markdown specific settings
autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 0
  end,
})

-- Terminal settings
autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

-- Disable diagnostics in node_modules
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/node_modules/*",
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Auto format on save if desired
if vim.g.autoformat then
  autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
  })
end

-- =======================================================================
-- Path: ~/.config/nvim/lua/utils/init.lua

local M = {}

-- Function to check if a file exists
M.file_exists = function(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- Function to load a module safely
M.safe_require = function(module)
  local status, result = pcall(require, module)
  if status then
    return result
  else
    vim.notify("Error loading " .. module .. ": " .. result, vim.log.levels.ERROR)
    return nil
  end
end

return M
