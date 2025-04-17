-- plugins/lang/launchschool.lua
-- Custom Launch School project templates and utilities for NeoVim

return {
  -- Launch School templates and utilities
  {
    "nvim-lua/plenary.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Create necessary directories
      local ls_config_dir = vim.fn.expand("~/.config/launchschool")
      if vim.fn.isdirectory(ls_config_dir) == 0 then
        vim.fn.mkdir(ls_config_dir, "p")
      end
      
      -- Project templates for Launch School
      local templates = {
        -- Basic Ruby project
        ruby_project = {
          name = "Ruby Project",
          files = {
            ["lib/main.rb"] = [[# lib/main.rb
# Main Ruby project file

class Main
  def self.run
    puts "Hello from Launch School project!"
  end
end

if __FILE__ == $PROGRAM_NAME
  Main.run
end
]],
            ["test/test_main.rb"] = [[# test/test_main.rb
require 'minitest/autorun'
require_relative '../lib/main'

class MainTest < Minitest::Test
  def test_example
    assert_equal(true, true)
  end
end
]],
            [".rubocop.yml"] = [[# Launch School Ruby style configuration
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
]],
            ["README.md"] = [[# Launch School Ruby Project

## Description

A Ruby project created for Launch School curriculum.

## Installation

```bash
# Clone the repository
git clone [your-repo-url]

# Navigate to the project directory
cd [project-directory]
```

## Usage

```ruby
# Run the main program
ruby lib/main.rb

# Run tests
ruby test/test_main.rb
```

## Structure

- `lib/` - Contains the main Ruby code
- `test/` - Contains test files

## Acknowledgements

This project was developed with assistance from Anthropic's Claude AI assistant, which helped with:
- Documentation writing and organization
- Code structure suggestions
- Troubleshooting and debugging assistance

Claude was used as a development aid while all final implementation decisions and code review were performed by the human developer.

## Disclaimer

This software is provided "as is", without warranty of any kind, express or implied. The authors or copyright holders shall not be liable for any claim, damages or other liability arising from the use of the software.
]],
          },
          dirs = {
            "lib",
            "test",
          },
        },
        
        -- RB109 Assessment preparation
        rb109 = {
          name = "RB109 Assessment Prep",
          files = {
            ["pedac_template.md"] = [[# PEDAC Process

## P: Understanding the Problem

- Establish the rules/requirements
- Define the boundaries of the problem
- Identify implicit/explicit requirements
- Ask clarifying questions if needed
- Examine all examples given

## E: Examples and Test Cases

- Create examples that validate understanding of the problem
- Create edge cases to check boundaries and edge scenarios
- Create examples that handle failures or negative cases

## D: Data Structures

- Determine what data structures to use
- How data will be organized and manipulated

## A: Algorithm

- Write out a step-by-step approach in plain English
- Break down complex problems into smaller, manageable steps
- Avoid solving the problem yet; focus on the approach

## C: Code

- Implement the algorithm
- Test the solution against examples
- Refactor for readability and efficiency
]],
            ["practice_problems/problem1.rb"] = [[# Problem 1
# Description: Write a method that...

# PEDAC Process
# ==============

# Problem:
#  - Input:
#  - Output:
#  - Rules:

# Examples:
#

# Data Structure:
#

# Algorithm:
#

# Code:
def solution(input)
  # Your solution here
end

# Test cases
p solution(1) == 1
p solution(2) == 2
]],
            ["written_assessment_prep.md"] = [[# RB109 Written Assessment Preparation

## Key Concepts to Review

### Variables and Pointers
- Local variables as pointers
- Variable reassignment vs. object mutation

### Object Mutability
- Mutable vs. immutable objects
- Methods that mutate
- Method chaining and return values

### Object Passing
- Pass by reference vs. pass by value
- How different objects are passed in Ruby

### Method Definition and Method Invocation
- Local variable scope in method definitions
- Implicit and explicit return values
- Blocks and variable scope

### Collections
- Array and Hash manipulation
- Iterative methods (`each`, `map`, `select`)
- Nested collections

## Example Answers

### Example 1: Variable Assignment

```ruby
a = "hello"
b = a
a = "goodbye"
puts b
```

This outputs `"hello"` because...

### Example 2: Object Mutation

```ruby
arr1 = ["a", "b", "c"]
arr2 = arr1
arr1[1] = "d"
puts arr2
```

This outputs `["a", "d", "c"]` because...

]],
            ["code_snippets/pass_by_reference.rb"] = [[# Understanding Pass by Reference in Ruby

def modify_array(arr)
  arr << "modified"  # Mutates the original array
end

def reassign_array(arr)
  arr = ["completely", "new", "array"]  # Reassigns the parameter
end

original = ["original"]
modify_array(original)
p original  # => ["original", "modified"]

original = ["original"]
reassign_array(original)
p original  # => ["original"]

# This demonstrates that Ruby is "pass by reference value"
# We can mutate the original object if we use mutating methods,
# but reassigning the parameter only affects the local variable.
]],
          },
          dirs = {
            "practice_problems",
            "code_snippets",
          },
        },
        
        -- Web application project
        sinatra_app = {
          name = "Sinatra Web Application",
          files = {
            ["app.rb"] = [[require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
end

get '/' do
  erb :index
end
]],
            ["Gemfile"] = [[source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'erubis'

group :development do
  gem 'pry'
  gem 'rubocop'
end
]],
            ["views/layout.erb"] = [[<!doctype html>
<html>
  <head>
    <title>Launch School Sinatra App</title>
    <link rel="stylesheet" href="/stylesheets/application.css">
  </head>
  <body>
    <header>
      <h1>Launch School Sinatra App</h1>
    </header>
    
    <main>
      <%== yield %>
    </main>
    
    <footer>
      <p>Developed for Launch School curriculum</p>
    </footer>
  </body>
</html>
]],
            ["views/index.erb"] = [[<h2>Welcome to your Sinatra application!</h2>

<p>This is the index page of your application.</p>
]],
            ["public/stylesheets/application.css"] = [[body {
  font-family: sans-serif;
  max-width: 800px;
  margin: 0 auto;
  padding: 1rem;
  line-height: 1.5;
}

header, footer {
  text-align: center;
  background-color: #f0f0f0;
  padding: 1rem;
  margin: 1rem 0;
}

h1, h2 {
  color: #2c3e50;
}

main {
  min-height: 300px;
}
]],
            ["test/app_test.rb"] = [[ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"
require_relative "../app"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get "/"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Welcome to your Sinatra application"
  end
end
]],
            ["config.ru"] = [[require './app'
run Sinatra::Application
]],
            [".gitignore"] = [[.DS_Store
*.gem
*.rbc
/.config
/coverage/
/InstalledFiles
/pkg/
/spec/reports/
/spec/examples.txt
/test/tmp/
/test/version_tmp/
/tmp/
]],
          },
          dirs = {
            "views",
            "public",
            "public/stylesheets",
            "test",
          },
        },
      }
      
      -- Function to create a project from template
      local function create_project_from_template(template_name, project_name, base_dir)
        -- Check if template exists
        local template = templates[template_name]
        if not template then
          vim.notify("Template not found: " .. template_name, vim.log.levels.ERROR)
          return false
        end
        
        -- Create project directory
        local project_dir = base_dir .. "/" .. project_name
        if vim.fn.isdirectory(project_dir) == 1 then
          vim.notify("Directory already exists: " .. project_dir, vim.log.levels.ERROR)
          return false
        end
        
        vim.fn.mkdir(project_dir, "p")
        
        -- Create subdirectories
        for _, dir in ipairs(template.dirs or {}) do
          vim.fn.mkdir(project_dir .. "/" .. dir, "p")
        end
        
        -- Create files
        for file_path, content in pairs(template.files or {}) do
          local full_path = project_dir .. "/" .. file_path
          local dir_name = vim.fn.fnamemodify(full_path, ":h")
          
          -- Ensure directory exists
          if vim.fn.isdirectory(dir_name) == 0 then
            vim.fn.mkdir(dir_name, "p")
          end
          
          -- Write file content
          local f = io.open(full_path, "w")
          if f then
            f:write(content)
            f:close()
          else
            vim.notify("Failed to create file: " .. full_path, vim.log.levels.ERROR)
          end
        end
        
        -- Initialize git repository
        vim.fn.system("cd " .. vim.fn.shellescape(project_dir) .. " && git init")
        
        -- Success message
        vim.notify("Created " .. template.name .. " project: " .. project_name, vim.log.levels.INFO)
        
        -- Open the project in a new session
        vim.cmd("cd " .. vim.fn.fnameescape(project_dir))
        
        -- Create tmux session if in tmux
        if vim.fn.exists("$TMUX") == 1 then
          vim.fn.system("tmux new-session -d -s " .. vim.fn.shellescape(project_name))
          vim.fn.system("tmux switch-client -t " .. vim.fn.shellescape(project_name))
        end
        
        return true
      end
      
      -- Command to create a new Launch School project
      vim.api.nvim_create_user_command("LSNewProject", function(opts)
        local args = vim.split(opts.args, "%s+")
        local template_name = args[1] or ""
        local project_name = args[2] or ""
        
        -- If no arguments, show template list
        if template_name == "" then
          -- List available templates
          local template_list = "Available templates:\n"
          for name, tpl in pairs(templates) do
            template_list = template_list .. " - " .. name .. ": " .. tpl.name .. "\n"
          end
          
          -- Prompt for template
          print(template_list)
          template_name = vim.fn.input("Template name: ")
          
          if template_name == "" then
            return
          end
        end
        
        -- Prompt for project name if not provided
        if project_name == "" then
          project_name = vim.fn.input("Project name: ")
          
          if project_name == "" then
            return
          end
        end
        
        -- Get base directory
        local base_dir = vim.fn.expand("~/projects")
        if not vim.fn.isdirectory(base_dir) then
          base_dir = vim.fn.expand("~/github")
          
          if not vim.fn.isdirectory(base_dir) then
            base_dir = vim.fn.expand("~")
          end
        end
        
        -- Create project
        create_project_from_template(template_name, project_name, base_dir)
      end, { nargs = "*", complete = function(ArgLead, CmdLine, CursorPos)
        local templates_list = {}
        for name, _ in pairs(templates) do
          if name:match("^" .. ArgLead) then
            table.insert(templates_list, name)
          end
        end
        return templates_list
      end})
      
      -- Create Launch School specific snippets
      vim.api.nvim_create_user_command("LSSnippet", function(opts)
        local snippet_type = opts.args
        
        if snippet_type == "" then
          local snippet_list = "Available snippets:\n"
          snippet_list = snippet_list .. " - pedac: PEDAC problem-solving template\n"
          snippet_list = snippet_list .. " - test: Minitest test class template\n"
          snippet_list = snippet_list .. " - class: Ruby class template\n"
          
          print(snippet_list)
          snippet_type = vim.fn.input("Snippet type: ")
          
          if snippet_type == "" then
            return
          end
        end
        
        -- Insert appropriate snippet
        if snippet_type == "pedac" then
          local content = [[# PEDAC Process

## P: Understanding the Problem

- Establish the rules/requirements
- Define the boundaries of the problem
- Identify implicit/explicit requirements

## E: Examples and Test Cases

- Create examples that validate understanding of the problem
- Create edge cases to check boundaries and edge scenarios

## D: Data Structures

- Determine what data structures to use
- How data will be organized and manipulated

## A: Algorithm

- Write out step-by-step approach in plain English
- Break down complex problems into smaller, manageable steps

## C: Code

# Code implementation
]]
          vim.api.nvim_put(vim.split(content, "\n"), "", true, true)
          
        elseif snippet_type == "test" then
          local class_name = vim.fn.expand("%:t:r"):gsub("^%l", string.upper)
          local content = [[require 'minitest/autorun'
require_relative '../lib/]] .. vim.fn.expand("%:t:r") .. [['

class ]] .. class_name .. [[Test < Minitest::Test
  def test_example
    assert_equal(true, true)
  end
end
]]
          vim.api.nvim_put(vim.split(content, "\n"), "", true, true)
          
        elseif snippet_type == "class" then
          local class_name = vim.fn.expand("%:t:r"):gsub("^%l", string.upper)
          local content = [[class ]] .. class_name .. [[
  def initialize
    # Initialize class attributes
  end
  
  def to_s
    # String representation
  end
end

if __FILE__ == $PROGRAM_NAME
  # Test code here
end
]]
          vim.api.nvim_put(vim.split(content, "\n"), "", true, true)
        end
      end, { nargs = "?", complete = function(ArgLead, CmdLine, CursorPos)
        local snippets = { "pedac", "test", "class" }
        local matches = {}
        for _, snippet in ipairs(snippets) do
          if snippet:match("^" .. ArgLead) then
            table.insert(matches, snippet)
          end
        end
        return matches
      end})
      
      -- Add these to telescope
      if pcall(require, "telescope") then
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        
        -- Create a telescope picker for Launch School templates
        local function ls_projects()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          
          -- Create finder items from templates
          local items = {}
          for name, tpl in pairs(templates) do
            table.insert(items, {
              name = name,
              display = tpl.name,
              description = tpl.name .. " - Launch School template",
            })
          end
          
          -- Create picker
          pickers.new({}, {
            prompt_title = "Launch School Templates",
            finder = finders.new_table({
              results = items,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = entry.name .. ": " .. entry.display,
                  ordinal = entry.name,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
              -- Create new project on selection
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                
                -- Prompt for project name
                local project_name = vim.fn.input("Project name: ")
                if project_name ~= "" then
                  -- Get base directory
                  local base_dir = vim.fn.expand("~/projects")
                  if not vim.fn.isdirectory(base_dir) then
                    base_dir = vim.fn.expand("~/github")
                    
                    if not vim.fn.isdirectory(base_dir) then
                      base_dir = vim.fn.expand("~")
                    end
                  end
                  
                  -- Create project
                  create_project_from_template(selection.value.name, project_name, base_dir)
                end
              end)
              return true
            end,
          }):find()
        end
        
        -- Register the picker
        telescope.register_extension({
          exports = {
            ls_projects = ls_projects,
          },
        })
        
        -- Add keymap for Launch School projects
        vim.keymap.set("n", "<leader>lsp", function()
          ls_projects()
        end, { desc = "Launch School Projects" })
      end
      
      -- Launch School specific tmux session
      vim.api.nvim_create_user_command("LSSession", function(opts)
        local session_name = opts.args or "launch_school"
        
        if session_name == "" then
          session_name = "launch_school"
        end
        
        -- Check if session exists
        local session_exists = vim.fn.system("tmux has-session -t " .. vim.fn.shellescape(session_name) .. " 2>/dev/null; echo $?")
        if session_exists:match("0") then
          -- Switch to existing session
          vim.fn.system("tmux switch-client -t " .. vim.fn.shellescape(session_name))
        else
          -- Create new session with Launch School windows
          vim.fn.system("tmux new-session -d -s " .. vim.fn.shellescape(session_name))
          
          -- Code window
          vim.fn.system("tmux rename-window -t " .. vim.fn.shellescape(session_name) .. ":1 code")
          
          -- Test window
          vim.fn.system("tmux new-window -t " .. vim.fn.shellescape(session_name) .. ":2 -n test")
          
          -- Notes window
          vim.fn.system("tmux new-window -t " .. vim.fn.shellescape(session_name) .. ":3 -n notes")
          
          -- REPL window
          vim.fn.system("tmux new-window -t " .. vim.fn.shellescape(session_name) .. ":4 -n repl")
          vim.fn.system("tmux send-keys -t " .. vim.fn.shellescape(session_name) .. ":4 'irb' Enter")
          
          -- Switch to first window
          vim.fn.system("tmux select-window -t " .. vim.fn.shellescape(session_name) .. ":1")
          
          -- Switch to the session
          vim.fn.system("tmux switch-client -t " .. vim.fn.shellescape(session_name))
        end
      end, { nargs = "?" })
    end,
  }
}