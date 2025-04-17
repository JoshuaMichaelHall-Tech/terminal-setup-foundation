# Mouseless Development Environment - Getting Started Guide

This quick reference guide will help you set up and start using the mouseless development environment with minimal effort.

## Installation

### Prerequisites

- Git
- A Unix-based system (macOS or Linux)

### Quick Install

#### macOS 

```bash
curl -fsSL https://raw.githubusercontent.com/joshuamichaelhall/mouseless-dev/main/install-macos.sh | zsh
```

#### Linux (Ubuntu/Debian-based)

```bash
curl -fsSL https://raw.githubusercontent.com/joshuamichaelhall/mouseless-dev/main/install-linux.sh | bash
```

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/joshuamichaelhall/mouseless-dev.git
   cd mouseless-dev
   ```

2. Run the appropriate installation script:
   ```bash
   # For macOS
   ./install-macos.sh
   
   # For Linux
   ./install-linux.sh
   ```

## Post-Installation Setup

1. Start a new terminal session or run:
   ```bash
   source ~/.zshrc
   ```

2. Start a tmux session:
   ```bash
   tmux
   ```

3. Inside tmux, press `Ctrl-a` then `I` to install tmux plugins.

4. Open Neovim to finish installing plugins:
   ```bash
   nvim
   ```

## Essential Keybindings

### Tmux

- `Ctrl-a`: Prefix key for tmux commands
- `Prefix + |`: Split pane vertically
- `Prefix + -`: Split pane horizontally
- `Alt + h/j/k/l`: Navigate between panes
- `Prefix + d`: Detach from session
- `Prefix + c`: Create new window
- `Alt + 1-5`: Switch to window 1-5

### Neovim

- `<Space>`: Leader key
- `<leader>ff`: Find files
- `<leader>fg`: Find text
- `<leader>e`: File explorer
- `<leader>t`: Toggle terminal
- `<leader>bd`: Delete buffer
- `Ctrl-h/j/k/l`: Navigate splits

### Development Workflow

- `mks project_name`: Create a new tmux development session
- `proj`: Navigate to a project directory
- `<leader>tr`: Run current line/selection in tmux
- `<leader>tt`: Run current test file
- `<leader>tn`: Run nearest test
- `gh_clone username/repo`: Clone a GitHub repository

## Language-Specific Features

### Python Development

1. Create a new Python project:
   ```bash
   mkproject my_project python
   ```

2. Set up a Python development environment:
   ```bash
   pyvenv
   ```

3. Start a Python tmux session:
   ```bash
   pyks my_project
   ```

4. Use Python-specific plugins in Neovim:
   - `<leader>pv`: Select Python virtual environment
   - `<leader>pd`: Generate Python docstring
   - `<leader>pt`: Run Python test

### JavaScript Development

1. Create a new JavaScript project:
   ```bash
   mkproject my_project js
   ```

2. Use JavaScript-specific plugins in Neovim:
   - `<leader>jo`: Organize imports
   - `<leader>jf`: Fix all issues
   - `<leader>jt`: Run JavaScript test

## Getting Help

- Run `~/config_test.sh` to verify your installation
- Access help in Neovim with `:help`
- View keybindings in Neovim with `:WhichKey <leader>`
- List tmux keybindings with `Prefix + ?`

## Next Steps

For more detailed information:
- [User Guide](user-guide.md): Comprehensive documentation
- [Training Guide](training-guide.md): Structured approach to mastering the environment
- [Command Reference](command-reference.md): Complete list of commands and keybindings

## Troubleshooting

### Common Issues

1. **Missing fonts**:
   Install a Nerd Font compatible font like JetBrainsMono Nerd Font.

2. **Plugin installation issues**:
   ```bash
   # For Neovim
   nvim --headless "+Lazy! sync" +qa
   
   # For Tmux
   ~/.tmux/plugins/tpm/bin/install_plugins
   ```

3. **Terminal color issues**:
   Ensure your terminal supports 256 colors and true color.

### Getting Further Help

If you encounter issues not covered here, please open an issue on the [GitHub repository](https://github.com/joshuamichaelhall/mouseless-dev).