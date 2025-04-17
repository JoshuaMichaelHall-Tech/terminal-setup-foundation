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


# ==============================================
# = Launch School aliases and functions       =
# ==============================================

# Ruby aliases
alias rubo="rubocop"
alias rubofix="rubocop -a"
alias rt="ruby test.rb"
alias rru="ruby -w"
alias rir="ruby -c"

# Launch School specific aliases
alias lsrun="ruby -w"
alias lstest="ruby -w test.rb"
alias lslint="rubocop"
alias lscheck="ruby -c"
alias lsirb="irb"
alias lspry="pry"

# Open editor with Launch School exercises
alias lse="nvim *.rb test.rb"

# Function to create a new Launch School exercise
lsexercise() {
  if [ -z "$1" ]; then
    echo "Usage: lsexercise <exercise_name>"
    return 1
  fi

  local exercise_name=$1
  
  # Create directory if it doesn't exist
  mkdir -p "$exercise_name"
  cd "$exercise_name" || return
  
  # Create exercise file if it doesn't exist
  if [ ! -f "$exercise_name.rb" ]; then
    cat > "$exercise_name.rb" << EOF
# $exercise_name.rb

# PEDAC Process
# ===========

# Problem:
#

# Examples:
#

# Data Structure:
#

# Algorithm:
#

# Code:

EOF
  fi
  
  # Create test file if it doesn't exist
  if [ ! -f "test.rb" ]; then
    # Convert snake_case to CamelCase for class name
    local class_name=$(echo "$exercise_name" | sed -r 's/(^|_)([a-z])/\U\2/g')
    
    cat > "test.rb" << EOF
require 'minitest/autorun'
require_relative '$exercise_name'

class ${class_name}Test < Minitest::Test
  def test_example
    assert_equal(true, true)
  end
end
EOF
  fi
  
  # Open files in editor
  nvim "$exercise_name.rb" test.rb
}

# Create a Launch School tmux session
lstmux() {
  local session_name=${1:-launch_school}
  
  # Check if session exists
  if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux attach-session -t "$session_name"
    return
  fi
  
  # Create new session
  tmux new-session -d -s "$session_name"
  
  # Rename first window
  tmux rename-window -t "$session_name:1" "code"
  
  # Create additional windows
  tmux new-window -t "$session_name:2" -n "test"
  tmux new-window -t "$session_name:3" -n "notes"
  tmux new-window -t "$session_name:4" -n "repl"
  
  # Start IRB in the REPL window
  tmux send-keys -t "$session_name:4" "irb" C-m
  
  # Select the first window
  tmux select-window -t "$session_name:1"
  
  # Attach to the session
  tmux attach-session -t "$session_name"
}

# Launch School OOP exercise setup
lsoop() {
  if [ -z "$1" ]; then
    echo "Usage: lsoop <class_name>"
    return 1
  fi
  
  local class_name=$1
  local file_name=$(echo "$class_name" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]')
  
  # Create directory if it doesn't exist
  mkdir -p "$file_name"
  cd "$file_name" || return
  
  # Create class file
  if [ ! -f "$file_name.rb" ]; then
    cat > "$file_name.rb" << EOF
# $file_name.rb

class $class_name
  def initialize
    # Initialize object state
  end
  
  def to_s
    # Return string representation
  end
end

if __FILE__ == \$PROGRAM_NAME
  # Test code here
end
EOF
  fi
  
  # Create test file
  if [ ! -f "test.rb" ]; then
    cat > "test.rb" << EOF
require 'minitest/autorun'
require_relative '$file_name'

class ${class_name}Test < Minitest::Test
  def setup
    @object = $class_name.new
  end
  
  def test_initialization
    assert_instance_of $class_name, @object
  end
end
EOF
  fi
  
  # Open files in editor
  nvim "$file_name.rb" test.rb
}

