#!/bin/bash

# This script sets up a GitHub repository for the mouseless development environment
# It's meant to be run after you've organized your files according to the repository structure

# Exit on error
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}This script will help you set up a GitHub repository for your mouseless development environment.${NC}"
echo ""

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}GitHub CLI (gh) is not installed. Please install it first.${NC}"
    echo "For macOS: brew install gh"
    echo "For Linux: Follow instructions at https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    exit 1
fi

# Check if user is logged in to GitHub
if ! gh auth status &> /dev/null; then
    echo -e "${BLUE}You need to log in to GitHub first.${NC}"
    gh auth login
fi

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${BLUE}Initializing git repository...${NC}"
    git init
fi

echo -e "${BLUE}What would you like to name your repository? (default: mouseless-dev)${NC}"
read -r repo_name
repo_name=${repo_name:-mouseless-dev}

echo -e "${BLUE}Please provide a short description for your repository:${NC}"
echo -e "${BLUE}(default: A mouseless development environment with Neovim, Tmux, and Zsh)${NC}"
read -r repo_description
repo_description=${repo_description:-"A mouseless development environment with Neovim, Tmux, and Zsh"}

# Create repository structure check
if [ ! -d "config" ]; then
    echo -e "${RED}The 'config' directory doesn't exist. Please organize your files first.${NC}"
    echo "Refer to the repository structure document for guidance."
    exit 1
fi

# Check for essential files
essential_files=(
    "install-macos.sh"
    "install-linux.sh"
    "README.md"
    "config/neovim/init.lua"
    "config/tmux/.tmux.conf"
    "config/zsh/.zshrc"
)

missing_files=false
for file in "${essential_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Missing essential file: $file${NC}"
        missing_files=true
    fi
done

if [ "$missing_files" = true ]; then
    echo -e "${RED}Please add the missing files before proceeding.${NC}"
    exit 1
fi

# Make scripts executable
chmod +x install-macos.sh
chmod +x install-linux.sh

# Create license file if it doesn't exist
if [ ! -f "LICENSE" ]; then
    echo -e "${BLUE}Creating MIT License file...${NC}"
    cat > LICENSE << 'EOL'
MIT License

Copyright (c) 2025 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL
fi

# Create .gitignore
echo -e "${BLUE}Creating .gitignore file...${NC}"
cat > .gitignore << 'EOL'
# macOS
.DS_Store
.AppleDouble
.LSOverride
Icon
._*
.Spotlight-V100
.Trashes

# Linux
*~
.directory
.Trash-*

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini
$RECYCLE.BIN/

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~
\#*\#
.#*

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.npm/
EOL

# Add all files
git add .

# Commit changes
echo -e "${BLUE}Committing files...${NC}"
git commit -m "Initial commit"

# Create GitHub repository
echo -e "${BLUE}Creating GitHub repository: $repo_name${NC}"
gh repo create "$repo_name" --public --description "$repo_description" --source=. --push

echo ""
echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}GitHub repository setup complete!${NC}"
echo -e "${GREEN}====================================================${NC}"
echo ""
echo -e "Your repository is now available at: ${BLUE}https://github.com/$(gh api user | jq -r '.login')/$repo_name${NC}"
echo ""
echo "You can now update the installation instructions in your README.md to point to your repository:"
echo ""
echo "curl -fsSL https://raw.githubusercontent.com/$(gh api user | jq -r '.login')/$repo_name/main/install-macos.sh | zsh"
echo "curl -fsSL https://raw.githubusercontent.com/$(gh api user | jq -r '.login')/$repo_name/main/install-linux.sh | bash"
echo ""
