call plug#begin('~/.vim/plugins')

" Programming
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'moll/vim-node'
Plug 'leafgarland/typescript-vim'
Plug 'ElmCast/elm-vim'

" Appearance
Plug 'rakr/vim-one'
Plug 'itchyny/lightline.vim'

" Functionality
Plug 'scrooloose/nerdtree'
Plug 'vimwiki/vimwiki'
Plug 'docunext/closetag.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'raimondi/delimitmate'
Plug 'mhinz/vim-hugefile'
Plug 'itchyny/calendar.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ryanss/vim-hackernews'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/deoplete.nvim'

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
try
  colorscheme one
catch
endtry
set nocompatible
set autoread
set langmenu=en
set wildmenu
set wildignore=node_modules
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
set nobackup
set nowb
set noshowmode
set mouse=a
set ignorecase
set encoding=utf8
set complete+=k
set cursorline
set list listchars=tab:>-,trail:.,precedes:<,extends:>
set background=dark
filetype plugin on
filetype indent on


" Large file definition, 500 KiB
let g:hugefile_trigger_size = 0.5
" Calendar settings
let g:calendar_views = ['year', 'month', 'day', 'clock']
let g:calendar_first_day = 'monday'
" Vimwiki files location
let g:vimwiki_list = [{'path': '~/.vim/wiki'}]
" Set current working directory
let g:NERDTreeChDirMode=1
" Show hidden files
let g:NERDTreeShowHidden=1
" Enable JSX syntax in .js files
let g:jsx_ext_required = 0
" Ignore 'node_modules' folder while CtrlP
let g:ctrlp_custom_ignore = 'node_modules'
" ALE linter
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
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
      \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'relativepath', 'modified', 'readonly' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'linter_warnings', 'linter_errors', 'linter_ok'], [ 'fileformat', 'fileencoding' ] ]
      \ },
      \ 'inactive': {
      \   'left': [],
      \   'right': [],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'tab_component_function': {
      \   'title': 'TabTitle'
      \ },
      \ 'tab': {
      \   'active': ['title'],
      \   'inactive': ['title']
      \ },
      \ 'subseparator': {
      \   'left': '৷',
      \   'right': '৷'
      \ },
      \ }
" Load python provider
let g:python_host_prog  = '/usr/bin/python2.7'
let g:python3_host_prog = '/usr/bin/python3'
" Put 1 space after comment
let g:NERDSpaceDelims = 1

let g:deoplete#enable_at_startup = 1
let ignore=&wildignore . ',*.pyc,.git,.hg,.svn'
call denite#custom#var('grep', 'pattern_opt', ['--exclude-dir=node_modules'])
call denite#custom#var('file_rec', 'command',
    \ ['scantree.py', '--ignore', ignore])
call denite#custom#map(
      \ 'insert',
      \ '<C-j>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ '<C-k>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)
let s:menus = {}
let s:menus.confs = {
  \ 'description': 'Configuration files'
  \ }
let s:menus.confs.file_candidates = [
  \ ['zshrc', '~/.zshrc', 'sjoi'],
  \ ['vimrc', '~/.vimrc'],
  \ ]
let s:menus.cmmnds = {
  \ 'description': 'Some commands'
  \ }
let s:menus.cmmnds.command_candidates = [
  \ ['Vimwiki', 'VimwikiIndexTab'],
  \ ['Calendar', 'Calendar -position=tab'],
  \ ['Hacker News', 'tabe | HackerNews']
  \ ]
call denite#custom#var('menu', 'menus', s:menus)


" AUTOCMDS

" Close NERDTree if we close last file
autocmd StdinReadPre * let s:std_in = 1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Update status line when did lint
autocmd User ALELint call lightline#update()
" remove traling spaces after save
autocmd BufWritePre * %s/\s\+$//e
" Load dictinary according to filetype
autocmd FileType * execute 'set dictionary+=~/.vim/dict/'.&filetype
" Update vim buffer if current file changed
autocmd CursorHold,CursorHoldI * checktime
" Toggle NERDTree at startup
autocmd VimEnter * call s:Setup()


" HOTKEYS

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
" Denite
map <C-o> :Denite menu<CR>
map <C-f> :Denite grep<CR>
map <C-p> :Denite file_rec<CR>
" Move to word in file
map f <Plug>(easymotion-bd-W)

command! -nargs=* Find call s:FindInFiles(<f-args>)

if !has('gui_running')
  set t_Co=256
endif
" One Dark theme
if (has("termguicolors"))
  set termguicolors
endif

function! s:Setup()
  if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in")
    execute 'NERDTreeToggle' argv()[0]
    winc p
    ene
    tabe
    execute 'terminal'
    vsplit
    execute 'terminal'
    winc h
    execute 'VimwikiTabIndex'
    execute 'Calendar -view=year -split=vertical -width=31'
    tabm 0
    tabn
  endif
endfunction

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✱', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✖', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✔' : ''
endfunction

function! SmartTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
   endif
endfunction

function! TabTitle(...)
 let title = a:1
  if a:1 == 1
    let title = '᚛ Home     ᚜'
  endif
  if a:1 == 2
    let title = '᚛ Editor   ᚜'
  endif
  if a:1 == 3
    let title = '᚛ Terminal ᚜'
  endif
  return title
endfunction
