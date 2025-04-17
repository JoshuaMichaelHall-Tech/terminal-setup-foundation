# Ruby Development with Mouseless Environment

This guide covers the specialized Ruby development features available in the mouseless development environment, including Rails integration, testing, and Launch School support.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Project Management](#project-management)
3. [Syntax and Formatting](#syntax-and-formatting)
4. [Testing](#testing)
5. [Rails Integration](#rails-integration)
6. [Debugging](#debugging)
7. [Ruby REPL Integration](#ruby-repl-integration)
8. [Launch School Support](#launch-school-support)
9. [Project Workflows](#project-workflows)
10. [Common Issues](#common-issues)

## Getting Started

### Creating a Ruby Project

```bash
# Create a new Ruby project with proper structure
mkproject my_project ruby

# Create a new Rails project
rails new my_rails_app

# Create a Launch School exercise
lsexercise exercise_name
```

### Starting a Ruby Development Session

```bash
# Create a Ruby-focused tmux session
mks my_project

# Alternatively, start a new tmux session
tmux new -s ruby_dev
```

## Project Management

### Directory Structure

The default Ruby project structure includes:

```
my_project/
├── lib/
│   └── my_project.rb
├── test/
│   └── test_my_project.rb
├── Gemfile
├── .gitignore
└── README.md
```

For Rails projects:

```
my_rails_app/
├── app/
├── bin/
├── config/
├── db/
├── Gemfile
└── ...
```

### Command Line Tools

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rake test
# or
bundle exec rspec

# Start Rails server
bundle exec rails server

# Rails console
bundle exec rails console
```

## Syntax and Formatting

### Linting and Formatting Tools

The environment includes:
- Rubocop for linting and formatting
- Solargraph for code intelligence

### Usage in Neovim

| Command | Description |
|---------|-------------|
| `<leader>cf` | Format current file |
| `:lua vim.lsp.buf.format()` | Format current buffer |
| `<leader>lsl` | Lint current file with Rubocop |

### Configuration

Linting and formatting are configured with modern Ruby best practices. To customize:

1. Create a `.rubocop.yml` file in your project root
2. For global settings, edit `~/.config/nvim/lua/plugins/lang/ruby.lua`

## Testing

### Test Frameworks

The environment includes support for:
- RSpec
- Minitest

### Running Tests in Neovim

| Command | Description |
|---------|-------------|
| `<leader>rt` | Run nearest test |
| `<leader>rtf` | Run current test file |
| `<leader>rts` | Toggle test summary |
| `<leader>rto` | Open test output |

### Running Tests in Tmux

| Command | Description |
|---------|-------------|
| `<leader>tt` | Run current test file in tmux pane |
| `<leader>tn` | Run nearest test in tmux pane |
| `<leader>lst` | Run Launch School test file |

## Rails Integration

### Rails Navigation

The environment includes vim-rails for enhanced Rails navigation:

| Command | Description |
|---------|-------------|
| `<leader>ra` | Jump to alternate file (e.g., model <-> test) |
| `<leader>rm` | Open Rails model |
| `<leader>rv` | Open Rails view |
| `<leader>rc` | Open Rails controller |
| `<leader>rh` | Open Rails helper |
| `<leader>rj` | Open Rails JavaScript |
| `<leader>rs` | Open Rails stylesheet |
| `:Rroutes` | Open routes.rb |
| `:Rschema` | Open schema.rb |
| `:Rgemfile` | Open Gemfile |

### Rails Commands

From within Neovim, you can run Rails commands:

```vim
:Rails console
:Rails generate model User
:Rails dbconsole
```

## Debugging

### Ruby Debugging

For debugging Ruby applications:

1. Add the debug gem to your Gemfile:
   ```ruby
   gem 'debug', group: :development
   ```

2. Add a debugging statement in your code:
   ```ruby
   require 'debug'; binding.break
   ```

3. Run your code with:
   ```bash
   ruby -r debug your_script.rb
   ```

### Rails Debugging

For debugging Rails applications:

1. Add a debugging statement in your code:
   ```ruby
   binding.break
   ```

2. Start your Rails server in development mode
3. Navigate to the page that will trigger the breakpoint

## Ruby REPL Integration

### Terminal-Based REPL

| Command | Description |
|---------|-------------|
| `irb` | Start Interactive Ruby (IRB) |
| `pry` | Start Pry (if installed) |
| `<leader>rr` | Run Ruby code snippet |
| `<leader>tr` | Run current line in tmux |

### Sending Code to REPL

For sending code to a REPL from Neovim:

| Command | Description |
|---------|-------------|
| `<leader>rc` | Send motion/visual selection to REPL |
| `<leader>rl` | Send current line to REPL |
| `<leader>rf` | Send entire file to REPL |

## Launch School Support

The environment includes special support for Launch School exercises:

### Exercise Creation

```bash
# From the command line
lsexercise exercise_name

# From Neovim
:LSExercise exercise_name
```

This creates:
- An exercise file (exercise_name.rb)
- A test file (test.rb) with Minitest setup

### Launch School Commands

| Command | Description |
|---------|-------------|
| `<leader>lst` | Run Launch School test |
| `<leader>lsf` | Run current Ruby file |
| `<leader>lsc` | Check Ruby syntax |
| `<leader>lsl` | Lint with Rubocop |
| `lsrun` | Run Ruby script with warnings (shell alias) |
| `lstest` | Run test.rb (shell alias) |
| `lslint` | Run Rubocop (shell alias) |
| `lscheck` | Check Ruby syntax (shell alias) |

### Submitting Assignments

```bash
# Commit and push an assignment
ls_submit_assignment "assignment_name" "Completed assignment"
```

## Project Workflows

### Ruby Gem Development

For developing Ruby gems:

```bash
# Create a new gem
bundle gem my_gem

# Build the gem
gem build my_gem.gemspec

# Install locally
gem install ./my_gem-0.1.0.gem
```

### Web Development with Sinatra

For Sinatra web applications:

```bash
# Create a basic Sinatra app
touch app.rb
```

```ruby
# app.rb
require 'sinatra'

get '/' do
  'Hello, World!'
end
```

```bash
# Run the app
bundle exec ruby app.rb
```

## Common Issues

### Ruby LSP Not Working

If Ruby LSP features aren't working:

1. Check if solargraph is installed:
```bash
gem install solargraph
```

2. Generate a solargraph configuration:
```bash
solargraph config
```

3. Check LSP status in Neovim:
```vim
:LspInfo
```

### Bundler Issues

If you're having issues with Bundler:

1. Ensure you have the correct version:
```bash
gem install bundler
```

2. Try clearing the bundle cache:
```bash
bundle clean --force
```

3. Update Bundler:
```bash
gem update bundler
```

### Rails Console Not Working

If Rails console isn't working in Neovim:

1. Make sure you're in a Rails project directory
2. Try running it from the terminal first:
```bash
bundle exec rails console
```

3. Check for any Rails initialization errors

### Testing Framework Issues

If RSpec or Minitest isn't being detected:

1. Ensure the gem is in your Gemfile and installed:
```bash
bundle add rspec
# or
bundle add minitest
```

2. Check for proper test file naming conventions:
   - RSpec: `*_spec.rb`
   - Minitest: `test_*.rb` or `*_test.rb`

3. Make sure test files are in the correct directory:
   - RSpec: `spec/`
   - Minitest: `test/`