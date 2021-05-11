" This runs pathogen (which should be in ~/.vim/autoload/pathogen.vim) and
" allows for the loading of any plugins found in ~/.vim/bundle.
execute pathogen#infect()

set hlsearch                " highlight search terms
set autoindent              " autoindent text
set expandtab               " expand tabs to spaces
set tabstop=2               " the width of a hard tab
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
set nofoldenable            " disable code folding. re-enable with zi.

" Load plugin and indent files based on the current filetype. Also turn on
" syntax highlighting.
filetype plugin indent on
syntax on

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
autocmd BufRead *.pyf set filetype=fortran

" Use the gruvbox color scheme.
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_contrast_light='medium'
let g:gruvbox_italic=1
let g:gruvbox_underline=1
let g:gruvbox_undercurl=1

set background=dark
colorscheme gruvbox

" Gruvbox defines how directory information is highlighted. Overwrite this so
" that it corresponds to dircolors.
hi! link Directory GruvboxBlue
hi! link NERDTreeDir Directory
hi! link NERDTreeDirSlash Directory
hi! link NERDTreeCWD GruvboxGray
hi! link NERDTreeExecFile GruvboxGreen
hi! link NERDTreeLinkFile GruvboxAqua

" Nerdtree insists on displaying the target for symlinks, but we can use syntax
" highlighting to hide this. It would be much nicer to use conceal, but that's
" not always compiled in to vim.
hi! link NERDTreeLinkTarget GruvboxBG0

" Set options for nerdtree.
let g:NERDTreeStatusline='NERDTree'
let g:NERDTreeHighlightCursorline=0
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore=['\.swp$', '^\.git$', '\.pyc$', '\.egg-info$']
let g:NERDTreeWinSize=25

" Set options for airline.
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode=1

" Set the 'leader' key which can be used as <leader> in key mappings.
let mapleader=','

" Set useful mappings for pageup and pagedown.
nmap <c-k> <pageup>
nmap <c-j> <pagedown>
nmap <c-l> :noh<cr>
nmap <silent> <c-t> :NERDTreeToggle<cr>:wincmd p<cr>

" Use the leader key and then 1-9 to select individual tabs or use q to close
" the current tab (i.e. buffer).
nmap <leader>1 <plug>AirlineSelectTab1
nmap <leader>2 <plug>AirlineSelectTab2
nmap <leader>3 <plug>AirlineSelectTab3
nmap <leader>4 <plug>AirlineSelectTab4
nmap <leader>5 <plug>AirlineSelectTab5
nmap <leader>6 <plug>AirlineSelectTab6
nmap <leader>7 <plug>AirlineSelectTab7
nmap <leader>8 <plug>AirlineSelectTab8
nmap <leader>9 <plug>AirlineSelectTab9
nmap <leader>q :Bdelete<cr>

" Turn off tablines in airline if displaying a diff.
if &diff
  set showtabline=0
  let g:airline#extensions#tabline#enabled=0
endif

" Turn off background color erase.
let &t_ut=''

" When editing a file, always jump to the last known cursor position. Don't do
" it when the position is invalid or when inside an event handler (happens when
" dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" try and read any local vim configuration
if filereadable(glob("~/.vimrc.include"))
  source ~/.vimrc.include
endif

" Make sure that all other indent parameters follow tabstop. Do this after
" sourcing the include above so that it can override the tabstop value.
let &softtabstop=&g:tabstop
let &shiftwidth=&g:tabstop

