set hlsearch                " highlight search terms
set autoindent              " autoindent text
set expandtab               " expand tabs to spaces
set tabstop=2               " the width of a hard tab
set nobackup                " don't create a backup file
set number                  " show numbers on the left-margin
set signcolumn=yes          " always show the sign column
set copyindent              " copy indention when moving down a line
set pastetoggle=<C-O>       " key to move into paste mode
set textwidth=80            " width at which to wrap
set colorcolumn=+0          " create a colored column at the char limit
set scrolloff=5             " number of lines above/below to display
set backspace=2             " make backspace work like it should
set viminfo='20,\"100       " set limits on what is stored in .viminfo
set history=50              " how much history to save
set wildmode=longest:list   " how to treat wilds in completions
set modelines=1             " how many lines to look for modelines
set showmatch               " briefly jump to matching braces/etc
set formatoptions=croql     " standard formatting options
set laststatus=2            " make the status bar always show up
set wrap                    " display-wrap text
set linebreak               " wrap at word boundaries
set noshowmode              " don't show the mode since airline does this
set hidden                  " hide unsaved buffers rather than closing
set nojoinspaces            " don't use two-spaces following punctuation
set mouse=a                 " allow mouse selection
set ttymouse=xterm2         " mouse selections update while dragging
set completeopt-=preview    " don't let completions open up a preview window
set nofoldenable            " disable code folding. re-enable with zi.
set fillchars=vert:│        " Mark vertical splits with an unbroken line.

set viminfo+=n~/.local/share/vim/viminfo

" Make sure that all other indent parameters follow tabstop. Do this after
" sourcing the include above so that it can override the tabstop value.
let &softtabstop=&g:tabstop
let &shiftwidth=&g:tabstop

" Load plugin and indent files based on the current filetype. Also turn on
" syntax highlighting.
filetype plugin indent on
syntax on

" newer versions of the vim ftplugin for python (as of vim 7.4) automatically
" set the tab parameters to follow PEP8. So if for whatever reason we don't
" want to do that we must manually override this.
autocmd Filetype python let &l:sw=&g:sw
autocmd Filetype python let &l:ts=&g:ts
autocmd Filetype python let &l:sts=&g:sts

" Turn on more modern highlighting for python. Requires the python-syntax
" plugin.
let g:python_highlight_all=1

" Set the 'leader' key which can be used as <leader> in key mappings.
let mapleader=' '

" Use c-k and c-j to quickly move up/down.
nmap <c-k> <c-u>
nmap <c-j> <c-d>
nmap <c-l> :nohl<cr>
