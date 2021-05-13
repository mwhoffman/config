#!/bin/bash
# A collection of "default" plugins that I use for vim. This script will
# download and install them in the correct places under the ~/.vim directory.

# Include helpers.
. "$(dirname ${BASH_SOURCE[0]})/helpers.sh"

# The pathogen package manager.
install_url "$HOME/.vim/autoload" 'https://tpo.pe/pathogen.vim'

# Interface plugins. Improves the status line a la powerline, adds VCS markers
# in the gutter, and adds a filesystem explorer.
install_git "$HOME/.vim/bundle" 'https://github.com/vim-airline/vim-airline'
install_git "$HOME/.vim/bundle" 'https://github.com/mhinz/vim-signify'
install_git "$HOME/.vim/bundle" 'https://github.com/preservim/nerdtree'

# The gruvbox colorscheme and improved python syntax.
install_git "$HOME/.vim/bundle" 'https://github.com/morhetz/gruvbox'
install_git "$HOME/.vim/bundle" 'https://github.com/vim-python/python-syntax'

# Asynchronous linting.
install_git "$HOME/.vim/bundle" 'https://github.com/dense-analysis/ale'

# Provide a command to delete buffers.
install_git "$HOME/.vim/bundle" 'https://github.com/moll/vim-bbye'
