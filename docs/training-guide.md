# Mouseless Development Environment - Training Guide

This guide provides a structured approach to mastering the mouseless development environment, designed to transition you from beginner to expert through deliberate practice.

## Learning Philosophy

This training guide follows key principles:
- **Mastery through deliberate practice**
- **Incremental skill acquisition**
- **Muscle memory development**
- **Spaced repetition**

## Prerequisites

Before starting this training program:
1. Complete the installation of the mouseless development environment
2. Read through the User Guide for an overview
3. Commit to at least 30 minutes of daily practice

## Training Structure

This training program is divided into four weeks, with each week building on the skills learned previously:

1. **Week 1**: Basic navigation and editing
2. **Week 2**: Advanced editing and workflow integration
3. **Week 3**: Project-specific workflows
4. **Week 4**: Custom extensions and optimization

## Week 1: The Fundamentals

### Day 1-2: Terminal Basics and Tmux Introduction

**Practice Goals:**
- Navigate directories using the terminal (cd, ls)
- Create, attach to, and detach from tmux sessions
- Navigate between tmux windows and panes
- Use the tmux prefix key (Ctrl-a) consistently

**Exercises:**
1. Create a new tmux session named "practice"
2. Create 3 windows within the session
3. Split the first window into 2 panes
4. Navigate between panes using Alt-h/j/k/l
5. Detach from the session and reattach
6. Close windows and panes

**Commands to Practice:**
```
tmux new -s practice
Ctrl-a c          # Create new window
Ctrl-a |          # Split vertically
Ctrl-a -          # Split horizontally
Alt-h/j/k/l       # Navigate panes
Ctrl-a d          # Detach
tmux attach -t practice
Ctrl-a x          # Close pane
```

### Day 3-5: Neovim Basics

**Practice Goals:**
- Move efficiently in normal mode
- Understand modes (normal, insert, visual)
- Basic editing operations (insert, delete, copy, paste)
- Save and quit files

**Exercises:**
1. Open a file in Neovim
2. Navigate through the file using h/j/k/l, w/b, gg/G
3. Make changes using i, a, o, d, y, p
4. Select text in visual mode with v, V
5. Save changes and exit

**Commands to Practice:**
```
nvim filename.txt
h, j, k, l        # Basic movement
w, b              # Move by word
gg, G             # Go to start/end of file
i, a              # Insert mode (at/after cursor)
Esc               # Return to normal mode
dd, yy            # Delete/yank line
p, P              # Paste after/before cursor
:w                # Save file
:q                # Quit
:wq               # Save and quit
```

### Day 6-7: File Navigation and Multiple Files

**Practice Goals:**
- Open and navigate between multiple files
- Use the file explorer
- Find files with telescope

**Exercises:**
1. Use NvimTree to browse and open files
2. Open multiple files and navigate between buffers
3. Use telescope to find files by name
4. Use telescope to search for text inside files

**Commands to Practice:**
```
<leader>e         # Toggle file explorer
<leader>ff        # Find files
<leader>fg        # Find text
<leader>fb        # Find buffers
<leader>bn        # Next buffer
<leader>bp        # Previous buffer
```

## Week 2: Integrated Workflow

### Day 8-9: Advanced Editing in Neovim

**Practice Goals:**
- Use text objects and motions
- Efficient editing with operators
- Multiple cursor-like operations with visual block mode

**Exercises:**
1. Use text objects (word, sentence, paragraph)
2. Combine operators with motions (delete word, change sentence)
3. Use visual block mode for multi-line editing
4. Practice dot command for repeating actions

**Commands to Practice:**
```
diw               # Delete inner word
ci(               # Change inside parentheses
Ctrl-v            # Visual block mode
.                 # Repeat last command
```

### Day 10-11: Code Navigation and LSP Features

**Practice Goals:**
- Navigate code using LSP features
- Use code completion
- Fix errors and warnings
- Format code

**Exercises:**
1. Navigate to definitions and references
2. Use code completion while typing
3. View and fix diagnostics
4. Format code with LSP

**Commands to Practice:**
```
gd                # Go to definition
gr                # Go to references
K                 # Show documentation
<leader>cr        # Rename symbol
<leader>ca        # Code actions
<leader>cf        # Format code
[d, ]d            # Navigate diagnostics
```

### Day 12-14: Combined Tmux & Neovim Workflow

