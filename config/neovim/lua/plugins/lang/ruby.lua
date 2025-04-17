-- plugins/lang/ruby.lua
-- Enhanced Ruby development configuration with improved Launch School support

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
      
      -- Improved syntax highlighting
      vim.g.ruby_no_expensive = 0 -- Enable expensive operations for better highlighting
      vim.g.ruby_indent_access_modifier_style = "indent" -- Indent access modifiers
      vim.g.ruby_indent_assignment_style = "variable" -- Align multi-line assignments
      vim.g.ruby_indent_block_style = "do" -- Indent blocks
    end,
  },
  
  -- Ruby LSP configuration
  {
    "neovim/nvim-lspconfig",
    ft = { "ruby", "eruby", "rbs" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Ensure solargraph is installed
      require("mason-registry").refresh(function() 
        local solargraph = require("mason-registry").get_package("solargraph")
        if not solargraph:is_installed() then
          solargraph:install()
        end
      end)
      
      local lspconfig = require("lspconfig")
      
      -- Configure Solargraph with better settings
      lspconfig.solargraph.setup({
        cmd = { "solargraph", "stdio" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
        init_options = {
          formatting = true, -- Enable formatting
          diagnostics = true, -- Enable diagnostics
          completion = true, -- Enable completion
        },
        settings = {
          solargraph = {
            diagnostics = true,
            formatting = true,
            completion = true,
            hover = true,
            autoformat = false, -- Let null-ls handle formatting
            useBundler = true, -- Use bundler if available
            logLevel = "warn", -- Logging level
            -- Configure Ruby version
            rubyVersion = "3.2.0", -- Change this to match your Ruby version
            -- Add custom gems
            gems = {
              "solargraph",
              "rubocop",
              "ruby-debug-ide",
              "debase",
            },
            -- Add configuration for Launch School exercises
            bundlerPath = "bundle",
            commandPath = "solargraph",
            useBundler = false, -- Disabled for Launch School exercises since they don't use bundler
            -- Add custom require paths
            require_paths = {
              "./lib",
              "./vendor",
              "./app",
            },
            -- Add definitions for Launch School specific libraries
            definitions = {
              "test/unit",
              "minitest"
            },
          },
        },
        on_attach = function(client, bufnr)
          -- Add specific keymaps for Ruby
          vim.keymap.set("n", "<leader>rts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
      vim.keymap.set("n", "<leader>rto", function() neotest.output.open() end, { desc = "Open test output" })
      
      -- Launch School specific keymaps
      vim.keymap.set("n", "<leader>lst", ":!ruby -w test.rb<CR>", { desc = "Run Launch School test" })
      vim.keymap.set("n", "<leader>lsf", ":!ruby -w %<CR>", { desc = "Run current Ruby file" })
      vim.keymap.set("n", "<leader>lsc", ":!ruby -c %<CR>", { desc = "Check Ruby syntax" })
      vim.keymap.set("n", "<leader>lsl", ":!rubocop %<CR>", { desc = "Lint with Rubocop" })
    end,
  },
  
  -- Rubocop integration with null-ls
  {
    "nvimtools/none-ls.nvim",
    ft = { "ruby", "eruby" },
    config = function()
      local null_ls = require("null-ls")
      
      null_ls.setup({
        sources = {
          -- Linting with Rubocop
          null_ls.builtins.diagnostics.rubocop.with({
            command = function()
              -- Smart detection of Rubocop (bundled or global)
              if vim.fn.filereadable("Gemfile") == 1 and 
                 vim.fn.system("grep -q rubocop Gemfile") == 0 then
                return "bundle exec rubocop"
              else
                return "rubocop"
              end
            end,
            -- Customize based on Launch School style guide
            extra_args = {
              "--config",
              vim.fn.expand("~/.config/rubocop/launch_school.yml"),
              "--format",
              "json",
              "--force-exclusion",
            },
            condition = function(utils)
              return utils.root_has_file({
                ".rubocop.yml",
                "Gemfile",
                ".git",
              })
            end,
          }),
          
          -- Formatting with Rubocop
          null_ls.builtins.formatting.rubocop.with({
            command = function()
              if vim.fn.filereadable("Gemfile") == 1 and 
                 vim.fn.system("grep -q rubocop Gemfile") == 0 then
                return "bundle exec rubocop"
              else
                return "rubocop"
              end
            end,
            -- Launch School style formatting
            extra_args = {
              "--auto-correct",
              "--config",
              vim.fn.expand("~/.config/rubocop/launch_school.yml"),
              "--format",
              "files",
              "--stderr",
              "--stdin",
              "$FILENAME",
            },
            condition = function(utils)
              return utils.root_has_file({
                ".rubocop.yml",
                "Gemfile",
                ".git",
              })
            end,
          }),
          
          -- Documentation linting
          null_ls.builtins.diagnostics.erb_lint.with({
            command = function()
              if vim.fn.filereadable("Gemfile") == 1 then
                return "bundle exec erblint"
              else
                return "erblint"
              end
            end,
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
      
      -- Create a configurable ~/.config/rubocop/launch_school.yml file
      local launch_school_config_dir = vim.fn.expand("~/.config/rubocop")
      local launch_school_config_file = launch_school_config_dir .. "/launch_school.yml"
      
      if vim.fn.isdirectory(launch_school_config_dir) == 0 then
        vim.fn.mkdir(launch_school_config_dir, "p")
      end
      
      if vim.fn.filereadable(launch_school_config_file) == 0 then
        local config = [[
# Launch School Ruby style configuration
AllCops:
  DisplayCopNames: true
  DisplayStyleGuide: true
  NewCops: enable
  TargetRubyVersion: 3.1
  Exclude:
    - '**/vendor/**/*'
    - '**/node_modules/**/*'

# Launch School prefers double quotes for consistency
Style/StringLiterals:
  EnforcedStyle: double_quotes

# Launch School style guide
Layout/LineLength:
  Max: 80

# Disable some cops that are too restrictive for Launch School exercises
Style/Documentation:
  Enabled: false

Style/FrozenStringLiteralComment:
  Enabled: false

Metrics/MethodLength:
  Max: 20

Metrics/AbcSize:
  Max: 30

# Allow puts for Launch School exercises
Style/StderrPuts:
  Enabled: false

# Enable for learning environment
Lint/Debugger:
  Enabled: true
]]
        
        local file = io.open(launch_school_config_file, "w")
        if file then
          file:write(config)
          file:close()
        end
      end
    end,
  },
  
  -- Ruby REPL integration
  {
    "michaelb/sniprun",
    ft = { "ruby" },
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
  
  -- Ruby block text objects
  {
    "kana/vim-textobj-user",
    dependencies = {
      "nelstrom/vim-textobj-rubyblock",
    },
    ft = { "ruby", "eruby" },
    config = function()
      -- Ensure Ruby block awareness with treesitter
      vim.cmd([[runtime macros/matchit.vim]])
    end,
  },
  
  -- Enhanced Rails support
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
  
  -- Enhanced Launch School support with custom functions
  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- Custom templates based on Launch School style guides
      local templates = {
        ruby_file = [[# %s.rb
# Main file content
]],
        test_file = [[# test.rb
require 'minitest/autorun'
require_relative '%s'

class %sTest < Minitest::Test
  def test_example
    # Write your test here
    assert_equal(true, true)
  end
end
]],
        rb_exercise = [[#!/usr/bin/env ruby
# %s.rb - Launch School exercise

# Problem:
# %s
#
# Examples:
#
#
# Data Structure:
#
#
# Algorithm:
#
#
# Code:

]],
        oop_class = [[# %s.rb
# OOP Launch School exercise

class %s
  def initialize
    # Setup initial state
  end
  
  def to_s
    # String representation
  end
end

if __FILE__ == $PROGRAM_NAME
  # Test code here
end
]],
      }
      
      -- Launch School exercise template
      vim.api.nvim_create_user_command("LSExercise", function(opts)
        -- Get exercise name from arguments or prompt
        local name = opts.args
        if name == "" then
          name = vim.fn.input("Exercise name: ")
        end
        
        if name == "" then
          vim.notify("Exercise name required", vim.log.levels.ERROR)
          return
        end
        
        -- Format class name (first letter capital, remove underscores)
        local class_name = name:sub(1,1):upper() .. name:sub(2):gsub("_(%l)", function(c) 
          return c:upper() 
        end)
        
        -- Create the exercise file
        local exercise_file = name .. ".rb"
        if vim.fn.filereadable(exercise_file) == 0 then
          local problem_description = vim.fn.input("Problem description (optional): ")
          local file_content
          
          -- Determine template type
          local template_type = opts.fargs[2] or ""
          if template_type == "oop" then
            file_content = string.format(templates.oop_class, name, class_name)
          else
            file_content = string.format(templates.rb_exercise, name, problem_description)
          end
          
          local f = io.open(exercise_file, "w")
          if f then
            f:write(file_content)
            f:close()
          end
        end
        
        -- Create the test file
        local test_file = "test.rb"
        if vim.fn.filereadable(test_file) == 0 then
          local f = io.open(test_file, "w")
          if f then
            local test_content = string.format(templates.test_file, name, class_name)
            f:write(test_content)
            f:close()
          end
        end
        
        -- Open the exercise file
        vim.cmd("e " .. exercise_file)
        
      end, { nargs = "?", complete = "file" })
      
      -- Add command to create a new Launch School OOP exercise
      vim.api.nvim_create_user_command("LSOOP", function(opts)
        local name = opts.args
        if name == "" then
          name = vim.fn.input("Class name: ")
        end
        
        if name == "" then
          vim.notify("Class name required", vim.log.levels.ERROR)
          return
        end
        
        vim.cmd("LSExercise " .. name .. " oop")
      end, { nargs = "?", complete = "file" })
      
      -- Add command to run Launch School test with debugging
      vim.api.nvim_create_user_command("LSTest", function()
        vim.cmd("!ruby -Ilib:test test.rb")
      end, {})
      
      -- Add command to submit Launch School assignment
      vim.api.nvim_create_user_command("LSSubmit", function(opts)
        local message = opts.args
        if message == "" then
          message = vim.fn.input("Commit message: ")
        end
        
        if message == "" then
          message = "Complete assignment"
        end
        
        -- Add, commit and push
        vim.cmd("!git add . && git commit -m \"" .. message .. "\" && git push")
      end, { nargs = "?" })
    end,
  },
}ri", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = bufnr, desc = "Show Ruby info" })
          
          -- Set up document formatting
          vim.keymap.set("n", "<leader>rf", function()
            vim.lsp.buf.format({ timeout_ms = 2000 })
          end, { buffer = bufnr, desc = "Format Ruby code" })
        end,
      })
      
      -- Configure Steep (Ruby type checker) if available
      if vim.fn.executable("steep") == 1 then
        lspconfig.steep.setup({
          cmd = { "steep", "langserver" },
          root_dir = lspconfig.util.root_pattern("Steepfile", ".git"),
          settings = {
            steep = {
              diagnostics = true,
              typeCheckingMode = "normal", -- Can be "normal" or "strict"
            },
          },
        })
      end
    end,
  },
  
  -- Ruby test runner with improved RSpec and Minitest support
  {
    "nvim-neotest/neotest",
    dependencies = {
      "olimorris/neotest-rspec",
      "zidhuss/neotest-minitest",
    },
    ft = { "ruby" },
    config = function()
      local neotest = require("neotest")
      
      -- Function to detect if file is a Launch School test
      local function is_launch_school_test()
        local filename = vim.fn.expand("%:t")
        return filename == "test.rb"
      end
      
      -- Launch School test adapter
      local launch_school_adapter = {
        name = "launch-school",
        is_test_file = function(file_path)
          return file_path:match("test%.rb$") ~= nil
        end,
        find_position = function(position)
          -- Try to find test method at cursor position
          local file_content = vim.fn.readfile(position.path)
          local line_content = file_content[position.line + 1]
          
          if line_content and line_content:match("def%s+test_") then
            local test_name = line_content:match("def%s+(test_[%w_]+)")
            if test_name then
              return {
                type = "test",
                path = position.path,
                name = test_name,
                range = {
                  start = { line = position.line, character = 0 },
                  ["end"] = { line = position.line, character = #line_content },
                },
              }
            end
          end
          
          -- If not found, return file position
          return {
            type = "file",
            path = position.path,
          }
        end,
        build_spec = function(args)
          local position = args.tree
          local test_name = position.name
          
          if position.type == "test" then
            return {
              command = "ruby",
              args = { "-Ilib:test", position.path, "--name=/" .. test_name .. "$/" },
              context = {
                file = position.path,
                test_name = test_name,
              },
            }
          else
            return {
              command = "ruby",
              args = { "-Ilib:test", position.path },
              context = {
                file = position.path,
              },
            }
          end
        end,
        results = function(spec, result, _)
          result.short = result.output:match("(%d+) runs, %d+ assertions, %d+ failures, %d+ errors")
          
          -- Parse test output
          local tests = {}
          local current_test = nil
          
          for line in result.output:gmatch("[^\r\n]+") do
            local test_start = line:match("1%)%s+([^%(]+)%(")
            local failure = line:match("Failure:")
            local error_line = line:match("Error:")
            
            if test_start then
              current_test = {
                name = test_start:gsub("%s+$", ""),
                status = "failed",
              }
              tests[current_test.name] = current_test
            elseif failure and current_test then
              current_test.errors = current_test.errors or {}
              table.insert(current_test.errors, { message = line })
            elseif error_line and current_test then
              current_test.errors = current_test.errors or {}
              table.insert(current_test.errors, { message = line })
            end
          end
          
          -- If no failures found, mark all as passed
          if next(tests) == nil then
            tests["all"] = { status = "passed" }
          end
          
          return tests
        end,
      }
      
      neotest.setup({
        adapters = {
          require("neotest-rspec")({
            -- Smart command detection for RSpec
            rspec_cmd = function()
              if vim.fn.filereadable("Gemfile") == 1 then
                return "bundle exec rspec"
              else
                return "rspec"
              end
            end,
            -- Framework detection
            framework = function(file_path)
              if file_path:match("_spec%.rb$") then
                return "rspec"
              elseif file_path:match("_test%.rb$") or file_path:match("test%.rb$") then
                return "minitest"
              end
              
              -- Check for spec folder
              local spec_folder = vim.fn.getcwd() .. "/spec"
              if vim.fn.isdirectory(spec_folder) == 1 then
                return "rspec"
              end
              
              -- Check for test folder
              local test_folder = vim.fn.getcwd() .. "/test"
              if vim.fn.isdirectory(test_folder) == 1 then
                return "minitest"
              end
              
              -- Default to RSpec
              return "rspec"
            end,
            -- Better error handling
            transform_spec_path = function(path)
              return path
            end,
          }),
          require("neotest-minitest")({
            -- Smart command detection for Minitest
            test_cmd = function()
              if vim.fn.filereadable("Gemfile") == 1 then
                return "bundle exec ruby -Ilib:test"
              else
                return "ruby -Ilib:test"
              end
            end,
          }),
          -- Add Launch School adapter
          launch_school_adapter,
        },
        -- Default test runner selection based on file pattern
        default_strategy = function(path)
          if path:match("_spec%.rb$") then
            return "rspec"
          elseif path:match("_test%.rb$") then
            return "minitest"
          elseif path:match("test%.rb$") then
            return "launch-school"
          end
          return nil
        end,
        output = {
          enabled = true,
          open_on_run = true,
        },
        diagnostic = {
          enabled = true,
        },
        summary = {
          enabled = true,
          expand_errors = true,
          follow = true,
        },
      })
      
      -- Keymaps for Ruby testing
      vim.keymap.set("n", "<leader>rt", function() 
        if is_launch_school_test() then
          vim.cmd("!ruby -Ilib:test test.rb")
        else
          neotest.run.run() 
        end
      end, { desc = "Run nearest test" })
      
      vim.keymap.set("n", "<leader>rtf", function() 
        if is_launch_school_test() then
          vim.cmd("!ruby -Ilib:test test.rb")
        else
          neotest.run.run(vim.fn.expand("%")) 
        end
      end, { desc = "Run current test file" })
      
      vim.keymap.set("n", "<leader>