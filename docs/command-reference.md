# Mouseless Development Environment - Command Reference

*Print this page for a handy reference to all the essential commands in your mouseless development environment.*

## Neovim Commands

### Navigation
| Command           | Action                               |
|-------------------|------------------------------------- |
| `h/j/k/l`         | Move cursor left/down/up/right      |
| `w/b`             | Move forward/backward by word       |
| `0/$`             | Move to start/end of line           |
| `gg/G`            | Move to top/bottom of file          |
| `{/}`             | Move to previous/next paragraph     |
| `Ctrl-d/Ctrl-u`   | Scroll half page down/up            |
| `Ctrl-f/Ctrl-b`   | Scroll full page down/up            |
| `zz`              | Center cursor on screen             |
| `H/M/L`           | Move to top/middle/bottom of screen |
| `%`               | Jump to matching bracket            |

### Editing
| Command           | Action                               |
|-------------------|------------------------------------- |
| `i/a`             | Insert before/after cursor          |
| `I/A`             | Insert at beginning/end of line     |
| `o/O`             | Insert new line below/above         |
| `r`               | Replace single character            |
| `x`               | Delete character under cursor       |
| `dd`              | Delete line                         |
| `yy`              | Yank (copy) line                    |
| `p/P`             | Paste after/before cursor           |
| `u/Ctrl-r`        | Undo/Redo                           |
| `>>/<<`           | Indent/Outdent line                 |
| `.`               | Repeat last command                 |

### Visual Mode
| Command           | Action                               |
|-------------------|------------------------------------- |
| `v`               | Enter visual mode (character)       |
| `V`               | Enter visual line mode              |
| `Ctrl-v`          | Enter visual block mode             |
| `>`               | Indent selection                    |
| `<`               | Outdent selection                   |
| `y`               | Yank (copy) selection               |
| `d`               | Delete selection                    |

### Search and Replace
| Command           | Action                               |
|-------------------|------------------------------------- |
| `/pattern`        | Search forward for pattern          |
| `?pattern`        | Search backward for pattern         |
| `n/N`             | Go to next/previous match           |
| `*/#`             | Search for word under cursor        |
| `:%s/old/new/g`   | Replace all occurrences             |
| `:%s/old/new/gc`  | Replace all (with confirmation)     |

### Files and Buffers
| Command           | Action                               |
|-------------------|------------------------------------- |
| `:w`              | Save file                           |
| `:q`              | Quit                                |
| `:wq` or `:x`     | Save and quit                       |
| `:e file`         | Edit file                           |
| `:bn/:bp`         | Next/previous buffer                |
| `:bd`             | Delete buffer                       |

### Windows and Tabs
| Command           | Action                               |
|-------------------|------------------------------------- |
| `<leader>sv`      | Split window vertically             |
| `<leader>sh`      | Split window horizontally           |
| `<leader>se`      | Make splits equal size              |
| `<leader>sx`      | Close current split                 |
| `Ctrl-h/j/k/l`    | Navigate between splits             |
| `<leader>to`      | Open new tab                        |
| `<leader>tx`      | Close current tab                   |
| `<leader>tn/tp`   | Next/previous tab                   |

### Custom Keybindings
| Command           | Action                               |
|-------------------|------------------------------------- |
| `<leader>ff`      | Find files (Telescope)              |
| `<leader>fg`      | Find text (Telescope)               |
| `<leader>fb`      | Find buffers (Telescope)            |
| `<leader>e`       | Toggle file explorer                |
| `<leader>t`       | Toggle terminal                     |
| `<leader>cf`      | Format code                         |
| `<leader>y`       | Copy to system clipboard            |
| `<leader>d`       | Delete without yanking              |

### LSP Features
| Command           | Action                               |
|-------------------|------------------------------------- |
| `gd`              | Go to definition                    |
| `gi`              | Go to implementation                |
| `gr`              | Go to references                    |
| `K`               | Show hover information              |
| `<leader>cr`      | Rename symbol                       |
| `<leader>ca`      | Code actions                        |
| `[d/]d`           | Previous/next diagnostic            |
| `<leader>cd`      | Show diagnostic details             |

### Tmux Integration
| Command           | Action                               |
|-------------------|------------------------------------- |
| `<leader>tr`      | Run current line in tmux            |
| `<leader>tt`      | Run current test file               |
| `<leader>tn`      | Run nearest test                    |

## Tmux Commands

### Session Management
| Command           | Action                               |
|-------------------|------------------------------------- |
| `tmux new -s name`| Create new session                  |
| `tmux ls`         | List sessions                       |
| `tmux attach -t name` | Attach to session               |
| `Ctrl-a d`        | Detach from session                 |
| `Ctrl-a $`        | Rename session                      |
| `Ctrl-a s`        | List and select sessions            |
| `mks project_name`| Create new dev session (custom)     |

### Window Management
| Command           | Action                               |
|-------------------|------------------------------------- |
| `Ctrl-a c`        | Create new window                   |
| `Ctrl-a ,`        | Rename window                       |
| `Ctrl-a n/p`      | Next/previous window                |
| `Ctrl-a 0-9`      | Select window by number             |
| `Alt-1/2/3/4/5`   | Select window 1-5                   |
| `Ctrl-a w`        | List and select windows             |
| `Ctrl-a &`        | Kill window                         |

### Pane Management
| Command           | Action                               |
|-------------------|------------------------------------- |
| `Ctrl-a \|`       | Split pane vertically               |
| `Ctrl-a -`        | Split pane horizontally             |
| `Alt-h/j/k/l`     | Navigate between panes              |
| `Ctrl-a z`        | Toggle pane zoom                    |
| `Ctrl-a x`        | Kill pane                           |
| `Ctrl-a q`        | Show pane numbers                   |
| `Ctrl-a q 0-9`    | Select pane by number               |
| `Ctrl-a {/}`      | Swap pane with previous/next        |

### Copy Mode
| Command           | Action                               |
|-------------------|------------------------------------- |
| `Ctrl-a [`        | Enter copy mode                     |
| `q`               | Exit copy mode                      |
| `v`               | Start selection                     |
| `y`               | Copy selection                      |
| `Ctrl-a ]`        | Paste from buffer                   |

### Other
| Command           | Action                               |
|-------------------|------------------------------------- |
| `Ctrl-a r`        | Reload tmux config                  |
| `Ctrl-a t`        | Show time                           |
| `Ctrl-a ?`        | Show key bindings                   |
| `Ctrl-a I`        | Install plugins                     |

## Zsh Commands and Aliases

### Navigation
| Command           | Action                               |
|-------------------|------------------------------------- |
| `cd dir`          | Change directory                    |
| `..`              | Go up one directory                 |
| `...`             | Go up two directories               |
| `ls`              | List files                          |
| `ll`              | List files with details             |
| `proj`            | Navigate to project (with fzf)      |

### Git and GitHub
| Command           | Action                               |
|-------------------|------------------------------------- |
| `gh_clone repo`   | Clone repository and cd into it     |
| `gh_create name desc` | Create new repository           |
| `gh_commit_push msg` | Add, commit, and push            |
| `ghpr`            | Create PR (gh pr create)            |
| `ghprs`           | PR status (gh pr status)            |
| `ghprl`           | List PRs (gh pr list)               |
| `ghis`            | GitHub issues (gh issue)            |

### Development
| Command           | Action                               |
|-------------------|------------------------------------- |
| `vim` or `vi`     | Open Neovim                         |
| `mks name`        | Create development tmux session     |