**Practice Goals:**
- Use Neovim and Tmux together efficiently
- Run code from Neovim in Tmux
- Multi-pane development workflow

**Exercises:**
1. Set up a development environment with code in one pane and shell in another
2. Run current line or selection in a tmux pane
3. Run tests from within Neovim
4. Move between Neovim splits and Tmux panes seamlessly

**Commands to Practice:**
```
<leader>tr        # Run line in tmux
<leader>tt        # Run test file
<leader>tn        # Run nearest test
Ctrl-h/j/k/l      # Navigate between Neovim splits and Tmux panes
```

## Week 3: Project-Centric Development

### Day 15-16: Project Management

**Practice Goals:**
- Use the project management features
- Quick project navigation
- Session management

**Exercises:**
1. Set up multiple projects in ~/projects or ~/github
2. Use `proj` command to navigate between projects
3. Use Neovim session management with persistence.nvim
4. Create custom project-specific tmux sessions

**Commands to Practice:**
```
proj              # Navigate to a project
mks project_name  # Create a tmux session for a project
<leader>ps        # Save session
<leader>pl        # Load session
```

### Day 17-18: Git and GitHub Integration

**Practice Goals:**
- Use Git features from within Neovim
- Use GitHub CLI integration

**Exercises:**
1. Use fugitive.vim for Git operations within Neovim
2. View diffs and resolve conflicts
3. Use GitHub CLI for pull requests and issues
4. Use custom GitHub functions

**Commands to Practice:**
```
<leader>gg        # Git status
<leader>gd        # Git diff
gh_clone repo     # Clone a repository
gh_create repo    # Create a repository
gh_commit_push    # Commit and push
```

### Day 19-21: Language-Specific Workflows

**Practice Goals:**
- Customize your workflow for specific languages
- Use language-specific features

**Exercises:**
1. Set up Ruby-specific workflow
2. Set up Python-specific workflow
3. Set up JavaScript/TypeScript workflow
4. Run tests in language-appropriate ways

**Commands to Practice:**
Language-specific commands and workflows based on your most-used languages.

## Week 4: Customization and Optimization

### Day 22-23: Custom Keybindings and Aliases

**Practice Goals:**
- Customize keybindings for your workflow
- Create custom aliases
- Improve the most common operations

**Exercises:**
1. Identify pain points in your current workflow
2. Create custom keybindings in Neovim
3. Add custom aliases in Zsh
4. Document your customizations

### Day 24-25: Custom Plugins and Extensions

**Practice Goals:**
- Add new plugins to enhance your workflow
- Configure plugins for optimal usage

**Exercises:**
1. Research plugins that could improve your workflow
2. Install and configure new Neovim plugins
3. Install and configure Tmux plugins
4. Test and integrate new tools

### Day 26-28: Workflow Optimization

**Practice Goals:**
- Analyze and optimize your workflow
- Identify and eliminate inefficient patterns
- Create custom scripts for repetitive tasks

**Exercises:**
1. Record a typical work session and identify inefficiencies
2. Create custom scripts for common sequences
3. Set up abbreviations for frequently typed text
4. Refine your workspace layout

## Final Assessment

After completing the 4-week training program, test your skills with these challenges:

### Challenge 1: Speed Editing
- Time how long it takes to make a set of specific edits to a file
- Compare with your time from before training

### Challenge 2: Project Setup
- Set up a complete development environment for a new project
- Create appropriate windows, panes, and sessions
- Configure project-specific settings

### Challenge 3: Real-World Task
- Complete a real development task using only keyboard
- Note any remaining pain points to address

## Ongoing Practice

To maintain and improve your skills:

1. **Daily Deliberate Practice**: Spend 10-15 minutes daily on specific skills
2. **Weekly Review**: Review your custom configurations and update as needed
3. **Monthly Challenges**: Set monthly challenges to learn new features
4. **Community Engagement**: Share and learn tips from the Neovim/Tmux communities

## Resources for Continued Learning

### Neovim
- `:help` command within Neovim
- [Neovim Documentation](https://neovim.io/doc/)
- [Learn Vim For the Last Time](https://danielmiessler.com/p/vim/)

### Tmux
- `man tmux` in terminal
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)

### Zsh
- `man zsh` in terminal
- [Zsh Documentation](https://zsh.sourceforge.io/Doc/)

Remember: Becoming proficient with a mouseless workflow takes time and consistent practice. Be patient with yourself and focus on incremental improvements rather than perfect mastery all at once.
