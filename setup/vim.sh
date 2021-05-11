#!/bin/bash
# A collection of "default" plugins that I use for vim. This script will
# download and install them in the correct places under the ~/.vim directory.

# Include helpers.
. "$(dirname ${BASH_SOURCE[0]})/helpers.sh"

# The pathogen package manager.
install_url "$HOME/.vim/autoload" 'https://tpo.pe/pathogen.vim'

# Show diffs in a gutter on the left.
install_git "$HOME/.vim/bundle" 'https://github.com/mhinz/vim-signify'

# A filesystem explorer.
install_git "$HOME/.vim/bundle" 'https://github.com/scrooloose/nerdtree'

# Pretty status/tablines.
install_git "$HOME/.vim/bundle" 'https://github.com/vim-airline/vim-airline'

# The gruvbox theme for syntax/airline.
install_git "$HOME/.vim/bundle" 'https://github.com/morhetz/gruvbox'

# Close and remove buffers.
install_git "$HOME/.vim/bundle" 'https://github.com/moll/vim-bbye'

