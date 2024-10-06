# .zshrc

# Define a dirty function to source a given file only if it exists.
function src { [ -f $1 ] && source $1; }

# Include any local information (e.g. local paths).
src "$HOME/.config/zsh/includes.zsh"

# We could set environment variables in .zshenv, but different OSes (e.g. mac)
# treat this differently, so putting them in .zshrc is the "safest" thing to do.

export PATH="$HOME/bin:$PATH"  # Extend our path to include a home bin dir.
export MOSH_TITLE_NOPREFIX=1   # Don't let mosh mess with window titles.
export LC_COLLATE="POSIX"      # Use alphabetic ordering of files.
export VISUAL="nvim"           # The visual editor to use.
export EDITOR="nvim"           # "Plain" editor to use (mostly ignored).
export PAGER="less"            # Replace more with less as the pager.
export LESS="FRX"              # Default options for less.

# Where and how much history to save.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

# The following lines deal with history, first we store extended history
# information, share history between sessions, and then (a) don't save duplicate
# history lines, and ignore any duplicates if they exist.
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Define the $LS_COLORS variable used to color the output of ls, but we'll also
# use it for completions.
eval $(dircolors $HOME/.dircolors)

# Initialize zsh completion.
autoload -U compinit; compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _extensions _complete

# Ignore case if necessary and look for within-string matches.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Color for descriptions (e.g. completion groups) and messages.
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Use $LS_COLORS to color completed files and directories.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Aliases.
alias ls="ls -N --color=auto"
alias vi="nvim"

# Styling for the vim-mode plugin.
MODE_INDICATOR=""
MODE_CURSOR_VIINS="bar"
MODE_CURSOR_VICMD="block"
MODE_CURSOR_VISUAL="block #98971a"
MODE_CURSOR_REPLACE="underline #cc241d"

# Source any plugins.
src "$HOME/.local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
src "$HOME/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
src "$HOME/.local/share/zsh/zsh-vim-mode/zsh-vim-mode.plugin.zsh"

# Include my prompt configuration.
src "$HOME/.config/zsh/prompt.zsh"
src "$HOME/.config/zsh/fzf.zsh"
src "$HOME/.config/zsh/overrides.zsh"

