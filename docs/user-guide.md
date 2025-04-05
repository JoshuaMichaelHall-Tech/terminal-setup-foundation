# Mouseless Development Environment - User Guide

This guide provides detailed instructions for using the mouseless development environment, which combines Neovim, Tmux, and Zsh for a powerful keyboard-driven workflow.

## Table of Contents

1. [Introduction](#introduction)
2. [Core Components](#core-components)
3. [Basic Workflow](#basic-workflow)
4. [Neovim Usage](#neovim-usage)
5. [Tmux Usage](#tmux-usage)
6. [Zsh and Terminal Usage](#zsh-and-terminal-usage)
7. [GitHub Integration](#github-integration)
8. [Customization](#customization)
9. [Troubleshooting](#troubleshooting)

## Introduction

The mouseless development environment is designed to maximize productivity by enabling a keyboard-only workflow. By minimizing context switching between keyboard and mouse, you can maintain focus and improve efficiency in your development tasks.

### Key Benefits

- **Speed and Efficiency**: Execute commands quickly without moving your hands from the keyboard
- **Consistent Experience**: Same tooling and shortcuts across different machines and operating systems
- **Customizability**: Every component can be tailored to your specific needs
- **Reduced Strain**: Minimize repetitive mouse movements
- **Cross-Platform**: Works on both macOS and Linux

## Core Components

The environment consists of three primary tools working together:

1. **Neovim**: A highly extensible text editor for efficient code editing
2. **Tmux**: A terminal multiplexer for managing multiple terminal sessions
3. **Zsh**: A powerful shell with enhanced features and customization options

## Basic Workflow

### Starting a Development Session

The environment provides a custom command to quickly start a development session:

```sh
mks project_name
```

This creates a new tmux session with three windows:
- Window 1: "edit" - For editing code in Neovim
- Window 2: "test" - For running tests
- Window 3: "git" - For git operations

### Project Navigation

To quickly navigate between your projects:

```sh
proj
```

This command uses fzf to find and select a project from your ~/projects and ~/github directories.

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

- `<leader>t`: Toggle terminal
- `<leader>tr`: Run current line in tmux
- `<leader>tt`: Run current test file
- `<leader>tn`: Run nearest test

## Tmux Usage

### Session Management

- `Ctrl-a` + `c`: Create new window
- `Ctrl-a` + `s`: List sessions
- `Ctrl-a` + `$`: Rename session
- `Ctrl-a` + `,`: Rename window
- `Ctrl-a` + `d`: Detach from session
- `tmux ls`: List sessions from terminal
- `tmux attach -t session_name`: Attach to a session

### Window Navigation

- `Ctrl-a` + `0-9`: Switch to window by number
- `Alt-1` to `Alt-5`: Navigate to window 1-5
- `Alt-Left/Right` or `Alt-h/l`: Previous/next window

### Pane Management

- `Ctrl-a` + `|`: Split vertically
- `Ctrl-a` + `-`: Split horizontally
- `Alt-h/j/k/l`: Navigate between panes
- `Ctrl-a` + `z`: Zoom pane (toggle fullscreen)
- `Ctrl-a` + `x`: Close pane

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

### File Operations

- `ll`: List files with details (alias for `ls -la`)
- `vim` or `vi`: Open Neovim (aliased to `nvim`)

### GitHub CLI Integration

- `gh_clone username/repo`: Clone a repository and cd into it
- `gh_create repo-name "description"`: Create a new repository
- `gh_commit_push "commit message"`: Commit and push in one command
- `ghpr`: Create a pull request (alias for `gh pr create`)
- `ghprs`: Check pull request status (alias for `gh pr status`)

## GitHub Integration

The environment includes custom functions for GitHub operations:

### Cloning Repositories

```sh
gh_clone username/repo
```

This clones the repository and changes to the cloned directory.

### Creating Repositories

```sh
gh_create my-new-repo "Description of the repo"
```

This creates a new repository on GitHub, initializes it locally, adds a README with the provided description, and pushes the initial commit.

### Committing and Pushing

```sh
gh_commit_push "Add new feature"
```

This performs git add, commit, and push in a single command.

## Customization

All configuration files are stored in their standard locations:

- Neovim: `~/.config/nvim/`
- Tmux: `~/.tmux.conf`
- Zsh: `~/.zshrc`
- GitHub integration: `~/.github-integration.zsh`

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

Make sure your terminal supports 256 colors. For iTerm2 or terminal app, check the terminal preferences to ensure "xterm-256color" is selected.

### Getting Help

For more detailed information on each tool:
- Neovim: `:help` command within Neovim
- Tmux: `man tmux` in terminal
- Zsh: `man zsh` in terminal

---

This user guide should help you get started with your mouseless development environment. As you become more familiar with the tools, you'll discover additional features and shortcuts to further enhance your workflow.
