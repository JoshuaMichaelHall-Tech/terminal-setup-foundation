# GitHub CLI integration and enhancements for zsh
# Enhanced version for the mouseless development environment

# ====================
# = GitHub CLI Aliases =
# ====================

# Pull request operations
alias ghpr="gh pr create"
alias ghprs="gh pr status"
alias ghprv="gh pr view"
alias ghprl="gh pr list"
alias ghprc="gh pr checkout"
alias ghprm="gh pr merge"
alias ghprd="gh pr diff"
alias ghprco="gh pr comment"

# Issue operations
alias ghis="gh issue"
alias ghisc="gh issue create"
alias ghisl="gh issue list"
alias ghisv="gh issue view"
alias ghisa="gh issue close"
alias ghiso="gh issue reopen"
alias ghise="gh issue edit"

# Repository operations
alias ghr="gh repo"
alias ghrc="gh repo create"
alias ghrf="gh repo fork"
alias ghrv="gh repo view"
alias ghrl="gh repo list"
alias ghrs="gh repo sync"

# Workflow operations
alias ghw="gh workflow"
alias ghwl="gh workflow list"
alias ghwv="gh workflow view"
alias ghwr="gh workflow run"
alias ghws="gh workflow status"

# Gist operations
alias ghg="gh gist"
alias ghgc="gh gist create"
alias ghgl="gh gist list"
alias ghge="gh gist edit"
alias ghgd="gh gist delete"

# ====================
# = Custom Functions =
# ====================

# Clone a GitHub repository and cd into it
gh_clone() {
  if [ -z "$1" ]; then
    echo "Usage: gh_clone <username/repo>"
    return 1
  fi

  # Clone the repository
  gh repo clone "$1" && cd "$(basename "$1")"
  
  # Check if successful
  if [ $? -eq 0 ]; then
    echo "Repository cloned successfully. Now in $(pwd)"
    
    # Install dependencies if package files exist
    if [ -f "package.json" ]; then
      echo "Found package.json. Do you want to run 'npm install'? (y/n)"
      read -r answer
      if [[ "$answer" =~ ^[Yy]$ ]]; then
        npm install
      fi
    elif [ -f "requirements.txt" ]; then
      echo "Found requirements.txt. Do you want to create a virtual environment and install dependencies? (y/n)"
      read -r answer
      if [[ "$answer" =~ ^[Yy]$ ]]; then
        python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
      fi
    elif [ -f "Gemfile" ]; then
      echo "Found Gemfile. Do you want to run 'bundle install'? (y/n)"
      read -r answer
      if [[ "$answer" =~ ^[Yy]$ ]]; then
        bundle install
      fi
    fi
    
    # Start tmux session for the project
    echo "Do you want to start a tmux session for this project? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      mks "$(basename "$1")"
    fi
  else
    echo "Failed to clone repository."
  fi
}

# Create a new GitHub repository
gh_create() {
  if [ -z "$1" ]; then
    echo "Usage: gh_create <repo-name> [description]"
    return 1
  fi

  local repo_name="$1"
  local description="${2:-A new repository}"
  
  # Create the repository on GitHub
  gh repo create "$repo_name" --public --description "$description" --confirm
  
  # Create local directory and initialize git
  mkdir -p "$repo_name"
  cd "$repo_name"
  git init
  
  # Create README.md
  echo "# $repo_name" > README.md
  echo "$description" >> README.md
  echo -e "\n## Acknowledgements

This project was developed with assistance from Anthropic's Claude AI assistant, which helped with:
- Documentation writing and organization
- Code structure suggestions
- Troubleshooting and debugging assistance

Claude was used as a development aid while all final implementation decisions and code review were performed by the human developer.

## Disclaimer

This software is provided \"as is\", without warranty of any kind, express or implied. The authors or copyright holders shall not be liable for any claim, damages or other liability arising from the use of the software.

This project is a work in progress and may contain bugs or incomplete features. Users are encouraged to report any issues they encounter." >> README.md

  # Create .gitignore
  curl -s https://www.toptal.com/developers/gitignore/api/macos,linux,windows,visualstudiocode,intellij+all,vim,python,node,ruby > .gitignore
  
  # Initial commit and push
  git add README.md .gitignore
  git commit -m "Initial commit"
  git branch -M main
  git remote add origin "https://github.com/$(gh api user | jq -r '.login')/$repo_name.git"
  git push -u origin main
  
  echo "Repository $repo_name created and initialized successfully!"
  
  # Start tmux session for the project
  echo "Do you want to start a tmux session for this project? (y/n)"
  read -r answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    mks "$repo_name"
  fi
}

