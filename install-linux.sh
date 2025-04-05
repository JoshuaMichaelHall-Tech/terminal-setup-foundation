#!/bin/bash

# Mouseless Development Environment Installer for Linux
# This script installs and configures Neovim, Tmux, and Zsh
# for a mouseless development workflow.

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect GitHub username for dynamic URLs
detect_github_username() {
  if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    gh api user | jq -r '.login' 2>/dev/null || echo "joshuamichaelhall"
  else
    echo "joshuamichaelhall"
  fi
}

GITHUB_USERNAME=$(detect_github_username)

# Check if running from cloned repo or direct download
if [ -d "$(pwd)/config" ]; then
    CONFIG_DIR="$(pwd)/config"
    CLONED_REPO=true
else
    # Create temporary directory for downloading
    TMP_DIR=$(mktemp -d)
    CONFIG_DIR="${TMP_DIR}/config"
    CLONED_REPO=false
    
    echo -e "${BLUE}Downloading configuration files...${NC}"
    curl -fsSL "https://github.com/${GITHUB_USERNAME}/mouseless-dev/archive/refs/heads/main.tar.gz" -o "${TMP_DIR}/mouseless-dev.tar.gz"
    tar -xzf "${TMP_DIR}/mouseless-dev.tar.gz" -C "${TMP_DIR}"
    CONFIG_DIR="${TMP_DIR}/mouseless-dev-main/config"
fi

echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}   Mouseless Development Environment Installer      ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo ""

# Create necessary directories
echo -e "${BLUE}Creating configuration directories...${NC}"
mkdir -p ~/.config/nvim/lua/{core,plugins,utils}

# Update system and install dependencies
echo -e "${BLUE}Updating system package lists...${NC}"
sudo apt update

echo -e "${BLUE}Installing required packages...${NC}"
sudo apt install -y git curl wget build-essential zsh ripgrep fd-find fzf jq

# Install Neovim (AppImage)
if ! command -v nvim &> /dev/null; then
    echo -e "${BLUE}Installing Neovim...${NC}"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
else
    echo -e "${BLUE}Neovim already installed.${NC}"
fi

# Install Tmux
if ! command -v tmux &> /dev/null; then
    echo -e "${BLUE}Installing Tmux...${NC}"
    sudo apt install -y tmux
else
    echo -e "${BLUE}Tmux already installed.${NC}"
fi

# Install Node.js and npm (for LSP support)
if ! command -v node &> /dev/null; then
    echo -e "${BLUE}Installing Node.js and npm...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo -e "${BLUE}Node.js already installed.${NC}"
fi

# Install GitHub CLI
if ! command -v gh &> /dev/null; then
    echo -e "${BLUE}Installing GitHub CLI...${NC}"
    type -p curl >/dev/null || sudo apt install curl -y
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
else
    echo -e "${BLUE}GitHub CLI already installed.${NC}"
fi

