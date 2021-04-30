#!/bin/bash

# Download a link and install it into the target directory.
function _git
{
  dir=$1
  src=$2
  target="$1/`basename $src | cut -f1 -d'.'`"
  if [ ! -e $target ]; then
    echo "installing '$target'"
    mkdir -p $dir
    git clone $src $target
  fi
}

# Download a git repository and install it into the target directory.
function _get
{
  dir=$1
  src=$2
  target="$1/`basename $src`"
  if [ ! -e $target ]; then
    echo "installing '$target'"
    mkdir -p $dir
    curl -LSs $src -o $target
  fi
}