# Commit and push changes in one command
gh_commit_push() {
  local message="$1"
  if [ -z "$message" ]; then
    message="Update files"
  fi
  
  echo "Committing changes with message: $message"
  git add .
  git commit -m "$message"
  
  # Check if there are any commits to push
  if git rev-list --count HEAD..@{u} > /dev/null 2>&1; then
    echo "No changes to push."
    return 0
  fi
  
  echo "Pushing changes to remote repository..."
  git push
  
  echo "Changes committed and pushed successfully!"
}

# Search through GitHub issues
gh_search_issues() {
  if [ -z "$1" ]; then
    echo "Usage: gh_search_issues <search_term>"
    return 1
  fi
  
  gh issue list --search "$1"
}

# List all GitHub repositories you have access to
gh_list_repos() {
  local count="${1:-10}"
  gh repo list --limit "$count"
}

# Open the current repository in a browser
gh_open() {
  gh repo view --web
}

# Create a pull request and assign reviewers
gh_create_pr() {
  local title="$1"
  local body="$2"
  local reviewers="$3"
  
  if [ -z "$title" ]; then
    echo "Usage: gh_create_pr <title> [body] [reviewers]"
    return 1
  fi
  
  if [ -n "$reviewers" ]; then
    gh pr create --title "$title" --body "${body:-Pull request for $title}" --reviewer "$reviewers"
  else
    gh pr create --title "$title" --body "${body:-Pull request for $title}"
  fi
}

# Initialize a new project with GitHub repository
gh_init_project() {
  if [ -z "$1" ]; then
    echo "Usage: gh_init_project <project_name> [python|js|web|data]"
    return 1
  fi
  
  local project_name="$1"
  local project_type="${2:-python}"
  
  # Create local project structure
  mkproject "$project_name" "$project_type"
  
  # Create GitHub repository
  cd "$project_name"
  gh repo create "$project_name" --public --source=. --push
  
  echo "Project $project_name initialized locally and on GitHub!"
  
  # Start tmux session
  echo "Starting tmux session for $project_name..."
  mks "$project_name"
}

# Clone your forked repository and set up upstream
gh_fork_clone() {
  if [ -z "$1" ]; then
    echo "Usage: gh_fork_clone <username/repo>"
    return 1
  fi
  
  # Fork the repository
  gh repo fork "$1" --clone=true
  
  # Get the repository name and change to the directory
  local repo_name="$(echo "$1" | cut -d '/' -f 2)"
  cd "$repo_name" || return
  
  # Set up upstream remote
  git remote add upstream "https://github.com/$1.git"
  
  echo "Repository forked, cloned, and upstream remote set up!"
  git remote -v
}

# Sync your fork with upstream
gh_sync_fork() {
  # Check if upstream remote exists
  if ! git remote | grep -q "upstream"; then
    echo "No upstream remote found. Please set up upstream first."
    return 1
  fi
  
  # Fetch and merge upstream changes
  git fetch upstream
  git checkout main
  git merge upstream/main
  git push origin main
  
  echo "Fork synchronized with upstream successfully!"
}

# Launch School specific GitHub functions
ls_submit_assignment() {
  if [ -z "$1" ]; then
    echo "Usage: ls_submit_assignment <assignment_name> [message]"
    return 1
  fi
  
  local assignment="$1"
  local message="${2:-Complete $assignment assignment}"
  
  # Commit changes
  git add .
  git commit -m "$message"
  git push
  
  echo "Assignment $assignment submitted successfully!"
}