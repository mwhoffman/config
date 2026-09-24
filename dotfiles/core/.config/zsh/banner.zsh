# Print a one-line banner if the config directory has local changes or is
# ahead of/behind its upstream, and fetch from the upstream for the next shell.
#
# Everything runs in an anonymous function so its variables are local, and
# nothing is left behind in the shell.
() {
  local config="$HOME/config"

  # Skip the banner entirely if the config dir isn't a git repo or git is
  # missing.
  [[ -d $config/.git ]] && (( $+commands[git] )) || return 0

  # Fetch in the background (and disowned, with &!) so a slow or missing network
  # doesn't hold up the shell; its results show up in the next shell. The repo
  # fetches over https (see setup), which needs no authentication, so this
  # never triggers an ssh agent prompt. GIT_TERMINAL_PROMPT=0 makes git fail
  # rather than ask for credentials if that ever changes.
  GIT_TERMINAL_PROMPT=0 git -C "$config" fetch --quiet >/dev/null 2>&1 &!

  # Every line of the status is a changed file, except the "## branch" header
  # which shows e.g. "[ahead 1, behind 2]" relative to the upstream.
  local git_status line changed ahead behind
  git_status=$(git -C "$config" status --porcelain --branch) || return 0
  for line in ${(f)git_status}; do
    if [[ $line == '## '* ]]; then
      [[ $line == *'[ahead '*']' ]] && ahead=1
      [[ $line == *'['*'behind '*']' ]] && behind=1
    else
      changed=1
    fi
  done

  # Print the banner, if there's anything to report.
  [[ -n $changed || -n $ahead || -n $behind ]] || return 0
  local banner="config directory"
  [[ -n $changed ]] && banner+=" has %F{red}local changes%f;"
  [[ -n $ahead   ]] && banner+=" is %F{green}ahead%f;"
  [[ -n $behind  ]] && banner+=" is %F{magenta}behind%f;"
  print -P -- "$banner"
}
