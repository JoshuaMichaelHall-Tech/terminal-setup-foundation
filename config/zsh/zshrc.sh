# ~/.zshrc - Enhanced for mouseless development environment

# ====================
# = General settings =
# ====================

# Set vi mode
bindkey -v

# Path configuration
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
setopt COMPLETE_ALIASES

# ====================
# = Aliases          =
# ====================

# Default command improvements
alias vim="nvim"
alias vi="nvim"
alias ls="ls -G"
alias ll="ls -la"
alias la="ls -A"
alias grep="grep --color=auto"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# Git shortcuts
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias gb="git branch"
alias gd="git diff"
alias glog="git log --oneline --decorate --graph"

# Tmux
alias ta="tmux attach -t"
alias tl="tmux list-sessions"
alias tk="tmux kill-session -t"
alias td="tmux detach"

# Development
alias py="python"
alias pyv="python -m venv .venv"
alias activate="source .venv/bin/activate"
alias pip-update="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U"
alias npm-update="npm update -g"

# System
alias update-system="echo 'Updating system packages...' && (command -v apt > /dev/null && sudo apt update && sudo apt upgrade -y) || (command -v brew > /dev/null && brew update && brew upgrade)"
alias ports="netstat -tulanp"
alias mem="free -m"

# Launch School specific
alias lsrun="ruby -w"
alias lstest="ruby -w test.rb"
alias lslint="rubocop"
alias lscheck="ruby -c"

# ====================
# = Functions        =
# ====================

# Create and activate Python virtual environment
pyvenv() {
  if [ -d ".venv" ]; then
    echo "Virtual environment already exists. Activating..."
    source .venv/bin/activate
  else
    echo "Creating and activating virtual environment..."
    python -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip

    # Check if requirements.txt exists
    if [ -f "requirements.txt" ]; then
      echo "Installing dependencies from requirements.txt..."
      pip install -r requirements.txt
    else
      echo "No requirements.txt found. Do you want to create one? (y/n)"
      read answer
      if [[ "$answer" =~ ^[Yy]$ ]]; then
        touch requirements.txt
        echo "Created empty requirements.txt"
      fi
    fi
  fi
}

