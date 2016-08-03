#!/bin/bash

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

function _get
{
  dir=$1
  src=$2
  target="$1/`basename $src | cut -f1 -d'.'`"
  if [ ! -e $target ]; then
    echo "installing '$target'"
    mkdir -p $dir
    curl -LSs $src -o $target
  fi
}

# install vim packages (including the simple pathogen manager)
_get "$HOME/.vim/autoload" 'https://tpo.pe/pathogen.vim'
_git "$HOME/.vim/bundle" 'https://github.com/scrooloose/nerdtree.git'
_git "$HOME/.vim/bundle" 'https://github.com/vim-airline/vim-airline'
_git "$HOME/.vim/bundle" 'https://github.com/vim-airline/vim-airline-themes'
_git "$HOME/.vim/bundle" 'https://github.com/edkolev/tmuxline.vim'

