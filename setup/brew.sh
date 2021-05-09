#!/bin/bash
# Install homebrew and any common packages.

# Include helpers.
. "$(dirname ${BASH_SOURCE[0]})/helpers.sh"

if [[ $(command -v brew) == '' ]]; then
  if confirm "Use default homebrew path (/usr/local)?"; then
    # Install homebrew as per the default.
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  elif confirm "Use a local homebrew path (/usr/local/brew)?"; then
    echo "Making local brew path."
    sudo mkdir -p "/usr/local/brew"
    sudo chown "$(whoami):admin" "/usr/local/brew"
    sudo -k

    install_git "/usr/local" "https://github.com/Homebrew/brew"
    PATH="/usr/local/brew/bin:$PATH"
    echo 'PATH=/usr/local/brew/bin:$PATH' >> "$HOME/.bash_local"

  else
    # Skip the rest of the homebrew setup.
    echo "Skipping homebrew setup."
    return
  fi
fi

# Get homebrew info.
BREW_PREFIX=$(brew --prefix)

# Find any common packages that are missing.
BREW_TARGETS="coreutils stow"
BREW_INSTALLED=$(brew leaves)
BREW_MISSING=$(echo $BREW_TARGETS $BREW_INSTALLED $BREW_INSTALLED |
               tr ' ' '\n' | sort | uniq -u)

# If any packages are missing install them.
if [[ $BREW_MISSING ]]; then
  echo "Installing with homebrew: $BREW_MISSING."
  brew install -q $BREW_MISSING
fi

# Symlink g-prefixed coreutils into place.
install_link "$BREW_PREFIX/bin/gls" "$BREW_PREFIX/bin/ls"
install_link "$BREW_PREFIX/bin/gdircolors" "$BREW_PREFIX/bin/dircolors"

