# .zshrc
#

[ -f '.zshrc.local'   ] && source '.zshrc.local'
[ -f '.zshrc.include' ] && source '.zshrc.include'

unset INPUTRC
unset MAILPATH

export MOSH_TITLE_NOPREFIX=1
export EDITOR="vim"
export PAGER="less"
export LESS="FRX"

alias ls="ls -N --color=auto"

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

source .bash/gruvbox
eval $(dircolors ~/.dircolors)

bindkey -v
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward

precmd() {
  _parse_branch
  _parse_pwd

  # Hostname part of the prompt.
  PROMPT="%F{yellow}%B%m%b%f"
  TITLE="%m"

  # If we're in a "named" directory.
  if [[ -n ${PWD_NAME} ]]; then
    PROMPT+=":%F{green}%B${PWD_NAME}%b%f"
    TITLE+=":${PWD_NAME}"
  fi

  # Add the current directory after mangling.
  PROMPT+=":%F{blue}%B${PWD_}%b%f"
  TITLE+=":${PWD_}"

  # The VCS branch name.
  if [[ -n ${BRANCH} ]]; then
    PROMPT+=":%F{cyan}%B${BRANCH}%b%f"
  fi

  # Trailing part of the prompt.
  PROMPT+="%# "

  # Print to the window title.
  print -Pn "\e]0;${TITLE}\a"
}
