# Mouseless Development Environment

A comprehensive development environment optimized for keyboard-only workflows, featuring Neovim, Tmux, and Zsh with enhanced support for Python, JavaScript, Ruby, and data analysis.

## Core Philosophy

- **Mouseless-first**: All workflows are optimized for keyboard navigation.
- **Modular & Maintainable**: Each component is self-contained and easily swappable.
- **Cross-platform**: macOS and Linux supported equally.
- **GitHub Integrated**: Dotfiles and workflows are version-controlled and portable.
- **Popular & Free Tools**: Avoid obscure, unmaintained dependencies.

## Features

### Core Tools
- Neovim configuration with LSP, Treesitter, Telescope, and more
- Tmux setup with sensible defaults and plugins
- Zsh configuration with plugins and useful aliases
- GitHub CLI integration
- Cross-platform support (macOS and Linux)

### Language-Specific Support
- **Python**: Virtual environments, testing, debugging, docstring generation, and data analysis tools
- **JavaScript/TypeScript**: Type hints, testing, package management, and debugging
- **Ruby**: Rails navigation, RSpec/Minitest integration, Launch School support
- **Web Development**: HTML/CSS tools, live preview, Tailwind integration
- **Data Analysis**: DataFrame visualizations, SQL integration, Jupyter notebook support

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
- Language-specific plugins for Python, JavaScript, Ruby, and data analysis
- Enhanced code completion with nvim-cmp
- AI-powered assistance with Copilot and Tabnine

### Tmux

- Prefix key set to Ctrl-a
- Pane navigation with Alt-hjkl
- Project-specific session templates
- Session persistence with tmux-resurrect and tmux-continuum
- Copy to system clipboard with tmux-yank
- Enhanced status bar with project information

### Zsh

- Vi mode
- Useful aliases and functions
- GitHub CLI integration
- Project navigation with fzf
- Language-specific workflow helpers
- Launch School specific functions

## Documentation

- [Getting Started](docs/getting-started.md) - Quick start guide for new users
- [User Guide](docs/user-guide.md) - Detailed instructions for using the environment
- [Training Guide](docs/training-guide.md) - Structured approach to mastering mouseless development
- [Command Reference](docs/command-reference.md) - Printable cheat sheet of all commands
- **Language Guides**:
  - [Python Development](docs/language-guides/python-development.md)
  - [JavaScript Development](docs/language-guides/javascript-development.md)
  - [Ruby Development](docs/language-guides/ruby-development.md)

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
| `<leader>tn` | Run nearest test       |
| `<leader>pv` | Select Python venv     |
| `<leader>jo` | Organize JS imports    |
| `<leader>ra` | Rails alternate file   |

### Tmux

| Key         | Action                 |
|-------------|------------------------|
| `Ctrl-a`    | Prefix key             |
| `Alt-h/j/k/l` | Navigate panes      |
| `prefix \|` | Split pane vertically  |
| `prefix -`  | Split pane horizontally|
| `prefix r`  | Reload config          |
| `Alt-[1-5]` | Navigate to window     |
| `prefix D`  | Create dev session     |
| `prefix P`  | Create Python session  |
| `prefix J`  | Create JS session      |

## Workflow Examples

### Start a Development Session

```bash
# Create and start a named tmux session
mks project_name

# Create a Python-specific tmux session
pyks project_name
```

### Python Development

```bash
# Create a Python project
mkproject myproject python

# Activate virtual environment
pyvenv

# Run tests
<leader>tt  # Run test file
<leader>tn  # Run nearest test
```

### JavaScript Development

```bash
# Create a JavaScript project
mkproject myapp js

# Run tests
<leader>jt  # Run test file

# Fix code issues
<leader>jf  # Fix all issues
```

### Ruby Development

```bash
# Create a Ruby project
mkproject myproject ruby

# Create a Launch School exercise
lsexercise exercise_name

# Run tests
<leader>rt   # Run test (RSpec/Minitest)
<leader>lst  # Run Launch School test
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

## Customization

All configuration files are stored in their standard locations:

- Neovim: `~/.config/nvim/`
- Tmux: `~/.tmux.conf`
- Zsh: `~/.zshrc`
- GitHub integration: `~/.github-integration.zsh`
- Alacritty: `~/.config/alacritty/alacritty.yml`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Disclaimer

This software is provided "as is", without warranty of any kind, express or implied. The authors or copyright holders shall not be liable for any claim, damages or other liability arising from the use of the software.

This project is a work in progress and may contain bugs or incomplete features. Users are encouraged to report any issues they encounter.

## Acknowledgements

This project was developed with assistance from Anthropic's Claude AI assistant, which helped with:
- Documentation writing and organization
- Code structure suggestions
- Troubleshooting and debugging assistance

Claude was used as a development aid while all final implementation decisions and code review were performed by Joshua Michael Hall. 