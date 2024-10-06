# fzf has zsh bindings that can be sourced directly from the command as of
# versions >0.48. So check this and use it if possible.
if [[ ${${(@s:.:)${=$(fzf --version)}[1]}[2]} -ge 48 ]]; then
  source <(fzf --zsh)
else
  # Otherwise we'll assume we're on ubuntu/mint/etc. and use the default
  # location for those bindings.
  source "/usr/share/doc/fzf/examples/completion.zsh"
  source "/usr/share/doc/fzf/examples/key-bindings.zsh"
fi
