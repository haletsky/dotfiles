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
Plug 'liuchengxu/vim-which-key'
" Programming
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-fugitive'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jparise/vim-graphql'
Plug 'neoclide/coc.nvim', { 'tag': '*', 'do': { -> coc#util#install() } }
Plug 'neoclide/coc-yank', { 'do': 'npm install' }
Plug 'neoclide/coc-tsserver', { 'do': 'npm install' }
Plug 'neoclide/coc-tslint', { 'do': 'npm install' }
Plug 'josa42/coc-go', { 'do': 'npm install' }
Plug 'neoclide/coc-lists', { 'do': 'npm install' }
Plug 'neoclide/coc-git', { 'do': 'npm install' }
Plug 'neoclide/coc-highlight', { 'do': 'npm install' }
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
set nonumber
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
set signcolumn=auto:2
set guifont=Fira\ Code\ Regular:h8
filetype plugin on
filetype indent on
if !has('gui_running')
  set t_Co=256
endif
if (has("termguicolors"))
  set termguicolors
endif



" PLUGIN CONFIGURATION "

" Which-key
let g:which_key_map = {
  \ 'name': 'Menu',
  \ 'd': [':call CocAction("jumpDefinition")', 'Jump to definition'],
  \ 'r': [':call CocAction("jumpReferences")', 'Jump to references'],
  \ 'l': [':Gllog -- %', 'Git log'],
  \ 'j': ['%!python -m json.tool', 'Pretty json'],
  \ 's': [':Gstatus', 'Git status'],
  \ 'p': [':Gpush', 'Git push'],
  \ 'P': [':Gpull', 'Git pull'],
  \ 'b': [':Gblame', 'Git blame'],
  \ }

" Large file definition, 500 KiB
let g:hugefile_trigger_size = 0.5
" Calendar
let g:calendar_views = ['year', 'month', 'day', 'clock']
let g:calendar_first_day = 'monday'
" Vimwiki
let g:vimwiki_list = [{'path': '~/.vim/wiki'}]
" NERDTree
let g:NERDDefaultAlign = 'left'
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


" HIGHLIGHTS

highlight GruvboxGreenSign guifg=#98c379
highlight GruvboxRedSign guifg=#e06c75
highlight GruvboxAquaSign guifg=#e5c07b
highlight HighlightedyankRegion term=bold guifg=#000000 guibg=#e5c07b


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
" Move cursor to last edited line when open file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Setup at startup
autocmd VimEnter * call s:Setup()


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
map <C-g> :CocList outline<CR>
map <C-q> :call CocAction('doQuickfix')<CR>
" Which-key menu
nnoremap z :WhichKeyVisual! g:which_key_map<CR>
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
" command Diff !kitty @ new-window --new-tab --cwd $(pwd) --no-response git difftool --no-symlinks --dir-diff


" FUNCTIONS "

function! s:Setup()
  if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in")
    execute 'cd' argv()[0]
    tabe
    execute 'terminal'
    setlocal nonumber
    execute 'VimwikiTabIndex'
    execute 'Calendar -view=year -split=vertical -width=31'
    wincmd w
    execute 'VimwikiDiaryIndex'
    tabm 0
    tabn
    ene
    call lightline#update()
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
