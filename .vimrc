call plug#begin('~/.vim/plugins')

" Programming
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'marijnh/tern_for_vim'
Plug 'moll/vim-node'
Plug 'leafgarland/typescript-vim'

" Appearance
Plug 'rakr/vim-one'
Plug 'itchyny/lightline.vim'

" Functionality
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vimwiki/vimwiki'
Plug 'docunext/closetag.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'raimondi/delimitmate'
Plug 'mhinz/vim-hugefile'
Plug 'itchyny/calendar.vim'

call plug#end()

" VIM stuff
if !isdirectory($HOME."/.vim")
  call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
  call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
if !isdirectory($HOME."/.vim/wiki")
  call mkdir($HOME."/.vim/wiki", "", 0700)
endif
if !isdirectory($HOME."/.vim/dict")
  call mkdir($HOME."/.vim/dict", "", 0700)
endif

syntax on
set nocompatible
set nowrap
set shiftwidth=2
set tabstop=2
set expandtab
set smarttab
set autoread
set clipboard+=unnamedplus
set undodir=~/.vim/undo-dir
set undofile
set laststatus=2
set noswapfile
set wildignore+=node_modules/**
set noshowmode
set mouse=a
set complete+=k
set cursorline
set list listchars=tab:>-,trail:.,precedes:<,extends:>
colorscheme one
set background=dark
filetype plugin on
filetype indent on

" Large file definition, 500 KiB
let g:hugefile_trigger_size=0.5

" Calendar settings
let g:calendar_views = ['year', 'month', 'day', 'clock']
let g:calendar_first_day = 'monday'

" Vimwiki files location
let g:vimwiki_list = [{'path': '~/.vim/wiki'}]

" Load dictinary according to filetype
au FileType * execute 'set dictionary+=~/.vim/dict/'.&filetype

" NERDTree
let g:NERDTreeChDirMode=1 " Set current working directory
let g:NERDTreeShowHidden=1 " Show hidden files
au bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " Close NERDTree if we close last file
au StdinReadPre * let s:std_in = 1
au VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTreeToggle' argv()[0] | winc p | ene | tabe | exe 'terminal' | vsplit | exe 'terminal' | winc h | exe 'VimwikiTabIndex' | tabm 0 | tabn | endif " Toggle NERDTree at startup
" au VimEnter * if argc() == 0 | exe 'VimwikiIndex' | endif

" Enable JSX syntax in .js files
let g:jsx_ext_required = 0

" Ignore 'node_modules' folder while CtrlP
let g:ctrlp_custom_ignore = 'node_modules'

" ALE linter
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {
\   'javascript': ['eslint', 'standard'],
\   'typescript': ['tslint', 'tsserver', 'typecheck'],
\   'go': ['golint'],
\   'python': ['pylint']
\}

" Lightline
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified', 'readonly' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'linter_warnings', 'linter_errors', 'linter_ok'], [ 'fileformat', 'fileencoding' ] ]
      \ },
      \ 'inactive': {
      \   'left': [],
      \   'right': [],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ▲', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓' : ''
endfunction

autocmd User ALELint call lightline#update()

" Load python provider
let g:python_host_prog  = '/usr/bin/python2.7'
let g:python3_host_prog = '/usr/bin/python3'

" Put 1 space after comment
let g:NERDSpaceDelims = 1

" Autocompletion
function! SmartTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
   endif
endfunction
inoremap <Tab> <C-R>=SmartTab()<CR>

" Keybindings
" Map NERDTreeToggle on Control-b
map <C-b> :NERDTreeToggle<CR>
imap <C-b> <C-O>:NERDTreeToggle<CR>
" Window movement
map <C-j> :winc j<CR>
map <C-k> :winc k<CR>
map <C-h> :winc h<CR>
map <C-l> :winc l<CR>
" Tab movement
noremap <A-l> :tabn<CR>
noremap <A-h> :tabp<CR>
" NORMAL mode by jj
imap jj <Esc>
" COMMAND mode by space
nmap <Space> :
" Comment code
map <C-c> <Plug>NERDCommenterToggle
" Vimwiki toggle
map <C-o> :vs +VimwikiIndex<CR> :vertical res 50<CR>
" TernDefinition
map <C-]> :TernDef<CR>


" One Dark theme
if (has("termguicolors"))
  set termguicolors
endif

" remove traling spaces after save
autocmd BufWritePre * %s/\s\+$//e

" Update vim buffer if current file changed
au CursorHold,CursorHoldI * checktime

function! FindInFiles(...)
  let path = ' **/*.' . expand("%:e")
  let word = expand('<cword>')

  if exists('a:1')
    let word = a:1
  endif

  if exists('a:2')
    let path = a:2
  endif

  execute 'noautocmd lvimgrep ' . word . ' ' . path . ' | lw'
endfunction
command! -nargs=* Find call FindInFiles(<f-args>)
map <C-f> :Find

if !has('gui_running')
  set t_Co=256
endif
