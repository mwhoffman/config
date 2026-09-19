# .profile
#
# Read by login shells that follow the sh convention and, importantly, by the
# display manager when starting a graphical session (e.g. i3). Anything set here
# is inherited by everything launched from that session, including terminals and
# the zsh running inside them. Keep it POSIX sh compatible.

# Prepend a directory to PATH, but only if it exists and isn't already there.
pathdir() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

pathdir "$HOME/bin"
pathdir "$HOME/.local/bin"
export PATH
