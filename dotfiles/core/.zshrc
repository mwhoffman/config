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

# History options.
setopt EXTENDED_HISTORY       # Save timestamps and durations.
setopt SHARE_HISTORY          # Share history between running shells.
setopt HIST_REDUCE_BLANKS     # Compact/trim whitespace (quoted text is kept).
setopt HIST_IGNORE_ALL_DUPS   # Drop older copies of a repeated command.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicates to the history file.
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching.
setopt HIST_IGNORE_SPACE      # Don't save commands starting with a space.

# Before accepting a line combine the lbuffer and rbuffer (buffer before/after
# the cursor), strip spaces, and put this cleaned text back into LBUFFER only.
function trim-trailing-space-before-accept() {
  # The "#" (zero or more) below needs extendedglob; without it "#" is a literal
  # and nothing is trimmed. localoptions keeps this set only within the widget.
  setopt localoptions extendedglob
  local buffer="${LBUFFER}${RBUFFER}"
  buffer="${buffer%%[[:space:]]#}"
  LBUFFER="${buffer}"
  RBUFFER=""
  zle .accept-line
}
zle -N accept-line trim-trailing-space-before-accept

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

# Source the theme colors, which are also used by the prompt below.
src "$HOME/.config/zsh/theme.zsh"

# Color for descriptions (e.g. completion groups) and messages. These fall back
# to the default text color if the theme doesn't set them.
zstyle ':completion:*:*:*:*:descriptions' format "%F{${THEME_COLORS[completion_description]:-default}}-- %d --%f"
zstyle ':completion:*:messages' format " %F{${THEME_COLORS[completion_message]:-default}} -- %d --%f"
zstyle ':completion:*:warnings' format " %F{${THEME_COLORS[completion_warning]:-default}}-- no matches found --%f"

# Use $LS_COLORS to color completed files and directories.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Use eza for ls if it's installed. Otherwise the ls options depend on which
# ls is in PATH: GNU ls (Linux, or homebrew's coreutils on macOS) or BSD ls
# (macOS).
if (( $+commands[eza] )); then
  # eza's config dir defaults to ~/Library/Application Support/eza on macOS, so
  # point it at ~/.config/eza as on Linux.
  export EZA_CONFIG_DIR="$HOME/.config/eza"
  alias ls="eza --icons=auto --sort=type"
elif ls --version >/dev/null 2>&1; then
  alias ls="ls -N --color=auto"
else
  alias ls="ls -G"
fi

# Set the ZK notebook dir if ~/notes exists.
if [[ -d "${HOME}/notes/.zk" ]]; then
  export ZK_NOTEBOOK_DIR="${HOME}/notes"
  if (( $+commands[zk] )); then
    alias zkn="zk new"
    alias zke="zk edit --interactive"
  fi
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

  # Bind the cd widget to ctrl-o as well as the default alt-c.
  bindkey '^O' fzf-cd-widget

  # Use fd for listing where available, so that .gitignore is respected.
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    _fzf_compgen_path() { fd --hidden --follow --exclude .git . "$1" }
    _fzf_compgen_dir() { fd --type d --hidden --follow --exclude .git . "$1" }
  fi
fi

# Source any additional configuration.
src "$HOME/.config/zsh/prompt.zsh"
src "$HOME/.config/zsh/overrides.zsh"
