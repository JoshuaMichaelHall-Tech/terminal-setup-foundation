-- Data analysis plugins for Python
return {
  -- Table/dataframe visualization
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },
  
  -- SQL integration
  {
    "nanotee/sqls.nvim",
    ft = { "sql" },
    config = function()
      require("lspconfig").sqls.setup({
        on_attach = function(client, bufnr)
          require("sqls").on_attach(client, bufnr)
        end,
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>ds", ":SqlsExecuteQuery<CR>", { desc = "Execute SQL query" })
      vim.keymap.set("v", "<leader>ds", ":SqlsExecuteQuery<CR>", { desc = "Execute selected SQL query" })
      vim.keymap.set("n", "<leader>dsl", ":SqlsShowDatabases<CR>", { desc = "List databases" })
      vim.keymap.set("n", "<leader>dst", ":SqlsShowTables<CR>", { desc = "List tables" })
      vim.keymap.set("n", "<leader>dsc", ":SqlsShowSchemas<CR>", { desc = "List schemas" })
    end,
  },
  
  -- Database client
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    config = function()
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.g.db_ui_use_nerd_fonts = 1
      
      -- Keymaps
      vim.keymap.set("n", "<leader>du", ":DBUIToggle<CR>", { desc = "Toggle database UI" })
      vim.keymap.set("n", "<leader>df", ":DBUIFindBuffer<CR>", { desc = "Find DB buffer" })
      vim.keymap.set("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { desc = "Rename DB buffer" })
      vim.keymap.set("n", "<leader>dq", ":DBUILastQueryInfo<CR>", { desc = "Show last query" })
    end,
  },
  
  -- Jupyter notebook integration
  {
    "dccsillag/magma-nvim",
    ft = { "python" },
    build = ":UpdateRemotePlugins",
    config = function()
      vim.g.magma_automatically_open_output = false
      vim.g.magma_image_provider = "kitty"
      
      -- Keymaps
      vim.keymap.set("n", "<leader>mi", ":MagmaInit<CR>", { desc = "Initialize Magma" })
      vim.keymap.set("n", "<leader>me", ":MagmaEvaluateLine<CR>", { desc = "Evaluate line" })
      vim.keymap.set("v", "<leader>me", ":<C-u>MagmaEvaluateVisual<CR>", { desc = "Evaluate visual selection" })
      vim.keymap.set("n", "<leader>mc", ":MagmaReevaluateCell<CR>", { desc = "Reevaluate cell" })
      vim.keymap.set("n", "<leader>md", ":MagmaDelete<CR>", { desc = "Delete cell" })
      vim.keymap.set("n", "<leader>mo", ":MagmaShowOutput<CR>", { desc = "Show output" })
    end,
  },
  
  -- CSV operations
  {
    "Glassinatorn/kakoune-csv.nvim",
    ft = { "csv" },
    config = function()
      require("kakoune-csv").setup({
        column_separator = ",",
        execute_on_open = true,
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>csa", ":KakouneCSVAddColumn<CR>", { desc = "Add CSV column" })
      vim.keymap.set("n", "<leader>csd", ":KakouneCSVDeleteColumn<CR>", { desc = "Delete CSV column" })
      vim.keymap.set("n", "<leader>csf", ":KakouneCSVFloat<CR>", { desc = "Float CSV column" })
      vim.keymap.set("n", "<leader>csF", ":KakouneCSVFloatDelimiter<CR>", { desc = "Float CSV delimiter" })
    end,
  },
  
  -- Quarto integration for data science
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "quarto", "markdown" },
    config = function()
      require("quarto").setup({
        lspFeatures = {
          enabled = true,
          languages = { "r", "python", "julia" },
          diagnostics = {
            enabled = true,
            triggers = { "BufWrite" },
          },
          completion = {
            enabled = true,
          },
        },
        codeRunner = {
          enabled = true,
          default_method = "slime",
        },
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>qp", ":QuartoPreview<CR>", { desc = "Preview Quarto document" })
      vim.keymap.set("n", "<leader>qq", ":QuartoClosePreview<CR>", { desc = "Close Quarto preview" })
      vim.keymap.set("n", "<leader>qr", ":QuartoRun<CR>", { desc = "Run Quarto cell" })
      vim.keymap.set("v", "<leader>qr", ":QuartoSendRange<CR>", { desc = "Run selected Quarto code" })
    end,
  },
  
  -- R language support
  {
    "jalvesaq/Nvim-R",
    ft = { "r", "rmd" },
    config = function()
      -- R settings
      vim.g.R_app = "R"
      vim.g.R_cmd = "R"
      vim.g.R_hl_term = 0
      vim.g.R_bracketed_paste = 1
      
      -- Keyboard mappings
      vim.g.R_assign_map = "--"
      
      -- Set working directory when opening file
      vim.g.R_auto_start = 1
      vim.g.R_auto_cd = 1
      
      -- Knit RMarkdown
      vim.g.R_rmarkdown_args = "--no-toc -q"
    end,
  },
  
  -- Data visualization with plots
  {
    "jbyuki/venn.nvim",
    keys = {
      { "<leader>dv", ":VBox<CR>", mode = "v", desc = "Draw box around selection" },
    },
    config = function()
      -- Venn.nvim: enable or disable keymaps
      function _G.toggle_venn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.cmd[[setlocal ve=all]]
          -- Draw a line on HJKL keystokes
          vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
          vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
          vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
          vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
          -- Draw a box by pressing "f" with visual selection
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
          print("Venn diagramming enabled")
        else
          vim.cmd[[setlocal ve=]]
          vim.cmd[[mapclear <buffer>]]
          vim.b.venn_enabled = nil
          print("Venn diagramming disabled")
        end
      end
      
      -- Toggle venn diagrams
      vim.keymap.set("n", "<leader>ve", ":lua toggle_venn()<CR>", { desc = "Toggle Venn diagrams" })
    end,
  },
}