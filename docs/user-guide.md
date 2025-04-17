# Mouseless Development Environment - User Guide

This guide provides detailed instructions for using the enhanced mouseless development environment, which combines Neovim, Tmux, and Zsh for a powerful keyboard-driven workflow with specialized support for Python, JavaScript, and data analysis.

## Table of Contents

1. [Introduction](#introduction)
2. [Core Components](#core-components)
3. [Basic Workflow](#basic-workflow)
4. [Neovim Usage](#neovim-usage)
5. [Tmux Usage](#tmux-usage)
6. [Zsh and Terminal Usage](#zsh-and-terminal-usage)
7. [Language-Specific Features](#language-specific-features)
8. [GitHub Integration](#github-integration)
9. [Customization](#customization)
10. [Troubleshooting](#troubleshooting)

## Introduction

The mouseless development environment is designed to maximize productivity by enabling a keyboard-only workflow. By minimizing context switching between keyboard and mouse, you can maintain focus and improve efficiency in your development tasks.

### Key Benefits

- **Speed and Efficiency**: Execute commands quickly without moving your hands from the keyboard
- **Consistent Experience**: Same tooling and shortcuts across different machines and operating systems
- **Customizability**: Every component can be tailored to your specific needs
- **Reduced Strain**: Minimize repetitive mouse movements
- **Cross-Platform**: Works on both macOS and Linux
- **Language-Optimized**: Specialized tools for Python, JavaScript, and data analysis

## Core Components

The environment consists of three primary tools working together:

1. **Neovim**: A highly extensible text editor for efficient code editing
2. **Tmux**: A terminal multiplexer for managing multiple terminal sessions
3. **Zsh**: A powerful shell with enhanced features and customization options

## Basic Workflow

### Starting a Development Session

The environment provides custom commands to quickly start a development session:

```sh
# General development session
mks project_name

# Python-specific session
pyks project_name

# From tmux, create specialized sessions with:
# Prefix + D (Development)
# Prefix + P (Python)
# Prefix + J (JavaScript)
# Prefix + A (Data Analysis)
```

These create new tmux sessions with specialized window layouts for different types of development.

### Project Creation and Navigation

```sh
# Create a new project
mkproject project_name [python|js|web|data]

# Navigate between projects
proj
```

The `mkproject` command sets up a new project with appropriate structure and files for your chosen technology.

## Neovim Usage

### Basic Navigation

- `h`, `j`, `k`, `l`: Move cursor left, down, up, right
- `w`, `b`: Move forward/backward by word
- `0`, `$`: Move to start/end of line
- `gg`, `G`: Move to start/end of file
- `Ctrl-d`, `Ctrl-u`: Scroll half-page down/up
- `Ctrl-f`, `Ctrl-b`: Scroll full-page down/up
- `{`, `}`: Move between paragraphs

### File Management

- `<leader>ff`: Find files with Telescope
- `<leader>fg`: Find text in files with Telescope
- `<leader>e`: Toggle file explorer
- `<leader>fb`: Find open buffers
- `<leader>fr`: Find recently opened files

### Editing Commands

- `i`, `a`: Enter insert mode (at cursor/after cursor)
- `o`, `O`: Insert new line below/above
- `d`, `y`, `p`: Delete, yank (copy), paste
- `<leader>y`: Copy to system clipboard
- `<leader>d`: Delete without yanking
- `u`, `Ctrl-r`: Undo, redo
- `gc`: Toggle comments

### Window Management

- `<leader>sv`: Split window vertically
- `<leader>sh`: Split window horizontally
- `<leader>se`: Make splits equal size
- `<leader>sx`: Close current split
- `Ctrl-h/j/k/l`: Navigate between splits

### Code Navigation and LSP Features

- `gd`: Go to definition
- `gi`: Go to implementation
- `gr`: Find references
- `K`: Show hover documentation
- `<leader>cr`: Rename symbol
- `<leader>ca`: Code actions
- `<leader>cf`: Format code
- `[d`, `]d`: Navigate between diagnostics

### Terminal Integration

- `<leader>tt`: Toggle terminal
- `<leader>tf`: Toggle floating terminal
- `<leader>tv`: Toggle vertical terminal
- `<leader>th`: Toggle horizontal terminal
- `<leader>tg`: Toggle lazygit
- `<leader>tp`: Toggle Python REPL
- `<leader>tn`: Toggle Node.js REPL

### Language-Specific Commands

#### Python
- `<leader>pv`: Select Python virtual environment
- `<leader>pd`: Generate Python docstring
- `<leader>pt`: Run nearest Python test
- `<leader>ptf`: Run Python test file
- `<leader>pr`: Run Python code

#### JavaScript/TypeScript
- `<leader>jo`: Organize imports
- `<leader>ja`: Add missing imports
- `<leader>jf`: Fix all issues
- `<leader>jt`: Run nearest JavaScript test
- `<leader>jtf`: Run JavaScript test file

#### Web Development
- `<leader>wls`: Start live server
- `<leader>wlx`: Stop live server
- `<leader>wp`: Start HTML preview
- `<leader>ws`: Stop HTML preview
- `<leader>wts`: Sort Tailwind CSS classes

#### Data Analysis
- `<leader>du`: Toggle database UI
- `<leader>ds`: Execute SQL query
- `<leader>mi`: Initialize Magma (Jupyter)
- `<leader>me`: Evaluate code in Jupyter
- `<leader>qp`: Preview Quarto document

## Tmux Usage

### Session Management

- `Ctrl-a` + `c`: Create new window
- `Ctrl-a` + `s`: List sessions
- `Ctrl-a` + `$`: Rename session
- `Ctrl-a` + `,`: Rename window
- `Ctrl-a` + `d`: Detach from session
- `tmux ls`: List sessions from terminal
- `tmux attach -t session_name`: Attach to a session

### Project Templates (New!)

- `Ctrl-a` + `D`: Create development session template
- `Ctrl-a` + `P`: Create Python project template
- `Ctrl-a` + `J`: Create JavaScript/Web project template
- `Ctrl-a` + `A`: Create data analysis project template

### Window Navigation

- `Ctrl-a` + `0-9`: Switch to window by number
- `Alt-1` to `Alt-5`: Navigate to window 1-5
- `Alt-Left/Right` or `Alt-h/l`: Previous/next window
- `Ctrl-a` + `Space`: Switch to last active window

### Pane Management

- `Ctrl-a` + `|`: Split vertically
- `Ctrl-a` + `-`: Split horizontally
- `Alt-h/j/k/l`: Navigate between panes
- `Ctrl-a` + `z`: Zoom pane (toggle fullscreen)
- `Ctrl-a` + `x`: Close pane
- `Ctrl-a` + `H/J/K/L`: Resize pane

### Copy Mode

- `Ctrl-a` + `[`: Enter copy mode
- `v`: Start selection (in copy mode)
- `y`: Copy selection (in copy mode)
- `q`: Exit copy mode

## Zsh and Terminal Usage

### Directory Navigation

- `..`: Go up one directory (alias for `cd ..`)
- `...`: Go up two directories
- `proj`: Interactive project navigation with fzf

### Project Management

- `mkproject name type`: Create new project structure
- `pyvenv`: Create/activate Python virtual environment
- `mks name`: Create tmux development session
- `pyks name`: Create Python tmux session
- `kts name`: Kill tmux session

### File Operations

- `ll`: List files with details (alias for `ls -la`)
- `vim` or `vi`: Open Neovim (aliased to `nvim`)
- `vf`: Find and open file with fzf

### Language-Specific Commands

- `py`: Alias for python
- `pyv`: Create Python virtual environment
- `activate`: Activate Python virtual environment
- `pip-update`: Update all pip packages
- `npm-update`: Update all npm packages
- `lsrun`: Run Ruby script with warnings
- `lstest`: Run Ruby test script
- `lslint`: Run Rubocop on Ruby files
- `lsexercise`: Create Launch School exercise files

### GitHub CLI Integration

- `gh_clone username/repo`: Clone and cd into repository
- `gh_create repo-name "description"`: Create a new repository
- `gh_commit_push "commit message"`: Commit and push in one command
- `gh_init_project name type`: Initialize project with GitHub repo
- `ghpr`: Create a pull request (alias for `gh pr create`)
- `ghprs`: Check pull request status
- `ghprl`: List pull requests
- `ghis`: GitHub issues commands
- `ghisc`: Create a GitHub issue

## Language-Specific Features

### Python Development

#### Environment Management
- Use `pyvenv` to create and activate virtual environments
- Select Python environments in Neovim with `<leader>pv`
- Automatic virtual environment activation in tmux sessions

#### Testing and Debugging
- Run tests with `<leader>pt` (nearest test) or `<leader>ptf` (test file)
- Debug Python with integrated debugger using `<leader>dpr`
- Run Python scripts directly with `<leader>pr`

#### Tools and Utilities
- Generate docstrings with `<leader>pd`
- Run code in Jupyter notebooks with Jupynium integration
- Visualize data with integrated plotting tools

### JavaScript Development

#### Project Management
- Check package versions with `<leader>jns`
- Update packages with `<leader>jnu`
- Navigate package.json with enhanced tools

#### Code Quality
- Organize imports with `<leader>jo`
- Add missing imports with `<leader>ja`
- Fix all issues with `<leader>jf`
- Format with Prettier automatically

#### Testing and Debugging
- Run tests with `<leader>jt` (nearest test) or `<leader>jtf` (test file)
- Debug JavaScript with the integrated debugger
- Set breakpoints with `<leader>jdb`

### Web Development

- Live preview with `<leader>wls` (start) and `<leader>wlx` (stop)
- HTML preview with `<leader>wp` (start) and `<leader>ws` (stop)
- Sort Tailwind CSS classes with `<leader>wts`
- Enhanced HTML/CSS editing with Emmet support

### Data Analysis

- Database UI with `<leader>du`
- Execute SQL queries with `<leader>ds`
- Jupyter integration with Magma (`<leader>mi`, `<leader>me`)
- CSV visualization and editing tools
- Quarto document preview with `<leader>qp`

## GitHub Integration

The environment includes custom functions for GitHub operations:

### Repository Management

```sh
# Clone a repository and set up dependencies
gh_clone username/repo

# Create a new repository with README and .gitignore
gh_create my-new-repo "Description of the repo"

# Initialize a local project with GitHub repository
gh_init_project project_name project_type
```

### Development Workflow

```sh
# Commit and push in one command
gh_commit_push "Add new feature"

# Fork a repository and set up upstream
gh_fork_clone username/repo

# Sync fork with upstream
gh_sync_fork
```

### Pull Requests and Issues

```sh
# Create a PR with reviewers
gh_create_pr "Title" "Description" "reviewer1,reviewer2"

# Search through issues
gh_search_issues "search term"

# Launch School specific
ls_submit_assignment "assignment_name"
```

## Customization

All configuration files are stored in their standard locations:

- Neovim: `~/.config/nvim/`
- Tmux: `~/.tmux.conf`
- Zsh: `~/.zshrc`
- GitHub integration: `~/.github-integration.zsh`
- Alacritty: `~/.config/alacritty/alacritty.yml`

### Common Customizations

#### Adding Neovim Plugins

1. Edit `~/.config/nvim/lua/plugins/init.lua`
2. Add the new plugin following the existing format
3. Save and run `:Lazy sync` in Neovim

#### Adding Tmux Plugins

1. Edit `~/.tmux.conf`
2. Add a new line: `set -g @plugin 'username/plugin-name'`
3. Save and press `Ctrl-a` + `I` to install

#### Adding Zsh Aliases

1. Edit `~/.zshrc`
2. Add new aliases in the format: `alias shortcut="command"`
3. Save and run `source ~/.zshrc`

## Troubleshooting

### Testing Your Configuration

Run the included configuration test script:

```sh
~/config_test.sh
```

### Common Issues

#### Neovim Plugin Installation Failed

```sh
nvim --headless "+Lazy! sync" +qa
```

#### Tmux Plugin Installation Failed

```sh
~/.tmux/plugins/tpm/bin/install_plugins
```

#### Zsh Configuration Not Loading

```sh
source ~/.zshrc
```

#### Terminal Colors Not Displaying Correctly

Make sure your terminal supports 256 colors and true color. For Alacritty or iTerm2, check the configuration to ensure proper color support is enabled.

#### Python Environment Issues

If virtual environment detection isn't working:

```sh
# Manually activate the environment
source .venv/bin/activate
# Then in Neovim
:VenvSelect
```

#### JavaScript/TypeScript LSP Not Working

Reinstall the TypeScript language server:

```sh
:Mason
# Find and install typescript-language-server
```

### Getting Help

For more detailed information on each tool:
- Neovim: `:help` command within Neovim
- Tmux: `man tmux` in terminal
- Zsh: `man zsh` in terminal

---

This user guide should help you get started with your enhanced mouseless development environment. As you become more familiar with the tools, you'll discover additional features and shortcuts to further enhance your workflow.