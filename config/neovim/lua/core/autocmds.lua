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
