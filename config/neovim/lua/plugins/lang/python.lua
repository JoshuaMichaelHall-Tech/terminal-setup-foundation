-- plugins/lang/python.lua
-- Enhanced Python development configuration with better LSP, debugging and data analysis tools

return {
  -- Python syntax and indentation
  {
    "vim-python/python-syntax",
    ft = "python",
    config = function()
      vim.g.python_highlight_all = 1
      vim.g.python_highlight_space_errors = 0 -- Disable space error highlighting
    end,
  },
  
  -- Python LSP with enhanced configuration
  {
    "neovim/nvim-lspconfig",
    ft = "python",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Ensure pyright is installed
      require("mason-registry").refresh(function() 
        local pyright = require("mason-registry").get_package("pyright")
        if not pyright:is_installed() then
          pyright:install()
        end
      end)
      
      -- Configure pyright with better settings
      require("lspconfig").pyright.setup({
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic", -- Can be "off", "basic", or "strict"
              -- Data science specific settings
              extraPaths = {}, -- Add data science packages paths here
              -- Ignore common data analysis warnings
              diagnosticSeverityOverrides = {
                reportGeneralTypeIssues = "warning",
                reportOptionalMemberAccess = "information",
                reportOptionalSubscript = "information",
                reportPrivateImportUsage = "information",
              },
            },
            -- Enable Jupyter notebook support
            jupyter = {
              enabled = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          -- Add specific keymaps for Python
          vim.keymap.set("n", "<leader>pi", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = bufnr, desc = "Show Python info" })
          
          -- Set up document formatting
          vim.keymap.set("n", "<leader>pf", function()
            vim.lsp.buf.format({ timeout_ms = 2000 })
          end, { buffer = bufnr, desc = "Format Python code" })
        end,
      })
    end,
  },
  
  -- Python debugging with enhanced configuration
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    ft = "python",
    config = function()
      -- Attempt to find debugpy from Mason installation
      local mason_registry = require("mason-registry")
      local debugpy_path
      
      if mason_registry.is_installed("debugpy") then
        debugpy_path = mason_registry.get_package("debugpy"):get_install_path() .. "/venv/bin/python"
      else
        -- Fall back to system python if Mason's debugpy is not available
        debugpy_path = vim.fn.exepath("python3") or vim.fn.exepath("python")
        
        -- If python exists, install debugpy
        if debugpy_path ~= "" then
          vim.notify("Installing debugpy for Python debugging...", vim.log.levels.INFO)
          mason_registry.refresh(function()
            local debugpy = mason_registry.get_package("debugpy")
            if not debugpy:is_installed() then
              debugpy:install()
            end
          end)
        end
      end
      
      -- Setup DAP with the found Python path
      if debugpy_path and debugpy_path ~= "" then
        require("dap-python").setup(debugpy_path)
        
        -- Add configurations for pytest with better defaults
        require("dap-python").test_runner = "pytest"
        
        -- Add data science configuration (for Jupyter notebooks)
        table.insert(require("dap").configurations.python, {
          type = "python",
          request = "launch",
          name = "Data Science: Current File",
          program = "${file}",
          console = "integratedTerminal",
          justMyCode = false,
          env = {
            PYTHONPATH = "${workspaceFolder}",
          },
        })
        
        -- Enhanced keymaps for Python debugging
        local keymap = vim.keymap.set
        keymap("n", "<leader>dpr", function() require("dap-python").test_method() end, { desc = "Debug Python test method" })
        keymap("n", "<leader>dpc", function() require("dap-python").test_class() end, { desc = "Debug Python test class" })
        keymap("n", "<leader>dpf", function() require("dap-python").test_file() end, { desc = "Debug Python test file" })
        keymap("n", "<leader>dpi", function() require("dap-python").debug_selection() end, { desc = "Debug Python selection" })
        
        -- Add a visual mode keymap for debugging selected code
        keymap("v", "<leader>dpi", function() require("dap-python").debug_selection() end, { desc = "Debug Python selection" })
      else
        vim.notify("Python not found for DAP setup. Install Python or debugpy manually.", vim.log.levels.WARN)
      end
    end,
  },
  
  -- Enhanced virtual environment management
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
      search = true,
      search_workspace = true,
      parents = 2, -- Search 2 levels up for virtual environments
      -- For data science, look for common virtual environment names
      search_venv_managers = true,
      venv_names = {
        ".venv", "venv", "env", ".env", "virtualenv",
        "pyenv", "anaconda3", "miniconda3" -- Add common data science venv names
      },
      -- Auto-activate virtual environment when opening a Python file
      auto_activate = true,
      -- Notification of activated environment
      notify_user_on_activation = true,
    },
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
      { "<leader>pc", "<cmd>VenvSelectCached<cr>", desc = "Select from cached venvs" },
      { "<leader>pa", "<cmd>VenvSelectCurrent<cr>", desc = "Show active venv" },
    },
    config = function(_, opts)
      require("venv-selector").setup(opts)
      
      -- Autocommand to activate venv when opening a Python file
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          -- Try to find and activate venv if not already active
          if os.getenv("VIRTUAL_ENV") == nil then
            vim.defer_fn(function()
              require("venv-selector").retrieve_from_cache()
            end, 100)
          end
        end,
      })
    end,
  },
  
  -- Python linting and formatting with enhanced configuration
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    ft = "python",
    config = function()
      local null_ls = require("null-ls")
      local python = require("none-ls-extras.python")
      
      null_ls.setup({
        sources = {
          -- Formatting with Black
          python.black.with({
            extra_args = {
              "--line-length=88", 
              "--preview",
              "--target-version=py39" -- Target newer Python
            },
          }),
          
          -- Import sorting with isort
          python.isort.with({
            extra_args = {
              "--profile", "black", 
              "--line-length=88"
            },
          }),
          
          -- Linting with flake8 (configured for data science)
          python.flake8.with({
            extra_args = {
              "--max-line-length=88", 
              "--extend-ignore=E203,E501,W503", -- Ignored rules that conflict with Black
              "--per-file-ignores=__init__.py:F401", -- Allow unused imports in __init__.py
            },
          }),
          
          -- Type checking with mypy
          null_ls.builtins.diagnostics.mypy.with({
            extra_args = {
              "--python-version=3.9",
              "--ignore-missing-imports",
              "--disallow-untyped-defs",
              "--disallow-incomplete-defs",
              "--check-untyped-defs",
              "--disallow-untyped-decorators",
              "--no-implicit-optional",
              "--warn-redundant-casts",
              "--warn-unused-ignores",
              "--warn-return-any",
              "--warn-unreachable",
            },
          }),
          
          -- Add pydocstyle for docstring checking
          null_ls.builtins.diagnostics.pydocstyle.with({
            extra_args = {"--convention=google"} -- Use Google style docstrings
          }),
        },
        
        -- Format on save if autoformat is enabled
        on_attach = function(client, bufnr)
          if vim.g.autoformat then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  filter = function(c)
                    return c.name == "null-ls"
                  end,
                })
              end,
            })
          end
        end,
      })
      
      -- Add command to check types with mypy
      vim.api.nvim_create_user_command("PyTypeCheck", function()
        vim.cmd("!mypy " .. vim.fn.expand("%"))
      end, {})
      
      -- Add command to fix imports with isort
      vim.api.nvim_create_user_command("PyFixImports", function()
        vim.cmd("!isort " .. vim.fn.expand("%"))
      end, {})
    end,
  },
  
  -- Enhanced Python test runner with better output
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
            -- The following line tells neotest-python to use pytest instead of unittest by default
            runner = "pytest",
            -- Arguments for pytest
            args = {
              "--verbose",
              "--color=yes",
              "-v",
            },
            -- Path discovery for pytest
            pytest_discover_instances = true,
            -- For data science testing
            dap = { 
              justMyCode = false,
              console = "integratedTerminal",
            },
          }),
        },
        -- Configure output
        output = {
          enabled = true,
          open_on_run = true,
        },
        -- Show diagnostics for test results
        diagnostic = {
          enabled = true,
        },
        -- Enable floating summary window
        summary = {
          enabled = true,
          expand_errors = true,
          follow = true,
        },
      })
      
      -- Enhanced keymaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>pt", function() require("neotest").run.run() end, 
        { desc = "Run nearest test" })
      keymap("n", "<leader>ptf", function() require("neotest").run.run(vim.fn.expand("%")) end, 
        { desc = "Run test file" })
      keymap("n", "<leader>ptt", function() require("neotest").run.run(vim.fn.getcwd()) end, 
        { desc = "Run all tests" })
      keymap("n", "<leader>pts", function() require("neotest").summary.toggle() end, 
        { desc = "Toggle test summary" })
      keymap("n", "<leader>pto", function() require("neotest").output.open() end, 
        { desc = "Open test output" })
      keymap("n", "<leader>ptl", function() require("neotest").run.run_last() end, 
        { desc = "Run last test" })
    end,
  },
  
  -- Python docstring generation with advanced configuration
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = "google_docstrings", -- Use Google style (better for data science)
              template_files = { -- Add more advanced docstring templates
                "python/class_google.lua",
                "python/func_google.lua",
                "python/data_science_google.lua", -- Custom template for data science functions
              },
            },
            -- Add specific docstrings for data science methods
            data_science_google = [[
"""${header}

${doc}

Args:
    ${args}

Returns:
    ${returns}

Raises:
    ${raises}

Notes:
    ${notes}

Examples:
    >>> ${example}
"""]]
          },
        },
      })
      
      -- Enhanced keymap with description
      vim.keymap.set("n", "<leader>pd", function()
        require("neogen").generate({
          type = "func", -- Can be func, class, type, file
        })
      end, { desc = "Generate Python docstring" })
      
      -- Add class docstring keymap
      vim.keymap.set("n", "<leader>pcd", function()
        require("neogen").generate({
          type = "class",
        })
      end, { desc = "Generate Python class docstring" })
      
      -- Add file docstring keymap
      vim.keymap.set("n", "<leader>pfd", function()
        require("neogen").generate({
          type = "file",
        })
      end, { desc = "Generate Python file docstring" })
    end,
  },
  
  -- Jupyter notebook integration with improved functionality
  {
    "kiyoon/jupynium.nvim",
    build = "pip install .", -- Use virtual env please
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "python" },
    opts = {
      -- Auto start Jupyter server when opening notebook files
      auto_start_server = {
        enable = true,
        file_pattern = { "*.ju.py", "*.ipynb" },
      },
      -- Configure jupyter command
      jupyter_command = "jupyter",
      -- Use notebook kernel for execution
      use_notebook_kernel = true,
      -- Close server when Neovim exits
      auto_close_server = true,
      -- Scroll behavior
      scroll_synchronization = true,
      -- Authentication
      create_jupyter_widget_in_kernel = true,
    },
    config = function(_, opts)
      require("jupynium").setup(opts)
      
      -- Add keymaps for Jupyter integration
      vim.keymap.set("n", "<leader>js", "<cmd>JupyniumStartSync<cr>", { desc = "Start Jupynium sync" })
      vim.keymap.set("n", "<leader>jc", "<cmd>JupyniumStopSync<cr>", { desc = "Stop Jupynium sync" })
      vim.keymap.set("n", "<leader>je", "<cmd>JupyniumExecuteCell<cr>", { desc = "Execute current cell" })
      vim.keymap.set("n", "<leader>ja", "<cmd>JupyniumExecuteAll<cr>", { desc = "Execute all cells" })
      vim.keymap.set("n", "<leader>jn", "<cmd>JupyniumCellNext<cr>", { desc = "Next cell" })
      vim.keymap.set("n", "<leader>jp", "<cmd>JupyniumCellPrev<cr>", { desc = "Previous cell" })
      
      -- Create autocommands for Jupyter notebook files
      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"*.ju.py", "*.ipynb"},
        callback = function()
          -- Start Jupynium for Jupyter files
          vim.cmd("JupyniumStartSync")
        end,
      })
    end,
  },
  
  -- Data analysis visualization with Python (new plugin)
  {
    "GCBallesteros/jupytext.nvim",
    dependencies = {
      "GCBallesteros/jupytext-nvim-helper",
    },
    config = function()
      require("jupytext").setup({
        style = "markdown", -- Convert to/from markdown files
        extension = ".md", -- Use markdown extension
        custom_language_formatting = {
          python = {
            extension = ".py", -- Python files
            style = "light", -- Light highlighting
            code_marker = "#%%", -- Cell marker
          },
        },
      })
      
      -- Add keymaps for Jupytext
      vim.keymap.set("n", "<leader>jt", "<cmd>JupytextToNotebook<cr>", { desc = "Convert to Jupyter notebook" })
      vim.keymap.set("n", "<leader>jf", "<cmd>JupytextFromNotebook<cr>", { desc = "Convert from Jupyter notebook" })
    end,
  },
}