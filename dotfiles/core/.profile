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

# Set up homebrew's environment (PATH, etc.) if it's installed. The first
# locations are for macOS (Apple silicon, then Intel) and the last are for Linux
# (the default shared install, then a per-user install). This mirrors
# .config/zsh/homebrew.zsh, but here it reaches the whole graphical session.
for brew in \
    "/opt/homebrew/bin/brew" \
    "/usr/local/bin/brew" \
    "/usr/local/brew/bin/brew" \
    "/home/linuxbrew/.linuxbrew/bin/brew" \
    "$HOME/.linuxbrew/bin/brew"; do
  if [ -x "$brew" ]; then
    eval "$("$brew" shellenv)"
    break
  fi
done
unset brew

pathdir "$HOME/bin"
pathdir "$HOME/.local/bin"
export PATH

# Use the first editor of nvim, vim, vi that exists (after setting PATH, since
# it may be installed by homebrew).
for editor in nvim vim vi; do
  if command -v "$editor" >/dev/null; then
    export VISUAL="$editor" EDITOR="$editor"
    break
  fi
done
unset editor
