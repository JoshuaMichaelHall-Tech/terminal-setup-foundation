# Mouseless Development Environment

A comprehensive development environment optimized for keyboard-only workflows, featuring Neovim, Tmux, and Zsh.

## Core Philosophy

- **Mouseless-first**: All workflows are optimized for keyboard navigation.
- **Modular & Maintainable**: Each component is self-contained and easily swappable.
- **Cross-platform**: macOS and Linux supported equally.
- **GitHub Integrated**: Dotfiles and workflows are version-controlled and portable.
- **Popular & Free Tools**: Avoid obscure, unmaintained dependencies.

## Features

- Neovim configuration with LSP, Treesitter, Telescope, and more
- Tmux setup with sensible defaults and plugins
- Zsh configuration with plugins and useful aliases
- GitHub CLI integration
- Cross-platform support (macOS and Linux)

## Quick Installation

```bash
# For macOS
curl -fsSL https://raw.githubusercontent.com/joshuamichaelhall/mouseless-dev/main/install-macos.sh | zsh

# For Linux (Ubuntu/Debian-based)
curl -fsSL https://raw.githubusercontent.com/joshuamichaelhall/mouseless-dev/main/install-linux.sh | bash
```

## Manual Installation

Clone the repository and run the installation script:

```bash
git clone https://github.com/joshuamichaelhall/mouseless-dev.git
cd mouseless-dev

# For macOS
./install-macos.sh

# For Linux
./install-linux.sh
```

## Components

### Neovim

- LSP support for multiple languages
- Fuzzy finding with Telescope
- Syntax highlighting with Treesitter
- File explorer with nvim-tree
- Git integration with gitsigns and fugitive
- Terminal with toggleterm
- And more...

### Tmux

- Prefix key set to Ctrl-a
- Pane navigation with Alt-hjkl
- Smart session management with tmux-resurrect and tmux-continuum
- Copy to system clipboard with tmux-yank

### Zsh

- Vi mode
- Useful aliases and functions
- GitHub CLI integration
- Project navigation with fzf

## Keybindings

### Neovim

| Key          | Action                 |
|--------------|------------------------|
| `<Space>`    | Leader key             |
| `<leader>ff` | Find files             |
| `<leader>fg` | Find text              |
| `<leader>e`  | Toggle file explorer   |
| `<leader>t`  | Toggle terminal        |
| `<leader>gs` | Git status             |
| `<leader>tr` | Run current line in tmux|
| `<leader>tt` | Run current test file  |

### Tmux

| Key         | Action                 |
|-------------|------------------------|
| `Ctrl-a`    | Prefix key             |
| `Alt-h/j/k/l` | Navigate panes      |
| `prefix \|` | Split pane vertically  |
| `prefix -`  | Split pane horizontally|
| `prefix r`  | Reload config          |
| `Alt-[1-5]` | Navigate to window     |

## Workflow Examples

### Start a Development Session

```bash
# Create and start a named tmux session
mks project_name
```

This creates a new tmux session with 3 windows:
- Window 1: "edit" - For editing code
- Window 2: "test" - For running tests
- Window 3: "git" - For git operations

### Project Navigation

```bash
# Navigate to a project using fzf
proj
```

### GitHub Workflow

```bash
# Clone a repository
gh_clone username/repo

# Create a new repository
gh_create my-new-repo "Description of the repo"

# Commit and push changes
gh_commit_push "Add new feature"
```

### Running Tests in Tmux

1. Open a file in Neovim
2. Press `<leader>tt` to run the entire test file
3. Press `<leader>tn` to run the test nearest to cursor

## Customization

All configuration files are stored in their standard locations:

- Neovim: `~/.config/nvim/`
- Tmux: `~/.tmux.conf`
- Zsh: `~/.zshrc`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgements

This project was developed with assistance from Anthropic's Claude AI assistant, which helped with:
- Documentation writing and organization
- Code structure suggestions
- Troubleshooting and debugging assistance

Claude was used as a development aid while all final implementation decisions and code review were performed by the human developer.