# Function to create RB109 assessment prep files
rb109prep() {
  local dir_name="rb109_assessment_prep"
  
  # Create directory if it doesn't exist
  mkdir -p "$dir_name"
  cd "$dir_name" || return
  
  # Create directories
  mkdir -p "practice_problems"
  mkdir -p "written_assessment"
  mkdir -p "code_snippets"
  
  # Create PEDAC template
  if [ ! -f "pedac_template.md" ]; then
    cat > "pedac_template.md" << EOF
# PEDAC Process

## P: Understanding the Problem

- Establish the rules/requirements
- Define the boundaries of the problem
- Identify implicit/explicit requirements
- Ask clarifying questions if needed
- Examine all examples given

## E: Examples and Test Cases

- Create examples that validate understanding of the problem
- Create edge cases to check boundaries and edge scenarios
- Create examples that handle failures or negative cases

## D: Data Structures

- Determine what data structures to use
- How data will be organized and manipulated

## A: Algorithm

- Write out a step-by-step approach in plain English
- Break down complex problems into smaller, manageable steps
- Avoid solving the problem yet; focus on the approach

## C: Code

- Implement the algorithm
- Test the solution against examples
- Refactor for readability and efficiency
EOF
  fi
  
  # Create a sample practice problem
  if [ ! -f "practice_problems/problem1.rb" ]; then
    cat > "practice_problems/problem1.rb" << EOF
# Problem 1
# Description: Write a method that...

# PEDAC Process
# ==============

# Problem:
#  - Input:
#  - Output:
#  - Rules:

# Examples:
#

# Data Structure:
#

# Algorithm:
#

# Code:
def solution(input)
  # Your solution here
end

# Test cases
p solution(1) == 1
p solution(2) == 2
EOF
  fi
  
  # Create written assessment prep file
  if [ ! -f "written_assessment/key_concepts.md" ]; then
    cat > "written_assessment/key_concepts.md" << EOF
# RB109 Written Assessment Key Concepts

## Variables as Pointers
- Ruby variables are pointers to objects in memory
- Assignment creates a reference to an object
- Multiple variables can reference the same object

## Object Mutability
- Some objects are mutable (Array, Hash)
- Some objects are immutable (Numbers, Symbols, true, false, nil)
- Understanding mutating vs non-mutating methods

## Method Arguments
- Pass by reference value
- Object passing strategies
- How method definitions interact with method invocations

## Collection Basics
- Arrays and Hashes
- Nested collections
- Iteration basics (each, map, select)

## Variables and Scope
- Local variables
- Method scope
- Block scope
- Constants

## Example Code Snippet Analysis:

\`\`\`ruby
a = "hello"
b = a
a << " world"
puts b  # What does this output?
\`\`\`

This outputs "hello world" because...
EOF
  fi
  
  # Create a code snippet file
  if [ ! -f "code_snippets/variables.rb" ]; then
    cat > "code_snippets/variables.rb" << EOF
# Variables as pointers
a = "hello"
b = a
a << " world"
puts b  # => "hello world"

c = "hello"
d = c
c = "hi"
puts d  # => "hello"

# Mutability
arr1 = [1, 2, 3]
arr2 = arr1
arr1 << 4
puts arr2.inspect  # => [1, 2, 3, 4]

str1 = "hi"
str2 = str1
str1 = "hello"
puts str2  # => "hi"
EOF
  fi
  
  # Open key concepts file in editor
  nvim "written_assessment/key_concepts.md"
}

# Function to create and set up a local git repository for a Launch School exercise
lsgit() {
  # Check if we're in a git repository already
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Already in a git repository."
    return 0
  fi
  
  # Initialize git repository
  git init
  
  # Create .gitignore
  cat > .gitignore << EOF
.DS_Store
._*
*.gem
*.rbc
/.config
/coverage/
/InstalledFiles
/pkg/
/spec/reports/
/spec/examples.txt
/test/tmp/
/test/version_tmp/
/tmp/
EOF
  
  # Create README.md
  local dir_name=$(basename "$PWD")
  
  cat > README.md << EOF
# $dir_name

Launch School exercise solution.

## Notes

- This is my solution to the Launch School exercise $dir_name.
- The solution uses the PEDAC process for problem solving.

## Acknowledgements

This project was developed with assistance from Anthropic's Claude AI assistant, which helped with:
- Documentation writing and organization
- Code structure suggestions
- Troubleshooting and debugging assistance

Claude was used as a development aid while all final implementation decisions and code review were performed by the human developer.

## Disclaimer

This software is provided "as is", without warranty of any kind, express or implied. The authors or copyright holders shall not be liable for any claim, damages or other liability arising from the use of the software.
EOF
  
  # Initial commit
  git add .
  git commit -m "Initial commit"
  
  echo "Git repository initialized and initial commit created."
}

# Function to commit and push a Launch School exercise
lscommit() {
  local message=${1:-"Update solution"}
  
  # Check if we're in a git repository
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Not in a git repository. Run lsgit first."
    return 1
  fi
  
  # Add all files
  git add .
  
  # Commit with the message
  git commit -m "$message"
  
  # Check if there's a remote repo and push if exists
  if git remote -v | grep -q origin; then
    git push origin main
  else
    echo "No remote repository found. Push manually when ready."
  fi
}

# Function to run all tests in the current directory
lsruntests() {
  find . -name "test*.rb" -type f -exec ruby -w {} \;
}

# Function to create a Launch School project README
lsreadme() {
  local project_name=$(basename "$PWD")
  
  cat > README.md << EOF
# $project_name

## Description

This project was created as part of the Launch School curriculum.

## Installation

\`\`\`bash
# Clone the repository
git clone [repository-url]

# Navigate to the project directory
cd $project_name
\`\`\`

## Usage

\`\`\`ruby
# Example code
ruby $project_name.rb
\`\`\`

## Testing

\`\`\`bash
ruby test.rb
\`\`\`

## Acknowledgements

This project was developed with assistance from Anthropic's Claude AI assistant, which helped with:
- Documentation writing and organization
- Code structure suggestions
- Troubleshooting and debugging assistance

Claude was used as a development aid while all final implementation decisions and code review were performed by the human developer.

## Disclaimer

This software is provided "as is", without warranty of any kind, express or implied. The authors or copyright holders shall not be liable for any claim, damages or other liability arising from the use of the software.
EOF
  
  echo "README.md created for $project_name"
}

# Function to create a new RB130 testing exercise
rb130test() {
  if [ -z "$1" ]; then
    echo "Usage: rb130test <test_name>"
    return 1
  fi
  
  local test_name=$1
  local file_name=$(echo "$test_name" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]')
  
  # Create directory if it doesn't exist
  mkdir -p "$file_name"
  cd "$file_name" || return
  
  # Create implementation file
  if [ ! -f "$file_name.rb" ]; then
    cat > "$file_name.rb" << EOF
# $file_name.rb

class $test_name
  # Implementation code
end
EOF
  fi
  
  # Create test file
  if [ ! -f "${file_name}_test.rb" ]; then
    cat > "${file_name}_test.rb" << EOF
require 'minitest/autorun'
require_relative '$file_name'

class ${test_name}Test < Minitest::Test
  def setup
    # Setup test data
  end
  
  def test_example
    assert_equal true, true
  end
end
EOF
  fi
  
  # Open files in editor
  nvim "$file_name.rb" "${file_name}_test.rb"
}

# Add a PEDAC function that can be used within Vim
pedac() {
  cat << EOF
# PEDAC Process

## P: Understanding the Problem

- Establish the rules/requirements
- Define the boundaries of the problem
- Identify implicit/explicit requirements

## E: Examples and Test Cases

- Create examples that validate understanding of the problem
- Create edge cases to check boundaries and edge scenarios

## D: Data Structures

- Determine what data structures to use
- How data will be organized and manipulated

## A: Algorithm

- Write out step-by-step approach in plain English
- Break down complex problems into smaller, manageable steps

## C: Code

# Code implementation
EOF
}

# Update TMUX_LS_SESSION for session sharing with Neovim
export TMUX_LS_SESSION=1

# ==============================================
# = Environment variables for Launch School   =
# ==============================================

# Set up Ruby environment for Launch School
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export PATH="$HOME/.rbenv/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"

# Initialize rbenv if available
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# ==============================================
# = Path adjustments for Launch School tools  =
# ==============================================

# Add local gems to path
export PATH="$HOME/.gem/ruby/3.2.0/bin:$PATH"

# Add Launch School scripts directory to path
export PATH="$HOME/.config/launch_school/bin:$PATH"

# ==============================================
# = Launch School custom key bindings for zsh =
# ==============================================

# Use vim keybindings
bindkey -v

# Custom key bindings for efficiency
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^R' history-incremental-search-backward

# LS-specific
bindkey -s '^T' 'ruby test.rb^M'
bindkey -s '^L' 'lsexercise '

# ==============================================
# = Launch School completion for zsh          =
# ==============================================

# Add custom completion for Launch School commands
_lsexercise() {
  _arguments "1:exercise name"
}

_lsoop() {
  _arguments "1:class name"
}

# Register completions
compdef _lsexercise lsexercise
compdef _lsoop lsoop