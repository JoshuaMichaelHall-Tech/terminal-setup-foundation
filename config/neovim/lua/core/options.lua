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
