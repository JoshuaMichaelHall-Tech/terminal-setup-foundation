# Python Development with Mouseless Environment

This guide covers the specialized Python development features available in the mouseless development environment, including virtual environment management, testing, debugging, and data analysis tools.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Virtual Environment Management](#virtual-environment-management)
3. [Syntax and Formatting](#syntax-and-formatting)
4. [Testing](#testing)
5. [Debugging](#debugging)
6. [Data Analysis](#data-analysis)
7. [Jupyter Integration](#jupyter-integration)
8. [Python REPL Integration](#python-repl-integration)
9. [Project Workflows](#project-workflows)
10. [Common Issues](#common-issues)

## Getting Started

### Creating a Python Project

```bash
# Create a new Python project with proper structure
mkproject my_project python

# Or manually create a Python project structure
mkdir -p my_project/src my_project/tests
cd my_project
python -m venv .venv
```

### Starting a Python Development Session

```bash
# Create a Python-focused tmux session
pyks my_project

# Alternatively, use the tmux shortcut from any tmux session
# Press Ctrl-a followed by P
```

This creates a specialized session with windows for:
- Editing Python code
- Python shell with activated virtual environment
- Running tests
- Git operations

## Virtual Environment Management

### Command Line Tools

```bash
# Create and activate a virtual environment
pyvenv

# Manual activation
source .venv/bin/activate
```

The `pyvenv` function will:
1. Create a virtual environment if it doesn't exist
2. Activate the environment
3. Update pip
4. Install dependencies from requirements.txt if it exists

### Neovim Integration

The environment includes the [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim) plugin for virtual environment management:

| Command | Description |
|---------|-------------|
| `<leader>pv` | Select Python virtual environment |
| `<leader>pc` | Select from cached virtual environments |
| `:VenvSelect` | Select virtual environment |
| `:VenvSelectCached` | Select from cached environments |

The virtual environment will be automatically activated for:
- LSP features (completion, diagnostics)
- Linting and formatting
- Python execution

## Syntax and Formatting

### Linting and Formatting Tools

The environment includes:
- Flake8 for linting
- Black for code formatting
- isort for import sorting
- MyPy for type checking

### Usage in Neovim

| Command | Description |
|---------|-------------|
| `<leader>cf` | Format current file |
| `:lua vim.lsp.buf.format()` | Format current buffer |
| `:lua vim.diagnostic.open_float()` | View diagnostics |

### Configuration

Linting and formatting are configured with default Python best practices. To customize:

1. Edit `~/.config/nvim/lua/plugins/lang/python.lua`
2. Adjust the settings for null-ls sources
3. Save and restart Neovim

## Testing

### Test Runners

The environment includes integration with pytest through:
- neotest for Neovim integration
- pytest directly in the terminal

### Running Tests in Neovim

| Command | Description |
|---------|-------------|
| `<leader>pt` | Run nearest test |
| `<leader>ptf` | Run current test file |
| `<leader>pts` | Toggle test summary |
| `<leader>pto` | Open test output |

### Running Tests in Tmux

| Command | Description |
|---------|-------------|
| `<leader>tt` | Run current test file in tmux pane |
| `<leader>tn` | Run nearest test in tmux pane |

## Debugging

### Integrated Debugging

The environment includes nvim-dap-python for debugging Python code:

| Command | Description |
|---------|-------------|
| `<leader>dpr` | Debug Python test method |
| `<leader>dpc` | Debug Python test class |
| `<leader>dpf` | Debug Python test file |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Start/continue debugging |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>du` | Step out |

### Debugging Configuration

The debugger is configured to work with Python's debugpy. For custom configurations:

1. Edit `~/.config/nvim/lua/plugins/lang/python.lua`
2. Adjust the nvim-dap-python settings
3. Save and restart Neovim

## Data Analysis

### Dataframe Visualization

The environment includes tools for working with tabular data:

| Tool | Description |
|------|-------------|
| rainbow_csv.nvim | CSV visualization and editing |
| kakoune-csv.nvim | Advanced CSV operations |

### CSV Operations

| Command | Description |
|---------|-------------|
| `<leader>csa` | Add CSV column |
| `<leader>csd` | Delete CSV column |
| `<leader>csf` | Float CSV column |

### Database Integration

| Command | Description |
|---------|-------------|
| `<leader>du` | Toggle database UI |
| `<leader>df` | Find DB buffer |
| `<leader>dr` | Rename DB buffer |
| `<leader>dq` | Show last query |
| `<leader>ds` | Execute SQL query |

## Jupyter Integration

### Jupynium for Neovim

The environment includes [jupynium.nvim](https://github.com/kiyoon/jupynium.nvim) for working with Jupyter notebooks:

| Command | Description |
|---------|-------------|
| `:JupyniumStartSync` | Start Jupyter server |
| `:JupyniumStopSync` | Stop Jupyter server |
| `:JupyniumExecuteCell` | Execute current cell |

### Magma Integration

For inline execution within Neovim:

| Command | Description |
|---------|-------------|
| `<leader>mi` | Initialize Magma |
| `<leader>me` | Evaluate line |
| `<leader>mc` | Reevaluate cell |
| `<leader>md` | Delete cell |
| `<leader>mo` | Show output |

### Quarto Integration

For data science documents:

| Command | Description |
|---------|-------------|
| `<leader>qp` | Preview Quarto document |
| `<leader>qq` | Close Quarto preview |
| `<leader>qr` | Run Quarto cell |

## Python REPL Integration

### Terminal-Based REPL

| Command | Description |
|---------|-------------|
| `<leader>tp` | Toggle Python REPL |
| `<leader>tr` | Run current line in tmux |
| `<leader>pr` | Run Python code snippet |

### Iron.nvim Integration

For sending code to REPL from Neovim:

| Command | Description |
|---------|-------------|
| `<leader>rc` | Send motion/visual selection to REPL |
| `<leader>rl` | Send current line to REPL |
| `<leader>rf` | Send entire file to REPL |

## Project Workflows

### Python Project Templates

The environment includes templates for common Python project types:

1. Basic Python project:
```bash
mkproject my_project python
```

2. Data analysis project:
```bash
mkproject my_analysis data
```

### Python Docstring Generation

Generate Google-style docstrings with neogen:

| Command | Description |
|---------|-------------|
| `<leader>pd` | Generate Python docstring |

## Common Issues

### Virtual Environment Not Detected

If your virtual environment isn't being detected:

1. Make sure it's in the standard location (.venv in project root)
2. Manually activate with `source .venv/bin/activate`
3. Use `<leader>pv` to manually select it in Neovim

### LSP Not Working

If Python LSP features aren't working:

1. Check if pyright is installed: `:LspInfo`
2. Install if needed: `:Mason` then find and install pyright
3. Restart Neovim

### Testing Not Working

If pytest integration isn't working:

1. Make sure pytest is installed in your virtual environment:
```bash
pip install pytest
```
2. Check if test files follow the naming convention (test_*.py or *_test.py)
3. Make sure the pytest module is discoverable (in PYTHONPATH)

### Debugging Issues

If debugging isn't working:

1. Make sure debugpy is installed:
```bash
pip install debugpy
```
2. Check your DAP configuration with `:lua require('dap').configurations.python`
3. Try manual configuration with `:lua require('dap-python').setup('path/to/python')` where path/to/python is your virtual environment Python