# .zshrc
#

[ -f "$HOME/.zshrc.local"   ] && source "$HOME/.zshrc.local"
[ -f "$HOME/.zshrc.include" ] && source "$HOME/.zshrc.include"

unset INPUTRC
unset MAILPATH

MOSH_TITLE_NOPREFIX=1
EDITOR="vim"
PAGER="less"
LESS="FRX"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY

export MOSH_TITLE_NOPREFIX

alias ls="ls -N --color=auto"

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

source "$HOME/.gruvbox"
eval $(dircolors $HOME/.dircolors)

bindkey -v
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward

precmd() {
  # Parse out any strings we need for the window title and prompt.
  _parse_branch
  _parse_pwd

  # Initialize the title and prompt with the hostname.
  TITLE="%m"
  PROMPT="%F{yellow}%B%m%b%f"

  # If we're in a named directory then add the name.
  if [[ -n ${PWD_NAME} ]]; then
    PROMPT+=":%F{green}%B${PWD_NAME}%b%f"
  fi

  # Add the current working directory after name mangling.
  PROMPT+=":%F{blue}%B${PWD_}%b%f"

  # If we're in a VCS directory then add the name/status of the current branch.
  if [[ -n ${BRANCH} ]]; then
    PROMPT+=":%F{cyan}%B${BRANCH}%b%f"
  fi

  # Add the trailing part of the prompt.
  PROMPT+="%# "

  # Print the window title.
  print -Pn "\e]0;${TITLE}\a"
}
