call plug#begin('~/.vim/plugins')
" Appearance
Plug 'itchyny/lightline.vim'
Plug 'rakr/vim-one'
" Apps
Plug 'itchyny/calendar.vim'
Plug 'ryanss/vim-hackernews'
Plug 'vimwiki/vimwiki'
" Functionality
Plug 'docunext/closetag.vim'
Plug 'easymotion/vim-easymotion'
Plug 'mhinz/vim-hugefile'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'jamessan/vim-gnupg'
Plug 'rhysd/vim-grammarous'
" Programming
Plug 'airblade/vim-gitgutter'
Plug 'moll/vim-node'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'mhartington/nvim-typescript', { 'do': './install.sh' }
Plug 'HerringtonDarkholme/yats.vim'
Plug 'tpope/vim-fugitive'
Plug 'w0rp/ale'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'fatih/vim-go', { 'do': 'GoUpdateBinaries' }
Plug 'ternjs/tern_for_vim'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install --global tern' }
Plug 'zchee/deoplete-go', { 'do': 'make' }
Plug 'jparise/vim-graphql'
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
" let g:discord_activate_on_enter = 0
let g:grammarous#use_vim_spelllang = 1
let g:grammarous#languagetool_cmd = 'languagetool'
" TernJS
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
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
" ALE linter
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_fix_on_save = 1
let g:ale_linters = { }
let g:ale_linters.javascript = ['eslint', 'standard']
let g:ale_linters.typescript = ['tslint', 'tsserver', 'typecheck']
let g:ale_linters.python = ['pylint']
let g:ale_linters.go = ['golint', 'gofmt', 'go build']
let g:ale_fixers = { }
let g:ale_fixers.javascript = ['eslint', 'standard']
let g:ale_fixers.go = ['gofmt', 'goimports']
" Lightline
let g:lightline = { }
let g:lightline.colorscheme = 'one'
let g:lightline.active = {
  \  'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'relativepath', 'modified', 'readonly' ] ],
  \  'right': [ [ 'percent', 'lineinfo' ], [ 'linter_warnings', 'linter_errors', 'linter_ok'], [ 'fileformat', 'fileencoding', 'buffersize' ] ]
  \ }
let g:lightline.inactive = { 'left': [['filename']], 'right': [] }
let g:lightline.component_function = {
		\ 'readonly': 'LightlineReadonly',
		\ 'gitbranch': 'LightlineFugitive'
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
" Dark Powered plugins
let g:deoplete#enable_at_startup = 1
let g:deoplete#file#enable_buffer_path = 1
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--ignore', 'node_modules'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('file_rec', 'command', ['scantree.py', '--ignore', &wildignore])
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
let s:menus.confs = { }
let s:menus.confs.description = 'Configuration files'
let s:menus.confs.file_candidates = [
  \ ['zshrc', '~/.zshrc', 'sjoi'],
  \ ['vimrc', '~/.vimrc'],
  \ ]
let s:menus.apps = { }
let s:menus.apps.description = 'List of applicatons.'
let s:menus.apps.command_candidates = [
  \ ['Vimwiki', 'tabe | tabm | VimwikiIndex'],
  \ ['Calendar', 'tabe | tabm | Calendar'],
  \ ['Hacker News', 'tabe | tabm | setlocal nonumber | HackerNews']
  \ ]
call denite#custom#var('menu', 'menus', s:menus)


" AUTOCMDS "

" Do not show numbers in terminal and wiki files
autocmd TermOpen * setlocal nonumber
autocmd WinEnter term://* execute "startinsert"
autocmd FileType vimwiki setlocal nonumber spell
" Close NERDTree if we close last file
autocmd StdinReadPre * let s:std_in = 1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Update status line when did lint
autocmd User ALELint call lightline#update()
" Remove traling spaces after save
autocmd BufWritePre * %s/\s\+$//e
" Load dictinary according to filetype
autocmd FileType * execute 'set dictionary+=~/.vim/dict/'.&filetype
" Update vim buffer if current file changed
autocmd CursorHold,CursorHoldI * checktime
" Use tabs vs spaces in Go files
autocmd FileType go setlocal shiftwidth=4 tabstop=4 noet
" Open documentation based on language
autocmd FileType go map <F1> :GoDoc<CR>
autocmd FileType javascript map <F1> :TernDoc<CR>
autocmd FileType typescript map <F1> :TSDoc<CR>
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
" Keybindings
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
" Denite
map <C-o> :Denite buffer<CR>
map <C-f> :Denite grep<CR>
map <C-p> :Denite file_rec<CR>
" Move to word in file
map f <Plug>(easymotion-bd-W)
map <F2> :ALEGoToDefinition<CR>
map <F3> :ALEFindReferences<CR>
map <F4> :GitGutterNextHunk<CR>


" FUNCTIONS "

function! s:Setup()
  if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in")
    execute 'NERDTreeToggle' argv()[0]
    winc p
    ene
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