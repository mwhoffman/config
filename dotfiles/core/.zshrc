# .zshrc

# Define a dirty function to source a given file only if it exists.
function src { [ -f $1 ] && source $1; }

# Include any local information (e.g. local prompts).
src "$HOME/.zshrc.includes"

# Include the prompt configuration.
src "$HOME/.zshrc.prompt"

export MOSH_TITLE_NOPREFIX=1   # Don't let mosh mess with window titles.
export LC_COLLATE="POSIX"      # Use alphabetic ordering of files.
export VISUAL="nvim"           # The visual editor to use.
export EDITOR="nvim"           # "Plain" editor to use (mostly ignored).
export PAGER="less"            # Replace more with less as the pager.
export LESS="FRX"              # Default options for less.

setopt EXTENDED_HISTORY        # Save extended history info.
setopt SHARE_HISTORY           # Share history between sessions.
setopt HIST_EXPIRE_DUPS_FIRST  # The rest of options basically just try and
setopt HIST_IGNORE_DUPS        # eliminate all duplicate lines from history.
setopt HIST_IGNORE_ALL_DUPS    # ...
setopt HIST_FIND_NO_DUPS       # ...
setopt HIST_SAVE_NO_DUPS       # ...

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

# Use vim-mode but keep a few emacs-ish key combinations.
bindkey -v
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward

# Aliases.
alias ls="ls -N --color=auto"
alias vi="nvim"

# Include any local overrides.
src "$HOME/.zshrc.overrides"

