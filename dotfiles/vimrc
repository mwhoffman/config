" Use Vim settings, rather then Vi settings (much better!). This must be first,
" because it changes other options as a side effect.
set nocompatible

" execute pathogen so we can find plugins
execute pathogen#infect()

" turn syntax highlighting and indent plugins
filetype indent on
filetype plugin on
syntax on

colorscheme monokai
hi Pmenu ctermbg=59
hi PmenuSel ctermfg=235 ctermbg=231

" this is the key used to prefix many commands and can be used as <leader>; see
" the airline tab commands below.
let mapleader=","

set hlsearch                " highlight search terms
set autoindent              " autoindent text
set expandtab               " expand tabs to spaces
set tabstop=4               " the width of a hard tab
set nobackup                " don't create a backup file
set number                  " show numbers on the left-margin
set copyindent              " copy indention when moving down a line
set pastetoggle=<C-O>       " key to move into paste mode
set textwidth=79            " width at which to wrap
set scrolloff=5             " number of lines above/below to display
set backspace=2             " make backspace work like it should
set viminfo='20,\"100       " set limits on what is stored in .viminfo
set history=50              " how much history to save
set wildmode=longest:list   " how to treat wilds in completions
set modelines=1             " how many lines to look for modelines
set showmatch               " briefly jump to matching braces/etc
set formatoptions=croql     " standard formatting options
set laststatus=2            " make the status bar always show up
set showtabline=2           " always show the tab line
set wrap                    " display-wrap text
set linebreak               " wrap at word boundaries
set noshowmode              " don't show the mode since airline does this
set hidden                  " hide unsaved buffers rather than closing
set nojoinspaces            " don't use two-spaces following punctuation
set colorcolumn=80          " create a colored column at the char limit
set mouse=a                 " allow mouse selection
set ttymouse=xterm2         " mouse selections update while dragging
set completeopt-=preview    " don't let completions open up a preview window

" newer versions of the vim ftplugin for python (as of vim 7.4) automatically
" set the tab parameters to follow PEP8. So if for whatever reason we don't
" want to do that we must manually override this.
autocmd Filetype python let &l:et=&g:et
autocmd Filetype python let &l:sw=&g:sw
autocmd Filetype python let &l:ts=&g:ts
autocmd Filetype python let &l:sts=&g:sts

" set some nonstandard filetypes
autocmd BufRead *.cls set filetype=tex
autocmd BufRead *.config set filetype=cfg
autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.pyf set filetype=fortran

" enable the list of buffers in airline
let g:airline_theme='base16_monokai'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode=1
let g:airline#extensions#tmuxline#enabled=0

" ignore files in nerdtree
let g:NERDTreeIgnore=['\.pyc$', '\.egg-info$']
let g:NERDTreeWinSize = 25

" a few helpful macros.
map <c-k> <pageup>
map <c-j> <pagedown>
map <silent> <c-l> :nohl<cr>

" slimux commands
vmap <leader>s :SlimuxREPLSendSelection<cr>

" close the current buffer
map <leader>q :Bdelete<cr>

" select buffers based on the numbered airline tab
map <leader>1 <plug>AirlineSelectTab1
map <leader>2 <plug>AirlineSelectTab2
map <leader>3 <plug>AirlineSelectTab3
map <leader>4 <plug>AirlineSelectTab4
map <leader>5 <plug>AirlineSelectTab5
map <leader>6 <plug>AirlineSelectTab6
map <leader>7 <plug>AirlineSelectTab7
map <leader>8 <plug>AirlineSelectTab8
map <leader>9 <plug>AirlineSelectTab9

" When editing a file, always jump to the last known cursor position. Don't do
" it when the position is invalid or when inside an event handler (happens when
" dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" try and read any local vim configuration
if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" make sure that all other indent parameters follow tabstop
let &softtabstop=&g:tabstop
let &shiftwidth=&g:tabstop

if &diff
  set showtabline=0
  let g:airline#extensions#tabline#enabled=0
endif
