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
