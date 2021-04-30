#!/bin/bash
#
# A collection of "default" plugins that I use for vim. This script will
# download and install them in the correct places under the ~/.vim directory.

# Source some helper functions.
. "$(dirname ${BASH_SOURCE[0]})/helpers.sh"

# The pathogen package manager.
_get "$HOME/.vim/autoload" 'https://tpo.pe/pathogen.vim'

# Show diffs in a gutter on the left.
_git "$HOME/.vim/bundle" 'https://github.com/mhinz/vim-signify.git'

# A filesystem explorer.
_git "$HOME/.vim/bundle" 'https://github.com/scrooloose/nerdtree.git'

# Pretty status/tablines.
_git "$HOME/.vim/bundle" 'https://github.com/vim-airline/vim-airline'
_git "$HOME/.vim/bundle" 'https://github.com/vim-airline/vim-airline-themes'

# Close and remove buffers.
_git "$HOME/.vim/bundle" 'https://github.com/moll/vim-bbye.git'

