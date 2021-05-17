" PLUGINS {{{
call plug#begin('~/.vim/plugins')
" Appearance
Plug 'itchyny/lightline.vim'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
" Apps
Plug 'vimwiki/vimwiki'
" Functionality
Plug 'docunext/closetag.vim'
Plug 'easymotion/vim-easymotion'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'liuchengxu/vim-which-key'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'mbbill/undotree'
Plug 'wakatime/vim-wakatime'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'preservim/tagbar'
" Programming
Plug 'mxw/vim-jsx'
Plug 'ianks/vim-tsx'
Plug 'cespare/vim-toml'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-fugitive'
Plug 'jparise/vim-graphql'
Plug 'posva/vim-vue'
" Neovim 0.5
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }
call plug#end()
" }}}


" LUA SCRIPTS {{{
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#2c2c2c
      hi LspReferenceText cterm=bold ctermbg=red guibg=#2c2c2c
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#2c2c2c
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "jsonls", "rls", "tsserver", "clangd", 'gopls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}
EOF
" }}}


" BASE SETTINGS {{{
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif
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
  let g:material_theme_style = 'darker'
  let g:material_terminal_italics = 1
  colorscheme material
catch
endtry
set autoread
set background=dark
set clipboard+=unnamedplus
set conceallevel=2
set completeopt=menuone,noselect
set cursorline
set encoding=utf8
set expandtab
set foldenable
set foldlevelstart=10
set foldmethod=syntax
set foldnestmax=10
set hidden
set ignorecase
set langmenu=en
set laststatus=2
set list listchars=tab:\▏\ ,trail:⎵,precedes:<,extends:>
set mouse=a
set nobackup
set nocompatible
set noincsearch
set nonumber
set noshowcmd
set noshowmode
set noswapfile
set nowb
set nowrap
set nowritebackup
set sessionoptions-=blank
set shiftwidth=2
set shortmess+=c
set shortmess+=F
set signcolumn=yes
set smarttab
set tabstop=2
set undodir=~/.vim/undo-dir
set undofile
set updatetime=500
set wildignore=*.pyc,.git,.hg,.svn,*.jpeg,*.jpg,*.png,*.svg,node_modules,.next,build
set wildmenu
filetype plugin on
filetype indent on
if !has('gui_running')
  set t_Co=256
endif
if (has("termguicolors"))
  set termguicolors
endif
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
" }}}


" PLUGIN CONFIGURATION {{{
let g:asyncrun_open = 6
let g:asyncrun_rootmarks = ['.git']
let g:asynctasks_term_pos = 'right'
" Which-key
let g:which_key_use_floating_win = 0
let g:which_key_sort_horizontal = 0
let g:which_key_map = {
  \ 'B': [':Telescope git_branches', 'Git branches'],
  \ 'L': [':Telescope git_bcommits', 'Git log of current file'],
  \ 'P': [':Git push', 'Git push'],
  \ 'b': [':Gblame', 'Git blame'],
  \ 'd': [':Gdiff', 'Git diff'],
  \ 'j': [':%!python -m json.tool', 'Pretty json'],
  \ 'l': [':Telescope git_commits', 'Git log'],
  \ 'p': [':Gpull', 'Git pull'],
  \ 's': [':Gstatus | wincmd L | vertical resize 60', 'Git status'],
  \ 't': [':tabe | terminal', 'Open a terimnal'],
  \ 'T': [':TagbarToggle', 'Tagbar toggle'],
  \ 'u': [':UndotreeToggle | wincmd t', 'Undo tree'],
  \ }
let g:which_key_map['m'] = { 'name': '+tasks-menu' }

" Vimwiki
let g:vimwiki_list = [{'path': '~/.vim/wiki'}]
" Devicons
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:DevIconsEnableFoldersOpenClose = 1
" NERD Commenter
let g:NERDDefaultAlign = "left"
let g:NERDSpaceDelims = 1
" NERDTree
let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '
let g:NERDTreeDirArrowExpandable=""
let g:NERDTreeDirArrowCollapsible=""
let g:NERDTreeChDirMode = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeMarkBookmarks = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoCenter = 1
let g:NERDTreeAutoCenterThreshold = 1
let g:NERDTreeStatusline= ' '
" let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
  \ "Modified"  : "\ue371",
  \ "Staged"    : "\ue39b",
  \ "Untracked" : "\ue38d",
  \ "Dirty"     : "\ue371",
  \ "Renamed"   : "",
  \ "Clean"     : "✔︎",
  \ }
" Enable JSX syntax in .js files
let g:jsx_ext_required = 0
" Lightline
let g:lightline = { }
let g:lightline.colorscheme = 'material_vim'
let g:lightline.active = {
  \  'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'relativepath', 'modified', 'readonly' ] ],
  \  'right': [ [ 'percent', 'lineinfo' ], [ 'buffersize' ], ['filetype'] ]
  \ }
let g:lightline.inactive = { 'left': [['mode'], [], ['filename']], 'right': [] }
let g:lightline.component = {
  \ 'filetype': '%{WebDevIconsGetFileTypeSymbol()} ',
  \ 'relativepath': ' %f'
  \}
let g:lightline.component_function = {
  \ 'readonly': 'LightlineReadonly',
  \ 'mode': 'LightlineMode',
  \ 'gitbranch': 'FugitiveHead',
  \ }
