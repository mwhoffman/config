#!/bin/bash

# install vim packages (including the simple pathogen manager)
mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/colors
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
git clone https://github.com/edkolev/tmuxline.vim ~/.vim/bundle/tmuxline