# Install VS Code (if desired)
if ! command -v code &> /dev/null; then
    echo -e "${BLUE}Would you like to install Visual Studio Code? [y/N]${NC}"
    read -r install_vscode
    if [[ "$install_vscode" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installing Visual Studio Code...${NC}"
        sudo apt-get install wget gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt update
        sudo apt install -y code
    fi
else
    echo -e "${BLUE}Visual Studio Code already installed.${NC}"
fi

# Install Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo -e "${BLUE}Installing Tmux Plugin Manager...${NC}"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo -e "${BLUE}Tmux Plugin Manager already installed. Updating...${NC}"
    cd ~/.tmux/plugins/tpm && git pull && cd - > /dev/null
fi

# Install Neovim plugin manager (Lazy.nvim)
LAZY_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
    echo -e "${BLUE}Installing Lazy.nvim plugin manager...${NC}"
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
else
    echo -e "${BLUE}Lazy.nvim already installed.${NC}"
fi

# Copy Neovim configuration files
echo -e "${BLUE}Installing Neovim configuration...${NC}"
cp "${CONFIG_DIR}/neovim/init.lua" ~/.config/nvim/
cp -r "${CONFIG_DIR}/neovim/lua/core/"* ~/.config/nvim/lua/core/
cp -r "${CONFIG_DIR}/neovim/lua/plugins/"* ~/.config/nvim/lua/plugins/
cp -r "${CONFIG_DIR}/neovim/lua/utils/"* ~/.config/nvim/lua/utils/

# Copy Tmux configuration
echo -e "${BLUE}Installing Tmux configuration...${NC}"
cp -f "${CONFIG_DIR}/tmux/tmux.conf" ~/.tmux.conf

# Copy Zsh configuration
echo -e "${BLUE}Installing Zsh configuration...${NC}"
cp -f "${CONFIG_DIR}/zsh/zshrc.sh" ~/.zshrc
cp -f "${CONFIG_DIR}/zsh/github-integration.zsh" ~/.github-integration.zsh

# Copy config test script
echo -e "${BLUE}Installing configuration test script...${NC}"
cp -f "${CONFIG_DIR}/../config_test.sh" ~/config_test.sh
chmod +x ~/config_test.sh

# Install Neovim plugins
echo -e "${BLUE}Installing Neovim plugins...${NC}"
nvim --headless "+Lazy! sync" +qa || echo "Plugin installation will complete on first Neovim startup"

# Install Tmux plugins
echo -e "${BLUE}Installing Tmux plugins...${NC}"
~/.tmux/plugins/tpm/bin/install_plugins

# Set up FZF for Zsh
echo -e "${BLUE}Setting up FZF for Zsh...${NC}"
if [ ! -f ~/.fzf.zsh ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${BLUE}Setting Zsh as default shell...${NC}"
    chsh -s $(which zsh)
fi

# Create symbolic link for fd-find (might be called fdfind on Debian/Ubuntu)
if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    echo -e "${BLUE}Creating symlink for fd-find...${NC}"
    mkdir -p ~/.local/bin
    ln -sf $(which fdfind) ~/.local/bin/fd
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# Install recommended terminal (if desired)
echo -e "${BLUE}Would you like to install Alacritty terminal? [y/N]${NC}"
read -r install_alacritty
if [[ "$install_alacritty" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Installing Alacritty terminal...${NC}"
    sudo apt install -y alacritty
    # Create alacritty config directory
    mkdir -p ~/.config/alacritty
    # Create basic config
    cat > ~/.config/alacritty/alacritty.yml << 'EOL'
window:
  padding:
    x: 10
    y: 10
  dynamic_padding: true
  decorations: full
  startup_mode: Windowed
  title: Alacritty
  dynamic_title: true

scrolling:
  history: 10000
  multiplier: 3

font:
  normal:
    family: monospace
    style: Regular
  bold:
    style: Bold
  italic:
    style: Italic
  bold_italic:
    style: Bold Italic
  size: 12.0

cursor:
  style:
    shape: Block
    blinking: On
  vi_mode_style:
    shape: Beam
  blink_interval: 750
  unfocused_hollow: true
  thickness: 0.15

# OneDark theme
colors:
  primary:
    background: '#282c34'
    foreground: '#abb2bf'
  normal:
    black:   '#282c34'
    red:     '#e06c75'
    green:   '#98c379'
    yellow:  '#e5c07b'
    blue:    '#61afef'
    magenta: '#c678dd'
    cyan:    '#56b6c2'
    white:   '#abb2bf'
  bright:
    black:   '#5c6370'
    red:     '#e06c75'
    green:   '#98c379'
    yellow:  '#e5c07b'
    blue:    '#61afef'
    magenta: '#c678dd'
    cyan:    '#56b6c2'
    white:   '#ffffff'

shell:
  program: /bin/zsh
EOL
fi

# Clean up if downloaded
if [ "$CLONED_REPO" = false ]; then
    echo -e "${BLUE}Cleaning up temporary files...${NC}"
    rm -rf "${TMP_DIR}"
fi

echo ""
echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${GREEN}====================================================${NC}"
echo ""
echo "To finalize the setup:"
echo "1. Start a new terminal session or run 'source ~/.zshrc'"
echo "2. Start Tmux with the command 'tmux'"
echo "3. Inside Tmux, press Ctrl-a + I to install Tmux plugins"
echo "4. Open Neovim to automatically install plugins"
echo ""
echo "Run the configuration test with: ~/config_test.sh"
echo ""
echo "Use 'mks project_name' to create a new Tmux development session."
echo ""
echo -e "${GREEN}Enjoy your new mouseless development environment!${NC}"
