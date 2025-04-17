-- plugins/lang/javascript.lua
-- Enhanced JavaScript development configuration with better TypeScript support

return {
  -- JavaScript specific plugin for better JS/TS development
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim", 
      "neovim/nvim-lspconfig"
    },
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    opts = {
      -- Enhanced options for TypeScript language server
      settings = {
        -- Specify TypeScript server options with better defaults
        tsserver_file_preferences = {
          importModuleSpecifierPreference = "relative",
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          quotePreference = "single", -- Use single quotes
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
          -- Formatting options aligned with modern JS standards
          indentSize = 2,
          convertTabsToSpaces = true,
          tabSize = 2,
          indentStyle = "Smart",
          newLineCharacter = "\n",
          baseIndentSize = 0,
          trimTrailingWhitespace = true,
          insertSpaceAfterCommaDelimiter = true,
          insertSpaceAfterConstructor = false,
          insertSpaceAfterSemicolonInForStatements = true,
          insertSpaceBeforeAndAfterBinaryOperators = true,
          insertSpaceAfterKeywordsInControlFlowStatements = true,
          insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
          insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
          insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
          insertSpaceAfterTypeAssertion = false,
          insertSpaceBeforeFunctionParenthesis = false,
          placeOpenBraceOnNewLineForFunctions = false,
          placeOpenBraceOnNewLineForControlBlocks = false,
          semicolons = "insert", -- Always use semicolons
        },
        -- Code completion for JS/TS
        complete_function_calls = true,
        include_completions_with_insert_text = true,
        -- Source code organization
        tsserver_organize_imports_on_format = true,
      },
      -- Specify handlers for specific events
      handlers = {
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
          if result.diagnostics == nil then
            return
          end
          
          -- Filter out unwanted diagnostics
          local filtered_diagnostics = {}
          for _, diagnostic in ipairs(result.diagnostics) do
            -- Filter out some typescript errors
            -- 80001: This file is ignored by TypeScript using the OutDir setting
            -- 6133: Variable is declared but never used
            if diagnostic.code ~= 80001 and diagnostic.code ~= 6133 then
              table.insert(filtered_diagnostics, diagnostic)
            end
          end
          
          result.diagnostics = filtered_diagnostics
          vim.lsp.handlers["textDocument/publishDiagnostics"](_, result, ctx, config)
        end,
      },
      root_dir = function()
        -- Enhanced root directory detection
        local root_files = {
          'tsconfig.json',
          'package.json',
          'jsconfig.json',
          '.git',
        }
        
        -- Find the root directory
        for _, file in ipairs(root_files) do
          local root = vim.fs.find(file, {
            upward = true,
            stop = vim.env.HOME,
            path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
          })[1]
          
          if root then
            return vim.fs.dirname(root)
          end
        end
        
        -- Fallback to current directory
        return vim.fs.dirname(vim.api.nvim_buf_get_name(0))
      end,
    },
    config = function(_, opts)
      require("typescript-tools").setup(opts)
      
      -- Set keymaps for current buffer
      local create_js_keymaps = function(bufnr)
        local map = function(key, cmd, desc)
          vim.keymap.set("n", key, cmd, { buffer = bufnr, desc = desc })
        end
        
        map("<leader>jo", "<cmd>TSToolsOrganizeImports<cr>", "Organize Imports")
        map("<leader>ja", "<cmd>TSToolsAddMissingImports<cr>", "Add Missing Imports")
        map("<leader>jf", "<cmd>TSToolsFixAll<cr>", "Fix All Issues")
        map("<leader>jr", "<cmd>TSToolsRenameFile<cr>", "Rename File")
        map("<leader>ji", "<cmd>TSToolsGoToSourceDefinition<cr>", "Go To Implementation")
        map("<leader>jt", "<cmd>TSToolsGoToTypeDefinition<cr>", "Go To Type Definition")
        map("<leader>js", "<cmd>TSToolsFileReferences<cr>", "Find File References")
        map("<leader>ju", "<cmd>TSToolsRemoveUnused<cr>", "Remove Unused")
        map("<leader>jc", "<cmd>TSToolsRemoveUnusedImports<cr>", "Clean Imports")
      end
      
      -- Add autocommand to set keymaps when buffer is loaded
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        callback = function()
          create_js_keymaps(vim.api.nvim_get_current_buf())
        end,
      })
    end,
  },
  
  -- Jest testing framework integration with improved setup
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "haydenmeade/neotest-jest",
    },
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            -- More intelligent command detection
            jestCommand = function()
              -- Check if using yarn
              if vim.fn.filereadable("yarn.lock") == 1 then
                return "yarn test --"
              -- Check if using pnpm
              elseif vim.fn.filereadable("pnpm-lock.yaml") == 1 then 
                return "pnpm test --"
              -- Default to npm
              else
                return "npm test --"
              end
            end,
            -- Auto-detect Jest config file
            jestConfigFile = function()
              local configs = {
                "jest.config.js",
                "jest.config.ts",
                "jest.config.mjs",
                "jest.config.cjs",
              }
              
              for _, config in ipairs(configs) do
                if vim.fn.filereadable(config) == 1 then
                  return config
                end
              end
              
              return nil
            end,
            -- Test file detection patterns
            testFilePattern = { "test", "spec" },
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
            env_file = ".env.test", -- Use test environment file
            -- Attempt to autodetect test pattern
            testNamePattern = function(name)
              return string.format("^%s$", name:gsub("'", "\\'"))
            end,
          }),
        },
        -- Improved test output display
        output = {
          enabled = true,
          open_on_run = true,
        },
        -- Show inline diagnostics for test results
        diagnostic = {
          enabled = true,
        },
        -- Configure summary window
        summary = {
          enabled = true,
          follow = true,
          expand_errors = true,
        },
      })
      
      -- Enhanced keymaps with better descriptions
      local keymap = vim.keymap.set
      keymap("n", "<leader>jtt", ":lua require('neotest').run.run()<CR>", { desc = "Run nearest test" })
      keymap("n", "<leader>jtf", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = "Run test file" })
      keymap("n", "<leader>jts", ":lua require('neotest').summary.toggle()<CR>", { desc = "Toggle test summary" })
      keymap("n", "<leader>jto", ":lua require('neotest').output.open()<CR>", { desc = "Open test output" })
      keymap("n", "<leader>jtl", ":lua require('neotest').run.run_last()<CR>", { desc = "Run last test" })
      keymap("n", "<leader>jta", ":lua require('neotest').run.run(vim.fn.getcwd())<CR>", { desc = "Run all tests" })
      keymap("n", "<leader>jtp", ":lua require('neotest').output.open({ enter = true, last_run = true })<CR>", { desc = "Show test output" })
    end,
  },
  
  -- ESLint and Prettier integration with improved setup
  {
    "nvimtools/none-ls.nvim",
    ft = { 
      "javascript", 
      "javascriptreact", 
      "typescript", 
      "typescriptreact",
      "json",
      "jsonc" 
    },
    config = function()
      local null_ls = require("null-ls")
      
      -- Detect which formatter to use (Prettier or ESLint)
      local function detect_formatter()
        local formatters = {}
        
        -- Check for Prettier
        if vim.fn.filereadable(".prettierrc") == 1 or 
           vim.fn.filereadable(".prettierrc.js") == 1 or
           vim.fn.filereadable(".prettierrc.json") == 1 or
           vim.fn.filereadable(".prettierrc.yml") == 1 or
           vim.fn.filereadable("prettier.config.js") == 1 then
          table.insert(formatters, null_ls.builtins.formatting.prettier.with({
            prefer_local = "node_modules/.bin",
            timeout = 10000,
          }))
        end
        
        -- Check for ESLint
        if vim.fn.filereadable(".eslintrc") == 1 or 
           vim.fn.filereadable(".eslintrc.js") == 1 or
           vim.fn.filereadable(".eslintrc.json") == 1 or
           vim.fn.filereadable(".eslintrc.yml") == 1 or
           vim.fn.filereadable("eslint.config.js") == 1 then
          table.insert(formatters, null_ls.builtins.formatting.eslint_d.with({
            prefer_local = "node_modules/.bin",
            timeout = 10000,
          }))
          
          -- Also add ESLint diagnostics and code actions
          table.insert(formatters, null_ls.builtins.diagnostics.eslint_d.with({
            prefer_local = "node_modules/.bin",
            timeout = 10000,
          }))
          table.insert(formatters, null_ls.builtins.code_actions.eslint_d.with({
            prefer_local = "node_modules/.bin",
            timeout = 10000,
          }))
        end
        
        -- If no project-specific formatters found, use defaults
        if #formatters == 0 then
          table.insert(formatters, null_ls.builtins.formatting.prettier.with({
            extra_args = {
              "--print-width", "100",
              "--trailing-comma", "es5",
              "--single-quote",
              "--jsx-single-quote",
            },
          }))
          table.insert(formatters, null_ls.builtins.diagnostics.eslint.with({
            condition = function(utils)
              return utils.root_has_file({
                "package.json",
                "tsconfig.json",
                "jsconfig.json",
                ".git",
              })
            end,
          }))
          table.insert(formatters, null_ls.builtins.code_actions.eslint.with({
            condition = function(utils)
              return utils.root_has_file({
                "package.json",
                "tsconfig.json",
                "jsconfig.json",
                ".git",
              })
            end,
          }))
        end
        
        return formatters
      end
      
      null_ls.setup({
        debug = false,
        sources = detect_formatter(),
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
      
      -- Add commands for JavaScript/TypeScript development
      vim.api.nvim_create_user_command("JSFormat", function()
        vim.lsp.buf.format({ timeout_ms = 5000 })
      end, {})
      
      vim.api.nvim_create_user_command("ESLintFix", function()
        vim.cmd("!npx eslint --fix " .. vim.fn.expand("%"))
      end, {})
      
      vim.api.nvim_create_user_command("PrettierFix", function()
        vim.cmd("!npx prettier --write " .. vim.fn.expand("%"))
      end, {})
    end,
  },
  
  -- Improved snippets for JavaScript and TypeScript
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    ft = { 
      "javascript", 
      "javascriptreact", 
      "typescript", 
      "typescriptreact" 
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Use this to add custom snippets
      require("luasnip").filetype_extend("javascript", { "jsdoc" })
      require("luasnip").filetype_extend("typescript", { "tsdoc" })
      require("luasnip").filetype_extend("javascriptreact", { "react" })
      require("luasnip").filetype_extend("typescriptreact", { "react-ts" })
      
      -- Add custom snippets for React development
      require("luasnip").add_snippets("javascriptreact", {
        -- React functional component
        require("luasnip").snippet(
          "rfc", 
          {
            require("luasnip").text_node("import React from 'react';\n\n"),
            require("luasnip").text_node("const "),
            require("luasnip").insert_node(1, "ComponentName"),
            require("luasnip").text_node(" = ({ "),
            require("luasnip").insert_node(2, "props"),
            require("luasnip").text_node(" }) => {\n  return (\n    "),
            require("luasnip").insert_node(0, "<div>Component content</div>"),
            require("luasnip").text_node("\n  );\n};\n\nexport default "),
            require("luasnip").insert_node(3, "ComponentName"),
            require("luasnip").text_node(";"),
          }
        ),
        -- React useState hook
        require("luasnip").snippet(
          "useState", 
          {
            require("luasnip").text_node("const ["),
            require("luasnip").insert_node(1, "state"),
            require("luasnip").text_node(", set"),
            require("luasnip").function_node(function(args)
              local state = args[1][1]
              return state:sub(1,1):upper() .. state:sub(2)
            end, {1}),
            require("luasnip").text_node("] = useState("),
            require("luasnip").insert_node(2, "initialState"),
            require("luasnip").text_node(");"),
          }
        ),
      })
      
      -- Add custom snippets for TypeScript
      require("luasnip").add_snippets("typescript", {
        -- TypeScript interface
        require("luasnip").snippet(
          "interface", 
          {
            require("luasnip").text_node("interface "),
            require("luasnip").insert_node(1, "InterfaceName"),
            require("luasnip").text_node(" {\n  "),
            require("luasnip").insert_node(2, "property"),
            require("luasnip").text_node(": "),
            require("luasnip").insert_node(3, "type"),
            require("luasnip").text_node(";\n}"),
          }
        ),
        -- TypeScript type
        require("luasnip").snippet(
          "type", 
          {
            require("luasnip").text_node("type "),
            require("luasnip").insert_node(1, "TypeName"),
            require("luasnip").text_node(" = "),
            require("luasnip").insert_node(2, "type"),
            require("luasnip").text_node(";"),
          }
        ),
      })
    end,
  },
  
  -- Enhanced package.json management
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = {
      "json",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = function()
      require("package-info").setup({
        colors = {
          up_to_date = "#3C4048", -- Text color for up to date package virtual text
          outdated = "#fc514e", -- Text color for outdated package virtual text
        },
        icons = {
          enable = true, -- Whether to display icons
          style = {
            up_to_date = "✓", -- Icon for up to date packages
            outdated = "✗", -- Icon for outdated packages
          },
        },
        autostart = true, -- Whether to autostart when opening package.json
        hide_up_to_date = false, -- Hide up to date packages
        hide_unstable_versions = false, -- Hide unstable versions from version list
        package_manager = "npm", -- Which package manager to use (can be "npm", "yarn", or "pnpm")
        -- For Launch School projects (auto-detect package manager)
        determine_package_manager = function(bufnr)
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local cwd = vim.fn.fnamemodify(bufname, ":h")
          
          if vim.fn.filereadable(cwd .. "/package-lock.json") == 1 then
            return "npm"
          elseif vim.fn.filereadable(cwd .. "/yarn.lock") == 1 then
            return "yarn"
          elseif vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1 then
            return "pnpm"
          end
          
          return "npm" -- Default to npm
        end
      })
      
      -- Enhanced keymaps with better descriptions
      vim.keymap.set("n", "<leader>jns", ":lua require('package-info').show()<CR>", { desc = "Show package versions" })
      vim.keymap.set("n", "<leader>jnh", ":lua require('package-info').hide()<CR>", { desc = "Hide package versions" })
      vim.keymap.set("n", "<leader>jnu", ":lua require('package-info').update()<CR>", { desc = "Update package" })
      vim.keymap.set("n", "<leader>jnc", ":lua require('package-info').change_version()<CR>", { desc = "Change package version" })
      vim.keymap.set("n", "<leader>jnd", ":lua require('package-info').delete()<CR>", { desc = "Delete package" })
      vim.keymap.set("n", "<leader>jni", ":lua require('package-info').install()<CR>", { desc = "Install new package" })
    end,
  },
  
  -- Enhanced JavaScript debugging
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    config = function()
      -- Install vscode-js-debug if not already installed
      local mason_registry = require("mason-registry")
      if mason_registry.is_installed("js-debug-adapter") == false then
        vim.notify("Installing JavaScript debug adapter...", vim.log.levels.INFO)
        mason_registry.refresh(function()
          local js_debug = mason_registry.get_package("js-debug-adapter")
          if not js_debug:is_installed() then
            js_debug:install()
          end
        end)
      end
      
      -- Get the path to the debugger
      local js_debug_path = nil
      if mason_registry.is_installed("js-debug-adapter") then
        js_debug_path = mason_registry.get_package("js-debug-adapter"):get_install_path()
      end
      
      if js_debug_path then
        require("dap-vscode-js").setup({
          debugger_path = js_debug_path,
          adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal" },
          -- Add more adapters for different frameworks
          log_file_path = vim.fn.stdpath("cache") .. "/dap_vscode_js.log",
          log_file_level = vim.log.levels.ERROR,
          log_console_level = vim.log.levels.ERROR,
        })
        
        local dap = require("dap")
        
        -- Node.js configuration
        dap.configurations.javascript = {
          -- Basic Node.js launch configuration
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Node.js (File)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            skipFiles = { "<node_internals>/**" },
          },
          -- Attach to running Node.js process
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Node.js",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**" },
          },
          -- Jest configuration
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            console = "integratedTerminal",
            skipFiles = { "<node_internals>/**" },
          },
          -- Node.js with environment variables
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Node.js with .env",
            program = "${file}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            skipFiles = { "<node_internals>/**" },
            envFile = "${workspaceFolder}/.env",
          },
        }
        
        -- TypeScript configurations
        dap.configurations.typescript = {
          -- Basic TypeScript launch
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch TypeScript (ts-node)",
            runtimeExecutable = "node",
            runtimeArgs = { "--loader", "ts-node/esm", "${file}" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          -- TypeScript with Jest
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug TypeScript Jest Tests",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
              "--config",
              "./jest.config.ts"
            },
            console = "integratedTerminal",
            skipFiles = { "<node_internals>/**" },
          },
          -- Generic Node.js attach
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to TypeScript",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
        }
        
        -- Browser configurations
        dap.configurations.javascriptreact = {
          -- Chrome launch
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            userDataDir = "${workspaceFolder}/.vscode/chrome-debug-user-data",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          -- Chrome attach
          {
            type = "pwa-chrome",
            request = "attach",
            name = "Attach to Chrome",
            port = 9222,
            webRoot = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
        }
        
        -- Same configurations for TypeScript React
        dap.configurations.typescriptreact = dap.configurations.javascriptreact
        
        -- Enhanced keymaps
        local keymap = vim.keymap.set
        keymap("n", "<leader>jdb", ":lua require('dap').toggle_breakpoint()<CR>", 
          { desc = "Toggle breakpoint" })
        keymap("n", "<leader>jdc", ":lua require('dap').continue()<CR>", 
          { desc = "Start/continue debugging" })
        keymap("n", "<leader>jdi", ":lua require('dap').step_into()<CR>", 
          { desc = "Step into" })
        keymap("n", "<leader>jdo", ":lua require('dap').step_over()<CR>", 
          { desc = "Step over" })
        keymap("n", "<leader>jdu", ":lua require('dap').step_out()<CR>", 
          { desc = "Step out" })
        keymap("n", "<leader>jdr", ":lua require('dap').repl.open()<CR>", 
          { desc = "Open REPL" })
        keymap("n", "<leader>jdl", ":lua require('dap').run_last()<CR>", 
          { desc = "Run last" })
        keymap("n", "<leader>jdt", ":lua require('dap-vscode-js').debug_test()<CR>", 
          { desc = "Debug test" })
      else
        vim.notify("JavaScript debug adapter not found. Install using :Mason", vim.log.levels.WARN)
      end
    end,
  },
}