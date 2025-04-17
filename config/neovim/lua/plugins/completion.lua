-- Advanced completion configuration
return {
  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          
          -- Add Launch School specific snippets
          require("luasnip").add_snippets("ruby", {
            require("luasnip").snippet(
              "def", 
              {
                require("luasnip").text_node("def "),
                require("luasnip").insert_node(1, "method_name"),
                require("luasnip").text_node("("),
                require("luasnip").insert_node(2),
                require("luasnip").text_node(")\n  "),
                require("luasnip").insert_node(0),
                require("luasnip").text_node("\nend"),
              }
            ),
            require("luasnip").snippet(
              "class",
              {
                require("luasnip").text_node("class "),
                require("luasnip").insert_node(1, "ClassName"),
                require("luasnip").text_node("\n  "),
                require("luasnip").insert_node(0),
                require("luasnip").text_node("\nend"),
              }
            ),
          })
          
          -- Python snippets
          require("luasnip").add_snippets("python", {
            require("luasnip").snippet(
              "def",
              {
                require("luasnip").text_node("def "),
                require("luasnip").insert_node(1, "function_name"),
                require("luasnip").text_node("("),
                require("luasnip").insert_node(2, "self"),
                require("luasnip").text_node("):\n    \"\"\""),
                require("luasnip").insert_node(3, "Docstring"),
                require("luasnip").text_node("\"\"\"\n    "),
                require("luasnip").insert_node(0),
              }
            ),
            require("luasnip").snippet(
              "class",
              {
                require("luasnip").text_node("class "),
                require("luasnip").insert_node(1, "ClassName"),
                require("luasnip").text_node(":\n    \"\"\""),
                require("luasnip").insert_node(2, "Class docstring"),
                require("luasnip").text_node("\"\"\"\n\n    def __init__(self"),
                require("luasnip").insert_node(3),
                require("luasnip").text_node("):\n        "),
                require("luasnip").insert_node(0),
              }
            ),
          })
        end,
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      
      -- Determine if there's a snippet that can be expanded or jumped to
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
          completion = {
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
            col_offset = -3,
            side_padding = 0,
          },
          documentation = {
            winhighlight = "Normal:CmpDoc",
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind = lspkind.cmp_format({
              mode = "symbol_text",
              maxwidth = 50,
              ellipsis_char = '...',
            })(entry, vim_item)
            
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"
            
            return kind
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        -- Enable preselect feature (helps with signature completion)
        preselect = cmp.PreselectMode.Item,
        -- Add experimental features (might be changed/removed in future versions)
        experimental = {
          ghost_text = { enabled = true },
        },
      })
      
      -- Set up cmdline completion
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
      
      -- Set up completion for specific filetypes
      cmp.setup.filetype({ "python", "lua", "rust", "c", "cpp" }, {
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
      })
      
      -- Set up completion for specific filetypes
      cmp.setup.filetype({ "markdown", "text", "tex" }, {
        sources = cmp.config.sources({
          { name = "luasnip", priority = 1000 },
          { name = "buffer", priority = 750 },
          { name = "path", priority = 500 },
        }),
      })
    end,
  },
  
  -- Autopairs integration with completion
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require("nvim-autopairs")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      
      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })
      
      -- Make autopairs and completion work together
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end,
  },
  
  -- AI-powered code completion
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node",
        server_opts_overrides = {},
      })
      
      -- Make copilot and completion work together
      local cmp = require("cmp")
      
      -- Override the select_next_item if copilot window is visible
      local select_next_item_orig = cmp.select_next_item
      cmp.select_next_item = function(opts)
        local copilot_available = vim.fn["copilot#GetDisplayedSuggestion"]().text ~= ""
        
        if copilot_available then
          vim.fn["copilot#Accept"]("")
        else
          select_next_item_orig(opts)
        end
      end
    end,
  },
  
  -- Tabnine code completion
  {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    event = "InsertEnter",
    config = function()
      require("tabnine").setup({
        disable_auto_comment = true,
        accept_keymap = "<Tab>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
        log_file_path = nil,
      })
    end,
  },
}