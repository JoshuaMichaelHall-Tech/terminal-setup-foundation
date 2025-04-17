-- JavaScript development configuration
return {
  -- JavaScript specific plugin for better JS/TS development
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    opts = {
      -- Options for typescript language server
      settings = {
        -- Specify TypeScript server options
        tsserver_file_preferences = {
          importModuleSpecifierPreference = "relative",
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
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
            if diagnostic.code ~= 80001 then
              table.insert(filtered_diagnostics, diagnostic)
            end
          end
          
          result.diagnostics = filtered_diagnostics
          vim.lsp.handlers["textDocument/publishDiagnostics"](_, result, ctx, config)
        end,
      },
    },
    config = function(_, opts)
      require("typescript-tools").setup(opts)
      
      -- Set keymaps
      local bufnr = vim.api.nvim_get_current_buf()
      vim.keymap.set("n", "<leader>jo", "<cmd>TSToolsOrganizeImports<cr>", { buffer = bufnr, desc = "Organize Imports" })
      vim.keymap.set("n", "<leader>ja", "<cmd>TSToolsAddMissingImports<cr>", { buffer = bufnr, desc = "Add Missing Imports" })
      vim.keymap.set("n", "<leader>jf", "<cmd>TSToolsFixAll<cr>", { buffer = bufnr, desc = "Fix All" })
      vim.keymap.set("n", "<leader>jr", "<cmd>TSToolsRenameFile<cr>", { buffer = bufnr, desc = "Rename File" })
    end,
  },
  
  -- Jest testing framework integration
  {
    "nvim-neotest/neotest",
    dependencies = {
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
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
        },
      })
      
      -- Keymaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>jt", ":lua require('neotest').run.run()<CR>", { desc = "Run nearest test" })
      keymap("n", "<leader>jtf", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = "Run test file" })
      keymap("n", "<leader>jts", ":lua require('neotest').summary.toggle()<CR>", { desc = "Toggle test summary" })
      keymap("n", "<leader>jto", ":lua require('neotest').output.open()<CR>", { desc = "Open test output" })
    end,
  },
  
  -- JS/TS specific formatter
  {
    "nvimtools/none-ls.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      local null_ls = require("null-ls")
      
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier.with({
            extra_args = {
              "--print-width", "100",
              "--trailing-comma", "es5",
              "--single-quote",
              "--jsx-single-quote",
            },
          }),
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
        },
      })
    end,
  },
  
  -- Snippet files for JS/TS
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Use this to add custom snippets
      require("luasnip").filetype_extend("javascript", { "jsdoc" })
      require("luasnip").filetype_extend("typescript", { "tsdoc" })
      require("luasnip").filetype_extend("javascriptreact", { "react" })
      require("luasnip").filetype_extend("typescriptreact", { "react-ts" })
    end,
  },
  
  -- Package.json viewer and manager
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
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>jns", ":lua require('package-info').show()<CR>", { desc = "Show package versions" })
      vim.keymap.set("n", "<leader>jnh", ":lua require('package-info').hide()<CR>", { desc = "Hide package versions" })
      vim.keymap.set("n", "<leader>jnu", ":lua require('package-info').update()<CR>", { desc = "Update package" })
      vim.keymap.set("n", "<leader>jnc", ":lua require('package-info').change_version()<CR>", { desc = "Change package version" })
    end,
  },
  
  -- Node.js debugging
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
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })
      
      local dap = require("dap")
      
      -- Node.js
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
      
      -- Same configurations for TypeScript
      dap.configurations.typescript = dap.configurations.javascript
      
      -- Browser
      dap.configurations.javascriptreact = {
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
        },
      }
      
      dap.configurations.typescriptreact = dap.configurations.javascriptreact
      
      -- Keymaps
      vim.keymap.set("n", "<leader>jdb", ":lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>jdc", ":lua require('dap').continue()<CR>", { desc = "Start/continue debugging" })
      vim.keymap.set("n", "<leader>jdi", ":lua require('dap').step_into()<CR>", { desc = "Step into" })
      vim.keymap.set("n", "<leader>jdo", ":lua require('dap').step_over()<CR>", { desc = "Step over" })
      vim.keymap.set("n", "<leader>jdu", ":lua require('dap').step_out()<CR>", { desc = "Step out" })
    end,
  },
}