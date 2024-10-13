# If the given argument is executable (assuming its brew) use it to set the
# homebrew environment variables.
function homebrew_path { [ -x $1 ] && eval "$($1 shellenv)"; }

# Try to find the brew command and use the above command to set the environment
# variables.
homebrew_path "/opt/homebrew/bin/brew" || \
homebrew_path "/usr/local/bin/brew"

# Inlcude paths for gnu coreutils.
PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
