#!/bin/zsh

# Mouseless Development Environment Installer for macOS
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
mkdir -p ~/.config/nvim/lua/{core,plugins/custom,utils}

# Check for Homebrew installation
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [ -f ~/.zshrc ]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo -e "${BLUE}Homebrew already installed. Updating...${NC}"
    brew update
fi

# Install required tools
echo -e "${BLUE}Installing required packages...${NC}"
brew install neovim tmux ripgrep fzf fd git gh node npm jq

# Check if iTerm2 is already installed
if [ ! -d "/Applications/iTerm.app" ]; then
    echo -e "${BLUE}Would you like to install iTerm2? [y/N]${NC}"
    read -r install_iterm
    if [[ "$install_iterm" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installing iTerm2...${NC}"
        brew install --cask iterm2
        
        # Configure iTerm2 with sensible defaults
        # Create a minimal configuration
        defaults write com.googlecode.iterm2 "PrefsCustomFolder" -string "~/.config/iterm2"
        mkdir -p ~/.config/iterm2
    fi
else
    echo -e "${BLUE}iTerm2 already installed. Skipping...${NC}"
fi

# Check if VS Code is already installed
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
    echo -e "${BLUE}Would you like to install Visual Studio Code? [y/N]${NC}"
    read -r install_vscode
    if [[ "$install_vscode" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Installing Visual Studio Code...${NC}"
        brew install --cask visual-studio-code
    fi
else
    echo -e "${BLUE}Visual Studio Code already installed. Skipping...${NC}"
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
mkdir -p ~/.config/nvim/lua/plugins/custom
cp "${CONFIG_DIR}/neovim/lua/plugins/custom/tmux.lua" ~/.config/nvim/lua/plugins/custom/

# Copy Tmux configuration
echo -e "${BLUE}Installing Tmux configuration...${NC}"
cp -f "${CONFIG_DIR}/tmux/tmux.conf" ~/.tmux.conf

# Copy Zsh configuration
echo -e "${BLUE}Installing Zsh configuration...${NC}"
cp -f "${CONFIG_DIR}/zsh/zshrc" ~/.zshrc
cp -f "${CONFIG_DIR}/zsh/github-integration.zsh" ~/.github-integration.zsh

# Copy config test script
echo -e "${BLUE}Installing configuration test script...${NC}"
cp -f "config_test.sh" ~/config_test.sh
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
    $(brew --prefix)/opt/fzf/install --all --no-bash --no-fish
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${BLUE}Setting Zsh as default shell...${NC}"
    chsh -s $(which zsh)
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
if [[ "$install_iterm" =~ ^[Yy]$ ]]; then
    echo "iTerm2 Tips:"
    echo "- Open iTerm2 Preferences > Profiles > Keys"
    echo "- Click 'Load Preset...' and select 'Natural Text Editing'"
    echo "- This enables common keyboard shortcuts like Option+Arrow to move by word"
    echo ""
fi
echo -e "${GREEN}Enjoy your new mouseless development environment!${NC}"