# Create a new project directory with common files
mkproject() {
  if [ -z "$1" ]; then
    echo "Usage: mkproject <project_name> [python|js|web|data]"
    return 1
  fi

  local project_name=$1
  local project_type=${2:-"python"}  # Default to Python

  mkdir -p "$project_name"
  cd "$project_name" || return

  # Create .gitignore
  curl -s https://www.toptal.com/developers/gitignore/api/$project_type > .gitignore
  echo ".DS_Store" >> .gitignore
  echo ".vscode/" >> .gitignore
  echo ".idea/" >> .gitignore

  # Create README.md
  cat > README.md << EOF
# $project_name

## Description

Brief description of your project.

## Installation

\`\`\`bash
# Installation instructions
\`\`\`

## Usage

\`\`\`bash
# Usage examples
\`\`\`

## Acknowledgements

This project was developed with assistance from Anthropic's Claude AI assistant, which helped with:
- Documentation writing and organization
- Code structure suggestions
- Troubleshooting and debugging assistance

Claude was used as a development aid while all final implementation decisions and code review were performed by the human developer.
EOF

  # Project type specific setup
  case $project_type in
    python)
      python -m venv .venv
      source .venv/bin/activate
      pip install --upgrade pip
      touch requirements.txt
      mkdir -p src tests
      touch src/__init__.py tests/__init__.py
      touch src/main.py
      ;;
    js|javascript)
      npm init -y
      mkdir -p src public
      touch src/index.js public/index.html
      ;;
    web)
      npm init -y
      mkdir -p src/js src/css public
      touch src/js/main.js src/css/style.css public/index.html
      ;;
    data)
      python -m venv .venv
      source .venv/bin/activate
      pip install --upgrade pip
      pip install numpy pandas matplotlib jupyter
      mkdir -p data notebooks src
      touch notebooks/analysis.ipynb src/process.py
      ;;
    *)
      echo "Unknown project type: $project_type"
      ;;
  esac

  # Initialize git
  git init
  git add .
  git commit -m "Initial project setup"

  echo "Project $project_name created successfully!"
  echo "Type 'mks $project_name' to start a tmux session for this project."
}

# Launch School exercise setup
lsexercise() {
  if [ -z "$1" ]; then
    echo "Usage: lsexercise <exercise_name>"
    return 1
  fi

  local exercise_name=$1
  mkdir -p "$exercise_name"
  cd "$exercise_name" || return
  
  # Create basic structure for a Ruby exercise
  touch "$exercise_name.rb"
  touch "test.rb"
  
  cat > "$exercise_name.rb" << EOF
# $exercise_name.rb

EOF

  cat > "test.rb" << EOF
require 'minitest/autorun'
require_relative '$exercise_name'

class ${exercise_name^}Test < Minitest::Test
  def test_example
    # Write your test here
  end
end
EOF

  echo "Exercise $exercise_name setup completed!"
}

# Quick project navigation with fzf
proj() {
  local dir
  dir=$(find ~/projects ~/github -maxdepth 2 -type d -not -path "*/\.*" | fzf)
  if [ -n "$dir" ]; then
    cd "$dir" || return
  fi
}

# Create tmux session function
mks() {
  local session_name=${1:-dev}
  
  # Check if session already exists
  if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "Session $session_name already exists. Attaching..."
    tmux attach-session -t "$session_name"
    return
  fi
  
  # Create the session
  tmux new-session -d -s "$session_name"
  
  # Create a window for editing
  tmux rename-window -t "$session_name:1" "edit"
  
  # Create a window for running tests
  tmux new-window -t "$session_name:2" -n "test"
  
  # Create a window for git/github operations
  tmux new-window -t "$session_name:3" -n "git"
  
  # Attach to the session
  tmux attach-session -t "$session_name:1"
}

# Kill tmux session function
kts() {
  local session_name=${1:-dev}
  tmux kill-session -t "$session_name"
  echo "Session $session_name killed."
}

# Create Python tmux session
pyks() {
  local session_name=${1:-python}
  
  # Check if session already exists
  if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "Session $session_name already exists. Attaching..."
    tmux attach-session -t "$session_name"
    return
  fi
  
  # Create the session
  tmux new-session -d -s "$session_name"
  
  # Create a window for editing
  tmux rename-window -t "$session_name:1" "edit"
  
  # Create a window for Python shell
  tmux new-window -t "$session_name:2" -n "shell"
  
  # Create a window for running tests
  tmux new-window -t "$session_name:3" -n "test"
  
  # Create a window for git operations
  tmux new-window -t "$session_name:4" -n "git"
  
  # Try to activate virtual environment in each window
  if [ -d ".venv" ]; then
    for i in {1..4}; do
      tmux send-keys -t "$session_name:$i" "source .venv/bin/activate" C-m
    fi
  fi
  
  # Attach to the session
  tmux attach-session -t "$session_name:1"
}

# Check for network connectivity
isup() {
  local url=${1:-google.com}
  if ping -c 1 "$url" &> /dev/null; then
    echo "$url is up!"
  else
    echo "$url is down!"
  fi
}

# Quickly find and open files with fzf
vf() {
  local file
  file=$(find . -type f -not -path "*/node_modules/*" -not -path "*/.git/*" | fzf)
  if [ -n "$file" ]; then
    nvim "$file"
  fi
}

# Create scratch note
note() {
  local note_dir="$HOME/notes"
  local note_file
  
  if [ ! -d "$note_dir" ]; then
    mkdir -p "$note_dir"
  fi
  
  if [ -z "$1" ]; then
    note_file="$note_dir/note_$(date +%Y%m%d_%H%M%S).md"
  else
    note_file="$note_dir/$1.md"
  fi
  
  nvim "$note_file"
}

# ====================
# = External tools   =
# ====================

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# GitHub CLI completion
if type gh &>/dev/null; then
  eval "$(gh completion -s zsh)"
fi

# Load GitHub integration
if [ -f ~/.github-integration.zsh ]; then
  source ~/.github-integration.zsh
fi

# Add common dev directories to CDPATH
export CDPATH=.:$HOME:$HOME/projects:$HOME/github

# ====================
# = Prompt           =
# ====================

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%b'

# Set up the prompt (with git branch)
setopt PROMPT_SUBST
PROMPT='%B%F{green}%n@%m%f:%F{blue}%~%f%b$([ -n "$vcs_info_msg_0_" ] && echo " %F{yellow}($vcs_info_msg_0_)%f")$ '

# ====================
# = OS-specific conf =
# ====================

# macOS specific
if [[ "$(uname)" == "Darwin" ]]; then
  # Add macOS specific paths
  export PATH="/opt/homebrew/bin:$PATH"
  
  # macOS aliases
  alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
  alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
  alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
  
  # Use GNU versions of tools if available
  if type gls &>/dev/null; then
    alias ls="gls --color=auto"
    alias ll="gls -la --color=auto"
  fi
fi

# Linux specific
if [[ "$(uname)" == "Linux" ]]; then
  # Add Linux specific paths
  export PATH="$HOME/.local/bin:$PATH"
  
  # Linux aliases
  alias ls="ls --color=auto"
  alias open="xdg-open"
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
  
  # Create symlink for fd-find (might be called fdfind on Debian/Ubuntu)
  if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    mkdir -p ~/.local/bin
    ln -sf $(which fdfind) ~/.local/bin/fd
  fi
fi

# ====================
# = Local overrides  =
# ====================

# Load local configuration if it exists
[ -f ~/.zshrc.local ] && source ~/.zshrc.local