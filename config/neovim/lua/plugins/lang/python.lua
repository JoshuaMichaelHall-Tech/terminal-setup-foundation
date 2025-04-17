-- Python development configuration
return {
  -- Python syntax and indentation
  {
    "vim-python/python-syntax",
    ft = "python",
    config = function()
      vim.g.python_highlight_all = 1
    end,
  },
  
  -- Python LSP and debugging
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    ft = "python",
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/bin/python")
      
      -- Add configurations for pytest
      require("dap-python").test_runner = "pytest"
      
      -- Set keymaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>dpr", function() require("dap-python").test_method() end, { desc = "Debug Python test method" })
      keymap("n", "<leader>dpc", function() require("dap-python").test_class() end, { desc = "Debug Python test class" })
      keymap("n", "<leader>dpf", function() require("dap-python").test_file() end, { desc = "Debug Python test file" })
    end,
  },
  
  -- Jupyter notebook integration
  {
    "kiyoon/jupynium.nvim",
    build = "pip install .", -- Use virtual env please
    -- build requires neovim python support to be setup first
    -- run :checkhealth jupynium
    -- requires: 'nvim-lua/plenary.nvim',
    ft = { "python" },
    opts = {
      auto_start_server = {
        enable = false,
        file_pattern = { "*.ju.py", "*.ipynb" },
      },
    },
  },
  
  -- Virtual Environment management
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    opts = {
      name = ".venv",
      auto_refresh = true,
    },
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
      { "<leader>pc", "<cmd>VenvSelectCached<cr>", desc = "Select from cached venvs" },
    },
  },
  
  -- Python docstring generation
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = "google_docstrings",
            },
          },
        },
      })
      vim.keymap.set("n", "<leader>pd", ":lua require('neogen').generate()<CR>", { desc = "Generate Python docstring" })
    end,
  },
  
  -- Python linting and formatting
  {
    "nvimtools/none-ls.nvim",
    ft = "python",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local python = require("none-ls-extras.python")
      
      null_ls.setup({
        sources = {
          python.black,
          python.isort,
          python.flake8.with({
            extra_args = {"--max-line-length=100", "--ignore=E203,E501,W503"},
          }),
          null_ls.builtins.diagnostics.mypy,
        },
      })
    end,
  },
  
  -- Python REPL integration
  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    ft = "python",
    config = function()
      require("sniprun").setup({
        selected_interpreters = { "Python3_original" },
        repl_enable = { "Python3_original" },
        display = {
          "Terminal",
        },
      })
      vim.keymap.set("n", "<leader>pr", "<Plug>SnipRun", { silent = true, desc = "Run Python code" })
      vim.keymap.set("v", "<leader>pr", "<Plug>SnipRun", { silent = true, desc = "Run selected Python code" })
    end,
  },
  
  -- Python test runner
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    ft = "python",
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            pytest_xvs = true,
          }),
        },
      })
      
      -- Keymaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>pt", ":lua require('neotest').run.run()<CR>", { desc = "Run nearest test" })
      keymap("n", "<leader>ptf", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = "Run test file" })
      keymap("n", "<leader>pts", ":lua require('neotest').summary.toggle()<CR>", { desc = "Toggle test summary" })
      keymap("n", "<leader>pto", ":lua require('neotest').output.open()<CR>", { desc = "Open test output" })
    end,
  },
}