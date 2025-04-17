# JavaScript Development with Mouseless Environment

This guide covers the specialized JavaScript and TypeScript development features available in the mouseless development environment, including project setup, testing, debugging, and web development tools.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Project Management](#project-management)
3. [Syntax and Formatting](#syntax-and-formatting)
4. [Testing](#testing)
5. [Debugging](#debugging)
6. [Web Development](#web-development)
7. [Package Management](#package-management)
8. [TypeScript Support](#typescript-support)
9. [Project Workflows](#project-workflows)
10. [Common Issues](#common-issues)

## Getting Started

### Creating a JavaScript Project

```bash
# Create a new JavaScript project with proper structure
mkproject my_app js

# Create a web development project
mkproject my_website web

# Or manually create a project
mkdir -p my_app/src
cd my_app
npm init -y
```

### Starting a JavaScript Development Session

```bash
# Create a JavaScript-focused tmux session
mks my_app

# Alternatively, use the tmux shortcut from any tmux session
# Press Ctrl-a followed by J
```

This creates a specialized session with windows for:
- Editing code
- Running a development server
- Running tests
- JavaScript console

## Project Management

### Directory Structure

The default JavaScript project structure includes:

```
my_app/
├── src/
│   └── index.js
├── package.json
├── .gitignore
└── README.md
```

The web project structure includes:

```
my_website/
├── src/
│   ├── js/
│   │   └── main.js
│   └── css/
│       └── style.css
├── public/
│   └── index.html
├── package.json
├── .gitignore
└── README.md
```

### Command Line Tools

```bash
# Install dependencies
npm install

# Start development server
npm start

# Build for production
npm run build

# Run tests
npm test
```

## Syntax and Formatting

### Linting and Formatting Tools

The environment includes:
- ESLint for linting
- Prettier for code formatting

### Usage in Neovim

| Command | Description |
|---------|-------------|
| `<leader>cf` | Format current file |
| `:lua vim.lsp.buf.format()` | Format current buffer |
| `<leader>jf` | Fix all ESLint issues |

### Configuration

Linting and formatting are configured with modern JavaScript best practices. To customize:

1. Edit `~/.config/nvim/lua/plugins/lang/javascript.lua`
2. Adjust the settings for null-ls sources
3. Save and restart Neovim

## Testing

### Test Runners

The environment includes integration with Jest through:
- neotest for Neovim integration
- npm test in the terminal

### Running Tests in Neovim

| Command | Description |
|---------|-------------|
| `<leader>jt` | Run nearest test |
| `<leader>jtf` | Run current test file |
| `<leader>jts` | Toggle test summary |
| `<leader>jto` | Open test output |

### Running Tests in Tmux

| Command | Description |
|---------|-------------|
| `<leader>tt` | Run current test file in tmux pane |
| `<leader>tn` | Run nearest test in tmux pane |

## Debugging

### Integrated Debugging

The environment includes nvim-dap-vscode-js for debugging JavaScript/TypeScript:

| Command | Description |
|---------|-------------|
| `<leader>jdb` | Toggle breakpoint |
| `<leader>jdc` | Start/continue debugging |
| `<leader>jdi` | Step into |
| `<leader>jdo` | Step over |
| `<leader>jdu` | Step out |

### Debugging Configuration

The debugger is configured to work with Node.js and Chrome. For custom configurations:

1. Edit `~/.config/nvim/lua/plugins/lang/javascript.lua`
2. Adjust the nvim-dap-vscode-js settings
3. Save and restart Neovim

## Web Development

### Live Preview

The environment includes tools for live previewing web projects:

| Command | Description |
|---------|-------------|
| `<leader>wls` | Start live server |
| `<leader>wlx` | Stop live server |
| `<leader>wp` | Start HTML preview |
| `<leader>ws` | Stop HTML preview |
| `<leader>wr` | Reload HTML preview |

### CSS and HTML Tools

| Feature | Description |
|---------|-------------|
| Emmet | Fast HTML/CSS editing with `<C-z>` |
| CSS color preview | Visual display of color values |
| HTML tag auto-closing | Automatic tag completion |
| Tailwind CSS sorter | Sort Tailwind classes with `<leader>wts` |

## Package Management

### Package.json Viewer

The environment includes package-info.nvim for managing npm packages:

| Command | Description |
|---------|-------------|
| `<leader>jns` | Show package versions |
| `<leader>jnh` | Hide package versions |
| `<leader>jnu` | Update package |
| `<leader>jnc` | Change package version |

### Dependency Management

From the command line:

```bash
# Update all packages
npm-update

# Add a dependency
npm install package-name

# Add a dev dependency
npm install --save-dev package-name
```

## TypeScript Support

### TypeScript Tools

The environment includes typescript-tools.nvim for enhanced TypeScript support:

| Command | Description |
|---------|-------------|
| `<leader>jo` | Organize imports |
| `<leader>ja` | Add missing imports |
| `<leader>jf` | Fix all issues |
| `<leader>jr` | Rename file and update imports |

### Type Checking

TypeScript LSP provides real-time type checking with:
- Inline type hints
- Error diagnostics
- Auto-completion with type information

### Configuration

TypeScript is configured for modern projects. To customize:

1. Create a tsconfig.json in your project root
2. The LSP will automatically detect and use your configuration
3. For global settings, edit `~/.config/nvim/lua/plugins/lang/javascript.lua`

## Project Workflows

### React Development

For React projects:

```bash
# Create a React project
mkproject my_react_app js

# Install React dependencies
npm install react react-dom

# Add JSX file
touch src/App.jsx
```

The environment provides special support for React:
- JSX syntax highlighting
- React snippets
- React component auto-completion

### Node.js Development

For Node.js projects:

```bash
# Create a Node.js project
mkproject my_node_app js

# Add Express
npm install express

# Create server file
touch src/server.js
```

Node.js REPL integration:
- Toggle Node REPL with `<leader>tn`
- Run current line in REPL with `<leader>tr`

## Common Issues

### LSP Not Working

If JavaScript/TypeScript LSP features aren't working:

1. Check if tsserver is installed: `:LspInfo`
2. Install if needed: `:Mason` then find and install typescript-language-server
3. Make sure you have a package.json or tsconfig.json in your project
4. Restart Neovim

### Formatting Issues

If Prettier formatting isn't working:

1. Make sure you have prettier installed:
```bash
npm install --save-dev prettier
```
2. Check for a .prettierrc configuration file
3. Try manual formatting with `:lua vim.lsp.buf.format()`

### Testing Not Working

If Jest integration isn't working:

1. Make sure Jest is installed:
```bash
npm install --save-dev jest
```
2. Check your package.json to ensure it has a test script: `"test": "jest"`
3. Make sure test files follow Jest naming conventions (*.test.js or *.spec.js)

### Debugging Issues

If debugging isn't working:

1. Make sure you have the correct debug configuration for your project
2. For Node.js debugging, ensure the application is set up correctly with --inspect
3. For browser debugging, make sure Chrome is running with remote debugging enabled
4. Check the DAP configurations with `:lua require('dap').configurations.javascript`