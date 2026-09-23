# If the given argument is executable (assuming its brew) use it to set the
# homebrew environment variables.
function homebrew_path { [ -x "$1" ] && eval "$("$1" shellenv)"; }

# Try to find the brew command and use the above command to set the environment
# variables. The first locations are for macOS (Apple silicon, then Intel) and
# the last are for Linux (the default shared install, then a per-user install).
# The rest of the setup only happens if one of these is found.
if homebrew_path "/opt/homebrew/bin/brew" ||
   homebrew_path "/usr/local/bin/brew" ||
   homebrew_path "/usr/local/brew/bin/brew" ||
   homebrew_path "/home/linuxbrew/.linuxbrew/bin/brew" ||
   homebrew_path "$HOME/.linuxbrew/bin/brew"; then

  # On macOS homebrew installs the GNU coreutils with a "g" prefix (e.g. gls)
  # and keeps unprefixed versions in gnubin; put those first in PATH unless
  # disabled with HOMEBREW_USE_COREUTILS=false (e.g. in local.zsh). On Linux
  # there is no gnubin, since the system tools are already GNU, so nothing is
  # added.
  if "${HOMEBREW_USE_COREUTILS:-true}"; then
    # the pathdir helper is defined in .zshrc and should have already been
    # defined by the time we run this. If this directory doesn't exist it won't
    # be included.
    pathdir "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
  fi
fi
