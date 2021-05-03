#!/bin/bash
# A collection of helper functions useful for my other setup scripts. This
# mainly includes functions which will download/install "packages" of some
# description.

# Make sure to source this file only once.
[ -n "${INCLUDE_HELPERS}" ] && return; INCLUDE_HELPERS=0;

# Download a git repository and install it into the target directory.
function install_git
{
  local dir=$1
  local src=$2
  local dst="$dir/${3:-$(basename $src | cut -f1 -d '.')}"
  [[ -e $dst && -n $(ls -A $dst) ]] && return

  echo "Installing $dst."
  mkdir -p $dir
  git clone -q $src $dst
}

# Download a link and install it into the target directory.
function install_url
{
  local dir=$1
  local src=$2
  local dst="$dir/${3:-$(basename $src)}"
  [ -e $dst ] && return

  echo "Installing $dst."
  mkdir -p $dir
  curl -LSs $src -o $dst
}

function install_link
{
  local src=$1
  local dst=$2
  [ -e $dst ] && return

  echo "Linking $dst."
  ln -s $src $dst
}
 
function confirm
{
  local prompt=$1
  local response

  while true; do
    # Give the prompt
    echo -n "$prompt [Y/N] "

    # Read the response. This uses /dev/tty in case stdin is redirected from
    # somewhere else.
    read -r response </dev/tty

    # Check if the reply is valid
    case "$response" in
      Y|y) return 0 ;;
      N|n) return 1 ;;
    esac
    echo "Response must be either 'Y/y' or 'N/n'."
  done
}