let g:lightline.component_expand = {
  \  'linter_warnings': 'LightlineLinterWarnings',
  \  'linter_errors':   'LightlineLinterErrors',
  \  'linter_ok':       'LightlineLinterOK',
  \  'buffersize':      'FileSize'
  \ }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }
let g:lightline.mode_map = {
  \ 'n' : ' N ',
  \ 'i' : ' I ',
  \ 'R' : ' R ',
  \ 'v' : ' V ',
  \ 'V' : ' V-L ',
  \ "\<C-v>": ' V-B ',
  \ 'c' : ' C ',
  \ 's' : ' S ',
  \ 'S' : ' S-L ',
  \ "\<C-s>": ' S-B ',
  \ 't': ' T ',
  \ }
" Python provider
let g:python_host_prog  = '/usr/bin/python2.7'
let g:python3_host_prog = '/usr/bin/python3'
" }}}


" HIGHLIGHTS {{{
highlight HighlightedyankRegion term=bold guifg=#000000 guibg=#e5c07b
highlight! link NERDTreeFlags NERDTreeDir
" }}}


" AUTOCMDS {{{
" Close NERDTree if we close last file
autocmd StdinReadPre * let s:std_in = 1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Remove traling spaces after save
autocmd BufWritePre * %s/\s\+$//e
" Use tabs vs spaces in Go files
autocmd FileType go setlocal shiftwidth=4 tabstop=4 noet
autocmd FileType nerdtree,fugitive,gitcommit,help,vimwiki setlocal signcolumn=no
autocmd TermOpen * setlocal signcolumn=no
" Move cursor to last edited line when open file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Setup at startup
autocmd VimEnter * call s:Setup()
" Which-key
autocmd VimEnter * silent call InitializeProjectTasks()
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0
  \| autocmd BufLeave <buffer> set laststatus=2
" }}}


" HOTKEYS {{{
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
map <C-f> :Telescope live_grep<CR>
map <C-p> :Telescope find_files<CR>
map <C-g> :Telescope symbols<CR>
map <C-q> :call CocAction('doQuickfix')<CR>
" Which-key menu
nnoremap m :WhichKey! g:which_key_map<CR>
" Move to word in file
map f <Plug>(easymotion-bd-W)
nnoremap <silent><nowait> <F1> :lua vim.lsp.buf.hover()<CR>
nnoremap <silent><nowait> <F2> :Telescope lsp_definitions<CR>
nnoremap <silent><nowait> <F3> :Telescope lsp_references<CR>
nnoremap <silent><nowait> <F4> :Telescope lsp_code_actions<CR>
map gl $
map gh 0
map <C-T> :terminal<CR>
nnoremap <C-Space> za
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
map = :resize -4<CR>
map - :resize +4<CR>
map + :vertical resize -5<CR>
map _ :vertical resize +5<CR>
map ` :call OpenTODO()<CR>
" }}}


" COMMANDS {{{
command PrettyJSON %!python -m json.tool
" command Diff !kitty @ new-window --new-tab --cwd $(pwd) --no-response git difftool --no-symlinks --dir-diff
" }}}


" FUNCTIONS {{{
function! s:Setup()
  if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in")
    execute 'cd' argv()[0]
    " tabe
    " execute 'terminal'
    " execute 'VimwikiTabIndex'
    " execute 'Calendar -view=year -split=vertical -width=31'
    " wincmd w
    " execute 'VimwikiDiaryIndex'
    " tabm 0
    " tabn
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
    let title = '   '
  endif
  if a:1 == 2
    let title = '   '
  endif
  if a:1 == 3
    let title = '   '
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
  return &readonly ? '' : ''
endfunction

function! LightlineGitBranch()
  return FugitiveStatusline()
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

function! LightlineMode()
  return &ft == 'nerdtree' ? '  ' :
        \ &ft == 'fugitive' ? '  ' :
        \ &ft == 'git' ? '  ' :
        \ &ft == 'gitcommit' ? '  ' :
        \ &ft == 'help' ? '  ' :
        \ &ft == 'list' ? '   ' :
        \ &ft == 'undotree' ? '  ' :
        \ &ft == 'vimwiki' ? '  ' :
        \ &ft == 'vim-plug' ? '  ' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! OpenTODO()
  vsplit
  wincmd p
  vertical resize 50
  execute 'VimwikiIndex'
  setlocal wrap
  setlocal signcolumn=no
  setlocal statusline=\ \ TODO
  execute 'autocmd! WinLeave <buffer=' . bufnr('%') . '> exit'
endfunction

function! InitializeProjectTasks()
  for task in asynctasks#source(100)
    let command = task[0]
    let title = substitute(substitute(command, '-', ' ', 'g'), '\<\(\w\)\(\w*\)\>', '\u\1\L\2', 'g') . '  ' . task[2]
    for letter in split(substitute(tolower(trim(command)), 'project-', '', 'g'), '\zs')
      if has_key(g:which_key_map['m'], letter) == 0
        let g:which_key_map['m'][letter] = [':AsyncTask ' . command, title]
        break
      endif
    endfor
  endfor
endfunction

" }}}

" vim:foldmethod=marker:foldlevel=0
