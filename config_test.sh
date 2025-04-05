#!/bin/bash
# config_test.sh - Test configuration file loading

set -e
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo "====================================================="
echo "Mouseless Development Environment - Configuration Test"
echo "====================================================="
echo ""

# Check dependencies
check_dependency() {
  if ! command -v "$1" &> /dev/null; then
    echo -e "${RED}✗ $1 is not installed${NC}"
    return 1
  else
    echo -e "${GREEN}✓ $1 is installed${NC}"
    return 0
  fi
}

echo "Checking dependencies..."
DEPS_OK=true
for dep in nvim tmux zsh git gh; do
  if ! check_dependency "$dep"; then
    DEPS_OK=false
  fi
done

if [ "$DEPS_OK" = false ]; then
  echo -e "${YELLOW}Please install missing dependencies before continuing${NC}"
  exit 1
fi

function test_neovim() {
  echo -e "\nTesting Neovim configuration..."
  if nvim --headless -c "lua print('Neovim config test')" -c "q" 2>&1 | grep -q "Neovim config test"; then
    echo -e "${GREEN}✓ Neovim configuration loads successfully${NC}"
    return 0
  else
    echo -e "${RED}✗ Neovim configuration failed to load${NC}"
    echo -e "${YELLOW}Try running 'nvim --headless -c \"checkhealth\"' for more details${NC}"
    return 1
  fi
}

function test_tmux() {
  echo -e "\nTesting Tmux configuration..."
  if tmux -f ~/.tmux.conf new-session -d "echo Testing tmux config" && tmux kill-server; then
    echo -e "${GREEN}✓ Tmux configuration loads successfully${NC}"
    return 0
  else
    echo -e "${RED}✗ Tmux configuration failed to load${NC}"
    echo -e "${YELLOW}Check for syntax errors in ~/.tmux.conf${NC}"
    return 1
  fi
}

function test_zsh() {
  echo -e "\nTesting Zsh configuration..."
  if zsh -c "source ~/.zshrc && echo Zsh config test" 2>&1 | grep -q "Zsh config test"; then
    echo -e "${GREEN}✓ Zsh configuration loads successfully${NC}"
    return 0
  else
    echo -e "${RED}✗ Zsh configuration failed to load${NC}"
    echo -e "${YELLOW}Check for syntax errors in ~/.zshrc${NC}"
    return 1
  fi
}

function test_github_integration() {
  echo -e "\nTesting GitHub CLI integration..."
  if zsh -c "source ~/.github-integration.zsh && type gh_clone > /dev/null && echo GitHub integration test" 2>&1 | grep -q "GitHub integration test"; then
    echo -e "${GREEN}✓ GitHub integration loads successfully${NC}"
    return 0
  else
    echo -e "${RED}✗ GitHub integration failed to load${NC}"
    echo -e "${YELLOW}Check for syntax errors in ~/.github-integration.zsh${NC}"
    return 1
  fi
}

function test_neovim_plugins() {
  echo -e "\nTesting Neovim plugins..."
  local plugin_status=$(nvim --headless +'lua local plugins_ok = pcall(require, "lazy.status"); print(plugins_ok)' +qa 2>&1 | grep -o "true\|false")
  
  if [ "$plugin_status" = "true" ]; then
    echo -e "${GREEN}✓ Neovim plugin manager is working${NC}"
    local plugin_count=$(nvim --headless +'lua local status = require("lazy.status"); print(status.stats().loaded .. "/" .. status.stats().count)' +qa 2>&1 | grep -o "[0-9]*/[0-9]*")
    echo -e "${GREEN}✓ Plugins loaded: $plugin_count${NC}"
    return 0
  else
    echo -e "${RED}✗ Neovim plugin manager not working${NC}"
    echo -e "${YELLOW}Try running 'nvim --headless -c \"Lazy! sync\"' to install plugins${NC}"
    return 1
  fi
}

function test_tmux_plugins() {
  echo -e "\nTesting Tmux plugins..."
  if [ -d ~/.tmux/plugins/tpm ]; then
    echo -e "${GREEN}✓ Tmux Plugin Manager is installed${NC}"
    local plugin_count=$(find ~/.tmux/plugins -mindepth 1 -maxdepth 1 -type d | wc -l)
    echo -e "${GREEN}✓ Tmux plugins found: $((plugin_count-1))${NC}"
    return 0
  else
    echo -e "${RED}✗ Tmux Plugin Manager not installed${NC}"
    echo -e "${YELLOW}Install TPM with: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm${NC}"
    return 1
  fi
}

# Run all tests
ERRORS=0
test_neovim || ((ERRORS++))
test_tmux || ((ERRORS++))
test_zsh || ((ERRORS++))
test_github_integration || ((ERRORS++))
test_neovim_plugins || ((ERRORS++))
test_tmux_plugins || ((ERRORS++))

echo -e "\n====================================================="
if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}All configuration tests passed! Your mouseless environment is ready.${NC}"
  echo -e "\nTip: Start a new tmux development session with: mks project_name"
else
  echo -e "${RED}$ERRORS test(s) failed. Please fix the issues above.${NC}"
  echo -e "\nFor more help, visit: https://github.com/yourusername/mouseless-dev#troubleshooting"
fi
echo -e "====================================================="
