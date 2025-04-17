-- Ruby development configuration
return {
  -- Ruby syntax highlighting
  {
    "vim-ruby/vim-ruby",
    ft = { "ruby", "eruby", "rbs" },
    config = function()
      vim.g.ruby_operators = 1
      vim.g.ruby_pseudo_operators = 1
      vim.g.ruby_fold = 1
      vim.g.ruby_foldable_groups = "def"
    end,
  },
  
  -- Ruby LSP
  {
    "neovim/nvim-lspconfig",
    ft = { "ruby", "eruby", "rbs" },
    opts = {},
    config = function()
      local lspconfig = require("lspconfig")
      
      -- Configure Ruby LSP (Sorbet or Solargraph)
      lspconfig.sorbet.setup({
        cmd = { "srb", "tc", "--lsp" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
        init_options = {
          enableTypedFolding = true,
        },
      })
      
      lspconfig.solargraph.setup({
        cmd = { "solargraph", "stdio" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
        settings = {
          solargraph = {
            diagnostics = true,
            formatting = true,
            completion = true,
            hover = true,
            useBundler = true,
          },
        },
      })
    end,
  },
  
  -- Ruby test runner
  {
    "nvim-neotest/neotest",
    dependencies = {
      "olimorris/neotest-rspec",
      "zidhuss/neotest-minitest",
    },
    ft = { "ruby" },
    opts = {},
    config = function()
      local neotest = require("neotest")
      
      neotest.setup({
        adapters = {
          require("neotest-rspec")({
            rspec_cmd = function()
              return vim.trim(vim.fn.system("if [ -f Gemfile ]; then echo 'bundle exec rspec'; else echo 'rspec'; fi"))
            end,
          }),
          require("neotest-minitest")({
            test_cmd = function()
              return vim.trim(vim.fn.system("if [ -f Gemfile ]; then echo 'bundle exec ruby -Ilib:test'; else echo 'ruby -Ilib:test'; fi"))
            end,
          }),
        },
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>rt", function() neotest.run.run() end, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>rtf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run current test file" })
      vim.keymap.set("n", "<leader>rts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
      vim.keymap.set("n", "<leader>rto", function() neotest.output.open() end, { desc = "Open test output" })
    end,
  },
  
  -- Rubocop
  {
    "nvimtools/none-ls.nvim",
    ft = { "ruby", "eruby" },
    config = function()
      local null_ls = require("null-ls")
      
      null_ls.setup({
        sources = {
          -- Linting
          null_ls.builtins.diagnostics.rubocop.with({
            command = function()
              return vim.trim(vim.fn.system("if [ -f Gemfile ] && grep -q rubocop Gemfile; then echo 'bundle exec rubocop'; else echo 'rubocop'; fi"))
            end,
          }),
          -- Formatting
          null_ls.builtins.formatting.rubocop.with({
            command = function()
              return vim.trim(vim.fn.system("if [ -f Gemfile ] && grep -q rubocop Gemfile; then echo 'bundle exec rubocop'; else echo 'rubocop'; fi"))
            end,
            args = { "--auto-correct", "--format", "files", "--stderr", "--stdin", "$FILENAME" },
          }),
        },
      })
    end,
  },
  
  -- Ruby REPL integration
  {
    "michaelb/sniprun",
    ft = { "ruby" },
    branch = "master",
    build = "sh install.sh",
    config = function()
      require("sniprun").setup({
        selected_interpreters = { "Ruby_original" },
        repl_enable = { "Ruby_original" },
        display = {
          "Terminal",
        },
      })
      vim.keymap.set("n", "<leader>rr", "<Plug>SnipRun", { silent = true, desc = "Run Ruby code" })
      vim.keymap.set("v", "<leader>rr", "<Plug>SnipRun", { silent = true, desc = "Run selected Ruby code" })
    end,
  },
  
  -- Better ruby heredoc syntax highlighting
  {
    "RRethy/nvim-treesitter-endwise",
    ft = { "ruby" },
    config = function()
      require("nvim-treesitter.configs").setup({
        endwise = {
          enable = true,
        },
      })
    end,
  },
  
  -- Rails support
  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby", "rbs" },
    dependencies = {
      "tpope/vim-bundler",
      "tpope/vim-dispatch",
    },
    config = function()
      -- Rails.vim keymaps
      vim.keymap.set("n", "<leader>ra", ":A<CR>", { desc = "Alternate file" })
      vim.keymap.set("n", "<leader>rm", ":Rmodel ", { desc = "Rails model" })
      vim.keymap.set("n", "<leader>rv", ":Rview ", { desc = "Rails view" })
      vim.keymap.set("n", "<leader>rc", ":Rcontroller ", { desc = "Rails controller" })
      vim.keymap.set("n", "<leader>rh", ":Rhelper ", { desc = "Rails helper" })
      vim.keymap.set("n", "<leader>rj", ":Rjavascript ", { desc = "Rails JavaScript" })
      vim.keymap.set("n", "<leader>rs", ":Rstylesheet ", { desc = "Rails stylesheet" })
      
      -- Custom Rails commands
      vim.api.nvim_create_user_command("Rroutes", "e config/routes.rb", {})
      vim.api.nvim_create_user_command("Rschema", "e db/schema.rb", {})
      vim.api.nvim_create_user_command("Rgemfile", "e Gemfile", {})
    end,
  },
  
  -- Ruby block text objects
  {
    "kana/vim-textobj-user",
    dependencies = {
      "nelstrom/vim-textobj-rubyblock",
    },
    ft = { "ruby", "eruby" },
  },
  
  -- RSpec syntax highlighting
  {
    "keith/rspec.vim",
    ft = { "ruby" },
  },
  
  -- Embedded Ruby (ERB) support
  {
    "NoahTheDuke/vim-just",
    dependencies = { "sheerun/vim-polyglot" },
    ft = { "eruby", "erb" },
  },
  
  -- Launch School specific support
  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- Launch School exercise template
      vim.api.nvim_create_user_command("LSExercise", function(opts)
        local name = opts.args
        if name == "" then
          name = vim.fn.input("Exercise name: ")
        end
        
        -- Create the exercise file
        local exercise_file = name .. ".rb"
        if vim.fn.filereadable(exercise_file) == 0 then
          local f = io.open(exercise_file, "w")
          if f then
            f:write("# " .. name .. ".rb\n\n")
            f:close()
          end
        end
        
        -- Create the test file
        local test_file = "test.rb"
        if vim.fn.filereadable(test_file) == 0 then
          local f = io.open(test_file, "w")
          if f then
            f:write("require 'minitest/autorun'\n")
            f:write("require_relative '" .. name .. "'\n\n")
            f:write("class " .. name:gsub("^%l", string.upper):gsub("_(%l)", function(c) return c:upper() end) .. "Test < Minitest::Test\n")
            f:write("  def test_example\n    # Write your test here\n  end\n")
            f:write("end\n")
            f:close()
          end
        end
        
        -- Open the exercise file
        vim.cmd("e " .. exercise_file)
      end, { nargs = "?" })
      
      -- Launch School test runner
      vim.keymap.set("n", "<leader>lst", ":!ruby -w test.rb<CR>", { desc = "Run Launch School test" })
      vim.keymap.set("n", "<leader>lsf", ":!ruby -w %<CR>", { desc = "Run current Ruby file" })
      vim.keymap.set("n", "<leader>lsc", ":!ruby -c %<CR>", { desc = "Check Ruby syntax" })
      vim.keymap.set("n", "<leader>lsl", ":!rubocop %<CR>", { desc = "Lint with Rubocop" })
    end,
  },
}