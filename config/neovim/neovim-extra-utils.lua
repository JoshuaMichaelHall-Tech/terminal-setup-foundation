-- Path: ~/.config/nvim/lua/plugins/extra_utils.lua

return {
  -- Enhanced * motions
  {
    "haya14busa/vim-asterisk",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "*", "<Plug>(asterisk-z*)", { silent = true })
      vim.keymap.set("n", "#", "<Plug>(asterisk-z#)", { silent = true })
      vim.keymap.set("n", "g*", "<Plug>(asterisk-gz*)", { silent = true })
      vim.keymap.set("n", "g#", "<Plug>(asterisk-gz#)", { silent = true })
    end,
  },

  -- Shows indentation levels
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { 
        char = "│", 
        tab_char = "│" 
      },
      scope = { enabled = true },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- Add colorizer for color codes
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        "*", -- Highlight all files, but customize some others.
        css = { rgb_fn = true }, -- Enable parsing rgb() functions in css.
        html = { names = false }, -- Disable parsing "names" like Blue or Gray
      })
    end,
  },

  -- Todo highlighting
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        -- Configuration options
        signs = true, -- show icons in the signs column
        sign_priority = 8, -- sign priority
        -- keywords recognized as todo comments
        keywords = {
          FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        -- highlighting of the line containing the todo comment
        -- * before: highlights before the keyword (typically comment characters)
        -- * keyword: highlights of the keyword
        -- * after: highlights after the keyword (todo text)
        highlight = {
          before = "", -- "fg" or "bg" or empty
          keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
          after = "fg", -- "fg" or "bg" or empty
          pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
          comments_only = true, -- uses treesitter to match keywords in comments only
          max_line_len = 400, -- ignore lines longer than this
          exclude = {}, -- list of file types to exclude highlighting
        },
        -- list of named colors where we can use the color name instead of hex codes
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
          warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
          info = { "DiagnosticInfo", "#2563EB" },
          hint = { "DiagnosticHint", "#10B981" },
          default = { "Identifier", "#7C3AED" },
          test = { "Identifier", "#FF00FF" },
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          -- regex that will be used to match keywords.
          -- don't replace the (KEYWORDS) placeholder
          pattern = [[\b(KEYWORDS):]], -- ripgrep regex
          -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        },
      })

      -- Keymaps for todo-comments
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })

      vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Search todos" })
    end,
  },

  -- Automatically adjust shiftwidth and expandtab
  {
    "tpope/vim-sleuth",
  },

  -- Improved movement (f, t, etc.)
  {
    "ggandor/leap.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- Better buffer delete
  {
    "famiu/bufdelete.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<CR>", { desc = "Delete buffer" })
    end,
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize" },
    },
    config = function(_, opts)
      require("persistence").setup(opts)
      
      vim.keymap.set("n", "<leader>ps", function()
        require("persistence").load()
      end, { desc = "Restore session for current dir" })
      
      vim.keymap.set("n", "<leader>pl", function()
        require("persistence").load({ last = true })
      end, { desc = "Restore last session" })
      
      vim.keymap.set("n", "<leader>pd", function()
        require("persistence").stop()
      end, { desc = "Don't save current session" })
    end,
  },

  -- Trouble diagnostics viewer
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      position = "bottom",
      icons = true,
      mode = "workspace_diagnostics",
      severity = nil,
      fold_open = "",
      fold_closed = "",
      group = true,
      padding = true,
      cycle_results = true,
      action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = { "<cr>", "<tab>" },
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        close_folds = { "zM", "zm" },
        open_folds = { "zR", "zr" },
        toggle_fold = { "zA", "za" },
        previous = "k",
        next = "j",
      },
      auto_jump = {},
      use_diagnostic_signs = true,
    },
    config = function(_, opts)
      require("trouble").setup(opts)
      
      -- Keymaps
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
      vim.keymap.set("n", "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
      vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Location list" })
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix list" })
      vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP references" })
    end,
  },

  -- Better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      auto_enable = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
      },
      func_map = {
        vsplit = "",
        ptogglemode = "z,",
        stoggleup = "",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
  },

  -- Neovim measurements
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    opts = {
      detection_methods = { "pattern" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
      ignore_lsp = {},
      exclude_dirs = {},
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = "global",
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
      
      vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Find projects" })
    end,
  },

  -- Neovim UI enhancer
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        default_prompt = "➤ ",
        title_pos = "left",
        insert_only = true,
        start_in_insert = true,
        border = "rounded",
        relative = "cursor",
        prefer_width = 40,
        width = nil,
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },
        buf_options = {},
        win_options = {
          winblend = 10,
          wrap = false,
        },
        mappings = {
          n = {
            ["<Esc>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<Up>"] = "HistoryPrev",
            ["<Down>"] = "HistoryNext",
          },
        },
        override = function(conf)
          return conf
        end,
        get_config = nil,
      },
      select = {
        enabled = true,
        backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
        trim_prompt = true,
        telescope = nil,
        fzf = {
          window = {
            width = 0.5,
            height = 0.4,
          },
        },
        nui = {
          position = "50%",
          size = nil,
          relative = "editor",
          border = {
            style = "rounded",
          },
          buf_options = {
            swapfile = false,
            filetype = "DressingSelect",
          },
          win_options = {
            winblend = 10,
          },
          max_width = 80,
          max_height = 40,
          min_width = 40,
          min_height = 10,
        },
        builtin = {
          border = "rounded",
          relative = "editor",
          buf_options = {},
          win_options = {
            winblend = 10,
          },
          width = nil,
          max_width = { 140, 0.8 },
          min_width = { 40, 0.2 },
          height = nil,
          max_height = 0.9,
          min_height = { 10, 0.2 },
          mappings = {
            ["<Esc>"] = "Close",
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          override = function(conf)
            return conf
          end,
        },
        format_item_override = {},
        get_config = nil,
      },
    },
  },

  -- Better folds
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    opts = {
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = {"imports", "comment"},
        json = {"array"},
        yaml = {"sequence"},
      },
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            
            break
          end
          
          curWidth = curWidth + chunkWidth
        end
        
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
      
      opts.fold_virt_text_handler = handler
      require("ufo").setup(opts)
      
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Hover or peek fold" })
    end,
  },

  -- Auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  -- Highlighting for Ruby/Rails development
  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby", "haml", "slim" },
  },

  -- Support for RSpec
  {
    "thoughtbot/vim-rspec",
    ft = { "ruby" },
    config = function()
      vim.g.rspec_command = "!bundle exec rspec {spec}"
      
      vim.keymap.set("n", "<leader>rt", ":call RunCurrentSpecFile()<CR>", { desc = "Run all specs in file" })
      vim.keymap.set("n", "<leader>rs", ":call RunNearestSpec()<CR>", { desc = "Run nearest spec" })
      vim.keymap.set("n", "<leader>rl", ":call RunLastSpec()<CR>", { desc = "Run last spec" })
      vim.keymap.set("n", "<leader>ra", ":call RunAllSpecs()<CR>", { desc = "Run all specs" })
    end,
  },

  -- Python support
  {
    "Vimjas/vim-python-pep8-indent",
    ft = { "python" },
  },

  -- Python docstrings
  {
    "heavenshell/vim-pydocstring",
    ft = { "python" },
    build = "make install",
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle markdown preview" })
    end,
  },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function(_, opts)
      require("luasnip").setup(opts)
      
      vim.keymap.set({"i"}, "<C-K>", function() require("luasnip").expand() end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-L>", function() require("luasnip").jump(1) end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-J>", function() require("luasnip").jump(-1) end, {silent = true})
      
      vim.keymap.set({"i", "s"}, "<C-E>", function()
        if require("luasnip").choice_active() then
          require("luasnip").change_choice(1)
        end
      end, {silent = true})
    end,
  },

  -- Registers viewer
  {
    "tversteeg/registers.nvim",
    cmd = "Registers",
    opts = {
      window = {
        max_width = 100,
        highlight_cursorline = true,
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("registers").setup(opts)
      vim.keymap.set("n", '"', "<cmd>Registers<CR>", { desc = "Show registers" })
    end,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "BufReadPost",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "sine",
        pre_hook = nil,
        post_hook = nil,
      })
    end,
  },

  -- Vim-tmux integration
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- Ruby block navigation
  {
    "nelstrom/vim-textobj-rubyblock",
    dependencies = { "kana/vim-textobj-user" },
    ft = { "ruby" },
  },
}
