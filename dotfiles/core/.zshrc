# .zshrc

# Keep the entries in the `path` array (which zsh ties to $PATH) unique so that
# repeatedly prepending a directory, or inheriting it from .profile, never
# creates duplicates. Re-adding an existing entry just moves it to the front.
typeset -U path

# Quick and dirty functions to source a given file or add a directory to PATH,
# but only if they already exist.
function src { [ -f $1 ] && source $1; }
function pathdir { [ -d $1 ] && path=($1 $path); }

# Include any local information (e.g. local paths).
src "$HOME/.config/zsh/local.zsh"
src "$HOME/.config/zsh/homebrew.zsh"

# Extend our path to include a home bin dir.
pathdir "$HOME/bin"
pathdir "$HOME/.local/bin"

# We could set environment variables in .zshenv, but different OSes (e.g. mac)
# treat this differently, so putting them in .zshrc is the "safest" thing to do.

export LC_COLLATE="POSIX"      # Use alphabetic ordering of files.
export PAGER="less"            # Replace more with less as the pager.
export LESS="FRX -x2"          # Default options for less.
export LESSHISTFILE="-"        # Don't save less history.

# Use the first editor of [nvim, vim, vi] that exists.
for editor in nvim vim vi; do
  if (( $+commands[$editor] )); then
    export VISUAL=$editor EDITOR=$editor
    break
  fi
done
unset editor

# The history file, completion dump, and completion cache below all live here,
# and zsh won't create the directory itself.
[[ -d "$HOME/.local/share/zsh" ]] || mkdir -p "$HOME/.local/share/zsh"

# Where and how much history to save.
HISTFILE="$HOME/.local/share/zsh/history"
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
setopt HIST_IGNORE_SPACE

# Define the $LS_COLORS variable used to color the output of ls, but we'll also
# use it for completions. dircolors is a GNU tool, so on macOS it only exists if
# homebrew's coreutils are in PATH.
if [ -f "$HOME/.dircolors" ] && (( $+commands[dircolors] )); then
  eval $(dircolors $HOME/.dircolors)
fi

# Initialize zsh completion. The security check compinit performs on every
# function file in $fpath is one of the slowest parts of shell startup, so
# only do a full check once a day (via the zcompdump's mtime) and skip it
# (-C) the rest of the time.
autoload -U compinit
() {
  # The glob qualifier (#qN.mh+24) only matches a file last modified more than
  # 24 hours ago, and needs extendedglob; localoptions keeps that option set
  # only within this function.
  setopt localoptions extendedglob
  local dump="$HOME/.local/share/zsh/zcompdump"
  if [[ -n $dump(#qN.mh+24) ]]; then
    compinit -d "$dump"
  else
    compinit -C -d "$dump"
  fi
}

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.local/share/zsh/cache"
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

# The ls options depend on which ls is in PATH: GNU ls (Linux, or
# homebrew's coreutils on macOS) or BSD ls (macOS).
if ls --version >/dev/null 2>&1; then
  alias ls="ls -N --color=auto"
else
  alias ls="ls -G"
fi

# Point vi at the editor chosen above (nvim, or vim if nvim is missing).
[[ -n $EDITOR && $EDITOR != vi ]] && alias vi="$EDITOR"

# Initialize ZVM when the plugin is sourced rather than trying to be lazy.
ZVM_INIT_MODE="sourcing"
ZVM_LINE_INIT_MODE="i"

# Source any plugins.
src "$HOME/.local/share/zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
src "$HOME/.local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
src "$HOME/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Source fzf bindings, but only if fzf is actually installed. The fzf
# bindings can be sourced directly from the fzf command for versions >=0.48.
# So check whether it supports this (rather than parsing the version) and use
# it if possible. The output is saved so fzf only runs once: the assignment
# takes the exit status of `fzf --zsh`, which fails on older versions.
if (( $+commands[fzf] )); then
  if fzf_zsh=$(fzf --zsh 2>/dev/null); then
    eval "$fzf_zsh"
  else
    # Below is the default location location for those bindings on
    # ubuntu/mint/etc.
    src "/usr/share/doc/fzf/examples/completion.zsh"
    src "/usr/share/doc/fzf/examples/key-bindings.zsh"
  fi
  unset fzf_zsh
fi

# Source any additional configuration.
src "$HOME/.config/zsh/prompt.zsh"
src "$HOME/.config/zsh/overrides.zsh"

# Display banner information.
src "$HOME/.config/zsh/banner.zsh"
