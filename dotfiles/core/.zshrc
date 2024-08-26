# .zshrc

[ -f "$HOME/.zshrc.local"   ] && source "$HOME/.zshrc.local"
[ -f "$HOME/.zshrc.include" ] && source "$HOME/.zshrc.include"

unset INPUTRC
unset MAILPATH

export MOSH_TITLE_NOPREFIX=1
export LC_COLLATE="POSIX"
export EDITOR="nvim"
export PAGER="less"
export LESS="FRX"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

setopt APPEND_HISTORY

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

source "$HOME/.gruvbox"
eval $(dircolors $HOME/.dircolors)

alias ls="ls -N --color=auto"
alias vi="nvim"

bindkey -v
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward

precmd() {
  # Parse out any strings we need for the window title and prompt.
  _parse_branch
  _parse_pwd
  _make_prompt

  # Print the window title. This is simply the hostname.
  print -Pn "\e]0;%m\a"
}

