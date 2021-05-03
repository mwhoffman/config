#!/bin/bash
# Run setup tools and install dotfiles; the exact set of things to install is
# based on the system we're running on.

# Get the base directories.
BASEDIR="$(dirname ${BASH_SOURCE[0]})"
DOTFILES="$BASEDIR/dotfiles"
SETUP="$BASEDIR/setup"

# Define "default" dotfile packages to install with stow.
PACKAGES=("core")

# Based on what system we're on, run any system-specific scripts and/or modify
# the set of dotfiles packages to include.
case $(uname -s) in

  # Run mac-specific scripts.
  Darwin)
    PACKAGES+=("mac")
    . "$SETUP/brew.sh"
  ;;

  # Run linux-specific scripts.
  Linux)
  ;;

esac

# Run any common setup scripts.
. "$SETUP/vim.sh"

# Link dotfiles.
stow --no-folding -v -d $DOTFILES -t $HOME -S ${PACKAGES[*]}

