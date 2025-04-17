-- Enhanced terminal configuration for Neovim

return {
  -- Terminal integration with toggleterm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          else
            return 20
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved", -- 'single' | 'double' | 'shadow' | 'curved'
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
          width = function()
            return math.floor(vim.o.columns * 0.85)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.8)
          end,
        },
        highlights = {
          FloatBorder = {
            link = "FloatBorder",
          },
          NormalFloat = {
            link = "Normal",
          },
        },
      })

      -- Custom terminal setup functions
      local Terminal = require("toggleterm.terminal").Terminal

      -- Lazygit terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
          width = function()
            return math.floor(vim.o.columns * 0.9)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.9)
          end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      -- Python REPL terminal
      local python = Terminal:new({
        cmd = "python",
        hidden = true,
        direction = "horizontal",
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      -- Node.js REPL terminal
      local node = Terminal:new({
        cmd = "node",
        hidden = true,
        direction = "horizontal",
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      -- htop terminal
      local htop = Terminal:new({
        cmd = "htop",
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      -- Configure terminal functions
      function _G.toggle_lazygit()
        lazygit:toggle()
      end

      function _G.toggle_python()
        python:toggle()
      end

      function _G.toggle_node()
        node:toggle()
      end

      function _G.toggle_htop()
        htop:toggle()
      end

      -- Run selected code in terminal
      function _G.run_code_in_term()
        local filetype = vim.bo.filetype
        local command = ""
        
        -- Get visual selection
        local visual_start = vim.fn.getpos("'<")
        local visual_end = vim.fn.getpos("'>")
        local lines = vim.fn.getline(visual_start[2], visual_end[2])
        
        -- Adjust the first and last line to account for partial selections
        if #lines > 0 then
          if vim.fn.mode() == "v" then
            lines[1] = string.sub(lines[1], visual_start[3], -1)
            lines[#lines] = string.sub(lines[#lines], 1, visual_end[3])
          end
        end
        
        local selected_text = table.concat(lines, "\n")
        
        -- Create temp file
        local temp_file = vim.fn.tempname()
        local file = io.open(temp_file, "w")
        if file then
          file:write(selected_text)
          file:close()
        else
          print("Failed to create temporary file.")
          return
        end
        
        -- Determine command based on filetype
        if filetype == "python" then
          command = "python " .. temp_file
        elseif filetype == "javascript" or filetype == "typescript" then
          command = "node " .. temp_file
        elseif filetype == "ruby" then
          command = "ruby " .. temp_file
        elseif filetype == "sh" or filetype == "bash" or filetype == "zsh" then
          command = "bash " .. temp_file
        elseif filetype == "lua" then
          command = "lua " .. temp_file
        else
          print("Unsupported filetype: " .. filetype)
          os.remove(temp_file)
          return
        end
        
        -- Create and configure terminal
        local run_terminal = Terminal:new({
          cmd = command,
          close_on_exit = false,
          direction = "horizontal",
          on_exit = function()
            os.remove(temp_file)
          end,
        })
        
        run_terminal:toggle()
      end

      -- Set up key mappings
      vim.api.nvim_set_keymap("n", "<leader>tg", "<cmd>lua toggle_lazygit()<CR>", { noremap = true, silent = true, desc = "Toggle Lazygit" })
      vim.api.nvim_set_keymap("n", "<leader>tp", "<cmd>lua toggle_python()<CR>", { noremap = true, silent = true, desc = "Toggle Python REPL" })
      vim.api.nvim_set_keymap("n", "<leader>tn", "<cmd>lua toggle_node()<CR>", { noremap = true, silent = true, desc = "Toggle Node.js REPL" })
      vim.api.nvim_set_keymap("n", "<leader>th", "<cmd>lua toggle_htop()<CR>", { noremap = true, silent = true, desc = "Toggle htop" })
      vim.api.nvim_set_keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { noremap = true, silent = true, desc = "Toggle floating terminal" })
      vim.api.nvim_set_keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { noremap = true, silent = true, desc = "Toggle vertical terminal" })
      vim.api.nvim_set_keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { noremap = true, silent = true, desc = "Toggle horizontal terminal" })
      vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true, desc = "Toggle terminal" })
      vim.api.nvim_set_keymap("v", "<leader>tr", "<cmd>lua run_code_in_term()<CR>", { noremap = true, silent = true, desc = "Run selected code in terminal" })

      -- Terminal window navigation function
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      -- Auto command to set terminal key mappings when opening terminal
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      -- Highlight group to match your color scheme
      vim.cmd("highlight link TermCursor Cursor")
      vim.cmd("highlight link TermCursorNC CursorLine")
    end,
  },

  -- Enhanced REPL integration
  {
    "hkupty/iron.nvim",
    event = "VeryLazy",
    config = function()
      local iron = require("iron.core")
      
      iron.setup({
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "zsh" },
            },
            python = {
              command = { "ipython" },
              format = require("iron.fts.common").bracketed_paste,
            },
            javascript = {
              command = { "node" },
            },
            ruby = {
              command = { "irb" },
            },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require("iron.view").bottom(12),
          highlights = {
            italic = true,
            bold = true,
            undercurl = true,
          },
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_motion = "<leader>rc",
          visual_send = "<leader>rc",
          send_file = "<leader>rf",
          send_line = "<leader>rl",
          send_mark = "<leader>rm",
          mark_motion = "<leader>rmc",
          mark_visual = "<leader>rmc",
          remove_mark = "<leader>rmd",
          cr = "<leader>r<cr>",
          interrupt = "<leader>r<space>",
          exit = "<leader>rq",
          clear = "<leader>rx",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
      })
    end,
  },

  -- Add automatic terminal to Telescope
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      local trouble = require("trouble.providers.telescope")
      local telescope = require("telescope")
      
      -- Add terminal picker to Telescope
      telescope.setup({
        extensions = {
          toggleterm = {
            -- Show the terminal number in the picker
            show_number = true,
            -- Highlight picker in different colors based on terminal type
            highlight_terminals = true,
            -- Display terminal title in the picker
            display_title = true,
          },
        },
      })
      
      telescope.load_extension("toggleterm")
      
      -- Add keymaps
      vim.keymap.set(
        "n",
        "<leader>ft",
        "<cmd>Telescope toggleterm<cr>",
        { desc = "Find terminal" }
      )
    end,
  },

  -- Vim Tmux Navigator - seamless navigation between Neovim splits and tmux panes
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
    },
  },
}