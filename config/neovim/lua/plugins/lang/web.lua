-- Web development configuration
return {
  -- Emmet support
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-z>"
      vim.g.user_emmet_settings = {
        javascript = {
          extends = "jsx",
        },
        typescriptreact = {
          extends = "jsx",
        },
        javascriptreact = {
          extends = "jsx",
        },
      }
    end,
  },
  
  -- HTML tag completion
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "xml",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = function()
      require("nvim-ts-autotag").setup({
        filetypes = {
          "html",
          "xml",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
        },
      })
    end,
  },
  
  -- CSS color previewer
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      require("colorizer").setup({
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "*",
      }, {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
      })
    end,
  },
  
  -- Live server
  {
    "barrett-ruth/live-server.nvim",
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    build = "npm install -g live-server",
    config = function()
      require("live-server").setup({
        args = { "--browser=chrome" },
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>wls", ":LiveServerStart<CR>", { desc = "Start live server" })
      vim.keymap.set("n", "<leader>wlx", ":LiveServerStop<CR>", { desc = "Stop live server" })
    end,
  },
  
  -- HTML preview
  {
    "turbio/bracey.vim",
    build = "npm install --prefix server",
    ft = { "html", "css", "javascript", "javascriptreact" },
    config = function()
      -- Keymaps
      vim.keymap.set("n", "<leader>wp", ":Bracey<CR>", { desc = "Start HTML preview" })
      vim.keymap.set("n", "<leader>ws", ":BraceyStop<CR>", { desc = "Stop HTML preview" })
      vim.keymap.set("n", "<leader>wr", ":BraceyReload<CR>", { desc = "Reload HTML preview" })
    end,
  },
  
  -- JSON tools
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc" },
  },
  
  -- Tailwind CSS support
  {
    "laytan/tailwind-sorter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    build = "cd formatter && npm i && npm run build",
    ft = {
      "html",
      "css",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = function()
      require("tailwind-sorter").setup({
        on_save_enabled = true,
        on_save_pattern = {
          "*.html",
          "*.js",
          "*.jsx",
          "*.ts",
          "*.tsx",
          "*.templ",
        },
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>wts", ":TailwindSort<CR>", { desc = "Sort Tailwind CSS classes" })
      vim.keymap.set("v", "<leader>wts", ":TailwindSort<CR>", { desc = "Sort Tailwind CSS classes" })
    end,
  },
  
  -- CSS language server
  {
    "neovim/nvim-lspconfig",
    ft = { "css", "scss", "less" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      
      require("lspconfig").cssls.setup({
        capabilities = capabilities,
      })
      
      require("lspconfig").tailwindcss.setup({})
    end,
  },
  
  -- Web accessibility linting
  {
    "nvimtools/none-ls.nvim",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      local null_ls = require("null-ls")
      
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.alex, -- Catch insensitive, inconsiderate writing
        },
      })
    end,
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
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = 1
      
      -- Keymaps
      vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Start Markdown preview" })
      vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "Stop Markdown preview" })
    end,
  },
}