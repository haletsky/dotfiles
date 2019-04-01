call plug#begin('~/.vim/plugins')
" Appearance
Plug 'itchyny/lightline.vim'
Plug 'rakr/vim-one'
" Apps
Plug 'itchyny/calendar.vim'
Plug 'vimwiki/vimwiki'
" Functionality
Plug 'docunext/closetag.vim'
Plug 'easymotion/vim-easymotion'
Plug 'mhinz/vim-hugefile'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/denite.nvim'
" Programming
Plug 'airblade/vim-gitgutter'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-fugitive'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jparise/vim-graphql'
Plug 'neoclide/coc.nvim', { 'tag': '*', 'do': { -> coc#util#install() } }
call plug#end()


" BASE SETTINGS "

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
  let g:one_allow_italics = 1
  colorscheme one
catch
endtry
set nocompatible
set number
set autoread
set langmenu=en
set wildmenu
set wildignore=*.pyc,.git,.hg,.svn,*.jpeg,*.jpg,*.png,*.svg,node_modules,.next,build
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
set list listchars=tab:\|\ ,trail:⎵,precedes:<,extends:>
set background=dark
set completeopt-=preview
filetype plugin on
filetype indent on
if !has('gui_running')
  set t_Co=256
endif
if (has("termguicolors"))
  set termguicolors
endif


" PLUGIN CONFIGURATION "

" Large file definition, 500 KiB
let g:hugefile_trigger_size = 0.5
" Calendar
let g:calendar_views = ['year', 'month', 'day', 'clock']
let g:calendar_first_day = 'monday'
" Vimwiki
let g:vimwiki_list = [{'path': '~/.vim/wiki'}]
" NERDTree
let g:NERDTreeChDirMode=1
let g:NERDTreeShowHidden=1
let g:NERDSpaceDelims = 1
let g:NERDTreeMarkBookmarks = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "◉",
    \ "Staged"    : "●",
    \ "Untracked" : "○",
    \ "Dirty"     : "◈",
    \ "Clean"     : "✔︎",
    \ }
" Enable JSX syntax in .js files
let g:jsx_ext_required = 0
" Lightline
let g:lightline = { }
let g:lightline.colorscheme = 'one'
let g:lightline.active = {
  \  'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'relativepath', 'modified', 'readonly' ] ],
  \  'right': [ [ 'percent', 'lineinfo' ], [ 'cocstatus'], [ 'fileformat', 'fileencoding', 'buffersize' ] ]
  \ }
let g:lightline.inactive = { 'left': [['filename']], 'right': [] }
let g:lightline.component_function = {
		\ 'readonly': 'LightlineReadonly',
		\ 'gitbranch': 'LightlineFugitive',
    \ 'cocstatus': 'StatusDiagnostic'
    \ }
let g:lightline.component_expand = {
  \  'linter_warnings': 'LightlineLinterWarnings',
  \  'linter_errors':   'LightlineLinterErrors',
  \  'linter_ok':       'LightlineLinterOK',
  \  'buffersize':      'FileSize'
  \ }
let g:lightline.tab = { 'active': ['title'], 'inactive': ['title'] }
let g:lightline.tab_component_function = { 'title': 'TabTitle' }
let g:lightline.tabline_subseparator = { 'left': '', 'right': '' }
let g:lightline.tabline_separator = { 'left': '', 'right': '' }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '৷', 'right': '৷' }
" Python provider
let g:python_host_prog  = '/usr/bin/python2.7'
let g:python3_host_prog = '/usr/bin/python3'

" AUTOCMDS "

" Do not show numbers in terminal and wiki files
autocmd TermOpen * setlocal nonumber
autocmd FileType vimwiki setlocal nonumber spell
" Close NERDTree if we close last file
autocmd StdinReadPre * let s:std_in = 1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Remove traling spaces after save
autocmd BufWritePre * %s/\s\+$//e
" Load dictinary according to filetype
autocmd FileType * execute 'set dictionary+=~/.vim/dict/'.&filetype
" Update vim buffer if current file changed
autocmd CursorHold,CursorHoldI * checktime
" Use tabs vs spaces in Go files
autocmd FileType go setlocal shiftwidth=4 tabstop=4 noet
" Toggle NERDTree at startup
if v:vim_did_enter
  call s:Setup()
else
  autocmd VimEnter * call s:Setup()
endif
" Move cursor to last edited line when open file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" HOTKEYS "

inoremap <Tab> <C-R>=SmartTab()<CR>
" Map NERDTreeToggle on Control-b
map <C-b> :NERDTreeToggle<CR>
imap <C-b> <C-O>:NERDTreeToggle<CR>
" Tab movement
noremap <A-l> :tabn<CR>
noremap <A-h> :tabp<CR>
" NORMAL mode by jj
imap jj <Esc>
imap <C-j> <C-\><C-n>
vmap <C-j> <C-\><C-n>
tnoremap <C-j> <C-\><C-n>
" COMMAND mode by space
nmap <Space> :
" Comment code
map <C-c> <Plug>NERDCommenterToggle
" Finders
map <C-f> :CocList -I grep<CR>
map <C-p> :CocList files<CR>
" Move to word in file
map f <Plug>(easymotion-bd-W)
map <F1> :call CocAction('doHover')<CR>
map <F2> :call CocAction('jumpDefinition')<CR>
map <F3> :call CocAction('jumpReferences')<CR>
map <F4> :Gstatus<CR>
map <F5> :Gllog -- %<CR>
map gl $
map gh 0
map <C-T> :terminal<CR>


" COMMANDS "

command PrettyJSON %!python -m json.tool

" FUNCTIONS "

function! s:Setup()
  if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in")
    tabe
    execute 'terminal'
    setlocal nonumber
    execute 'VimwikiTabIndex'
    execute 'Calendar -view=year -split=vertical -width=31'
    wincmd w
    setlocal colorcolumn=81
    wincmd v
    vertical resize 80
    setlocal wrap
    wincmd l
    execute 'VimwikiDiaryIndex'
    tabm 0
    tabn
    ene
    execute 'NERDTree' argv()[0]
    execute 'NERDTreeClose'
  endif
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

function! FileSize() abort
    let l:bytes = getfsize(expand('%p'))
    if (l:bytes >= 1024)
        let l:kbytes = l:bytes / 1025
    endif
    if (exists('kbytes') && l:kbytes >= 1000)
        let l:mbytes = l:kbytes / 1000
    endif

    if l:bytes <= 0
        return '0'
    endif

    if (exists('mbytes'))
        return l:mbytes . 'MB'
    elseif (exists('kbytes'))
        return l:kbytes . ' KB'
    else
        return l:bytes . ' B'
    endif
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

function! LightlineFugitive()
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '✔' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, info['error'] . ' ✖ ')
  endif
  if get(info, 'warning', 0)
    call add(msgs, info['warning'] . ' ✱ ')
  endif
  if get(info, 'information', 0)
    call add(msgs, info['information'] . ' ▲ ')
  endif
  if get(info, 'hint', 0)
    call add(msgs, info['hint'] . ' H ')
  endif
  return join(msgs, ' ')
endfunction
