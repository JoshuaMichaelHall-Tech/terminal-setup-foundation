# GitHub CLI aliases
alias ghpr="gh pr create"
alias ghprs="gh pr status"
alias ghprv="gh pr view"
alias ghprl="gh pr list"
alias ghprc="gh pr checkout"
alias ghis="gh issue"
alias ghisc="gh issue create"
alias ghisl="gh issue list"
alias ghisv="gh issue view"

# GitHub workflow functions
gh_clone() {
  if [ -z "$1" ]; then
    echo "Usage: gh_clone <username/repo>"
    return 1
  fi

  gh repo clone "$1" && cd "$(basename "$1")"
}

gh_create() {
  if [ -z "$1" ]; then
    echo "Usage: gh_create <repo-name> [description]"
    return 1
  fi

  gh repo create "$1" --public --description "${2:-A new repository}" --confirm
  mkdir -p "$1"
  cd "$1"
  git init
  echo "# $1" > README.md
  echo "${2:-A new repository}" >> README.md
  echo '## Acknowledgements

This project was developed with assistance from Anthropic'\''s Claude AI assistant, which helped with:
- Documentation writing and organization
- Code structure suggestions
- Troubleshooting and debugging assistance

Claude was used as a development aid while all final implementation decisions and code review were performed by the human developer.' >> README.md
  git add README.md
  git commit -m "Initial commit"
  git branch -M main
  git remote add origin "https://github.com/$(gh api user | jq -r '.login')/$1.git"
  git push -u origin main
}

gh_commit_push() {
  local MESSAGE="$1"
  if [ -z "$MESSAGE" ]; then
    MESSAGE="Update files"
  fi
  
  git add .
  git commit -m "$MESSAGE"
  git push
}
