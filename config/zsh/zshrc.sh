# Set vi mode
bindkey -v

# Path configuration
export PATH=$HOME/bin:/usr/local/bin:$PATH

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory

# Completion
autoload -Uz compinit
compinit

# Aliases
alias vim="nvim"
alias vi="nvim"
alias ls="ls -G"
alias ll="ls -la"
alias ..="cd .."
alias ...="cd ../.."

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# GitHub CLI completion
if type gh &>/dev/null; then
  eval "$(gh completion -s zsh)"
fi

# Prompt (simple for now, can be enhanced later)
PS1="%B%F{green}%n@%m%f:%F{blue}%~%f%b$ "

# Load GitHub integration
if [ -f ~/.github-integration.zsh ]; then
  source ~/.github-integration.zsh
fi

# Add common dev directories to CDPATH
export CDPATH=.:$HOME:$HOME/projects:$HOME/github

# Create tmux session function
mks() {
  local session_name=${1:-dev}
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

# Quick project navigation with fzf
proj() {
  local dir
  dir=$(find ~/projects ~/github -maxdepth 2 -type d -not -path "*/\.*" | fzf)
  if [ -n "$dir" ]; then
    cd "$dir" || return
  fi
}

# Vim/Tmux navigation
# Smart navigation between Vim splits and Tmux panes
# requires corresponding setting in .vimrc/.tmux.conf
if [ -n "$TMUX" ]; then
  vimux_nav_script="$HOME/.config/vimux_navigation.sh"
  if [ ! -f "$vimux_nav_script" ]; then
    mkdir -p "$(dirname "$vimux_nav_script")"
    cat > "$vimux_nav_script" << 'VIMUXNAV'
#!/bin/bash
# Check if the command is running inside tmux
if [ -n "$TMUX" ]; then
  # Get the ID of the current Vim pane/window
  vim_pane=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep -i vim | cut -d ' ' -f 1)
  
  # If Vim is running, send the navigation command to Vim
  if [ -n "$vim_pane" ]; then
    tmux send-keys -t "$vim_pane" C-$1
  else
    # Otherwise, use tmux navigation
    tmux select-pane -$2
  fi
else
  # Not in tmux, do nothing
  exit 0
fi
VIMUXNAV
    chmod +x "$vimux_nav_script"
  fi
  
  # Bind keys for navigation
  bindkey -s '^h' "$vimux_nav_script h L\n"
  bindkey -s '^j' "$vimux_nav_script j D\n"
  bindkey -s '^k' "$vimux_nav_script k U\n"
  bindkey -s '^l' "$vimux_nav_script l R\n"
fi
