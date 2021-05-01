#!/bin/bash

# Get the base directories.
BASEDIR="$(dirname ${BASH_SOURCE[0]})"
DOTFILES="$BASEDIR/dotfiles"
SETUP="$BASEDIR/setup"

# Dotfile packages to include using stow.
PACKAGES=("core")

# Based on what system we're on, run any system-specific scripts and/or modify
# the set of dotfiles to include.
case $(uname -s) in

  # Run mac-specific scripts.
  Darwin)
    PACKAGES+=("mac")
  ;;

  # Run linux-specific scripts.
  Linux)
  ;;

esac

# Run common scripts.
. "$SETUP/vim.sh"

# Link dotfiles.
stow --no-folding -v -d $DOTFILES -t $HOME -S ${PACKAGES[*]}

