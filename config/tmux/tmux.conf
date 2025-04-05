# Path: ~/.tmux.conf

# Set prefix to Ctrl-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Pane navigation with Alt+hjkl
bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

# Split panes
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Reload config
bind r source-file ~/.tmux.conf \; display "Reloaded!"

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on

# Enable vi mode and mouse
setw -g mode-keys vi
set -g mouse on

# Set terminal colors
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"

# Enable focus events (for Vim/Neovim autoread)
set -g focus-events on

# Increase history limit
set -g history-limit 10000

# Faster command sequences
set -sg escape-time 0

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity off

# Window navigation
bind -n M-Left previous-window
bind -n M-Right next-window
bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2
bind -n M-3 select-window -t 3
bind -n M-4 select-window -t 4
bind -n M-5 select-window -t 5

# Session management
bind C-s choose-session
bind C-c new-session
bind C-f command-prompt -p "Find session:" "switch-client -t '%%'"

# Better copy mode
bind v copy-mode
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

# Smart pane switching with awareness of Vim splits
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?"
bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
bind-key -T copy-mode-vi C-h select-pane -L
bind-key -T copy-mode-vi C-j select-pane -D
bind-key -T copy-mode-vi C-k select-pane -U
bind-key -T copy-mode-vi C-l select-pane -R

# Set status bar
set -g status-style 'bg=#333333 fg=#5eacd3'
set -g status-position top
set -g status-interval 1
set -g status-left-length 30
set -g status-right-length 150
set -g status-left "#[fg=green]#S #[fg=yellow]#I:#P #[fg=cyan]|"
set -g status-right "#[fg=cyan]| #[fg=green]%a %H:%M #[fg=yellow]%d-%b-%Y"
set -g window-status-current-style 'fg=black bg=#5eacd3'
set -g window-status-current-format ' #I:#W '
set -g window-status-format ' #I:#W '

# Pane border styling
set -g pane-border-style 'fg=#555555'
set -g pane-active-border-style 'fg=#5eacd3'

# Install TPM (Tmux Plugin Manager) if not already installed
if "test ! -d ~/.tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"

# Plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-yank'

# Tmux resurrect configuration
set -g @resurrect-strategy-vim 'session'
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-capture-pane-contents 'on'

# Tmux continuum configuration
set -g @continuum-restore 'on'
set -g @continuum-save-interval '5'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'