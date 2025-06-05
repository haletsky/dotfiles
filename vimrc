" PLUGINS: {{{
call plug#begin('~/.vim/plugins')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'neovim/nvim-lspconfig'
Plug 'haletsky/rasmus.nvim'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'docunext/closetag.vim'
Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }
Plug 'folke/trouble.nvim'
" Plug 'hashivim/vim-terraform'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'petertriho/cmp-git'
Plug 'itchyny/lightline.vim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'leafgarland/typescript-vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'onsails/lspkind.nvim'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'
Plug 'MunifTanjim/nui.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'nvchad/volt'
Plug 'nvchad/menu'
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }
Plug 'folke/which-key.nvim'
Plug 'folke/neodev.nvim'
call plug#end()
" }}}


" BASE SETTINGS: {{{
" ─────────────────────────────────────────────────────────────────────────────
" Enable True Color and basic colorscheme
" ─────────────────────────────────────────────────────────────────────────────
if has('nvim')
  " Make sure true color works in the terminal
  set termguicolors
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

" Turn on syntax highlighting and set colorscheme
syntax on
colorscheme rasmus         " Remove try/catch if you know this scheme always exists

" ─────────────────────────────────────────────────────────────────────────────
" Basic editor options
" ─────────────────────────────────────────────────────────────────────────────
set background=dark        " Use dark theme
set clipboard+=unnamedplus " Use system clipboard
set mouse=a                " Enable mouse in all modes
set number                 " Show line numbers
set nocursorline           " Do not highlight current line
set signcolumn=yes         " Always show sign column (for lint/Git signs, etc.)
set fillchars=eob:\ ,vert:\│
                          " Remove ~ after EOF and set vertical line char

" ─────────────────────────────────────────────────────────────────────────────
" Search and completion settings
" ─────────────────────────────────────────────────────────────────────────────
set ignorecase          " Case-insensitive search
set wildmenu            " Enhanced command-line completion
set wildignore+=*.pyc,.git,.hg,.svn,*.jpeg,*.jpg,*.png,*.svg,node_modules,.next,build
                        " Files/folders to ignore in filename completion

set completeopt=menuone,noselect
                        " Better completion behavior (e.g., for nvim-cmp)
set shortmess+=Fc       " Avoid certain messages (F = file info, c = completion messages)

" ─────────────────────────────────────────────────────────────────────────────
" Folding
" ─────────────────────────────────────────────────────────────────────────────
set foldenable             " Enable code folding
set foldmethod=syntax      " Fold based on syntax
set foldnestmax=10         " Maximum fold nesting
set foldlevelstart=10      " Start with folds open up to level 10

" ─────────────────────────────────────────────────────────────────────────────
" Editing and undo
" ─────────────────────────────────────────────────────────────────────────────
set hidden            " Allow switching buffers without saving
set undodir=~/.vim/undo
set undofile          " Persistent undo
set updatetime=500    " Faster CursorHold and autoread
set autoread          " Auto-reload file if changed outside

set smarttab shiftwidth=4 tabstop=4 expandtab
                      " Use spaces instead of tabs; each indent = 4 spaces

set nowrap            " Don’t wrap long lines
set conceallevel=2    " Hide some markup (e.g., in Markdown)

" ─────────────────────────────────────────────────────────────────────────────
" Session and statusline
" ─────────────────────────────────────────────────────────────────────────────
set laststatus=3           " Global statusline at the bottom
set sessionoptions-=blank  " Don’t save empty windows in sessions

" ─────────────────────────────────────────────────────────────────────────────
" Netrw (built-in file explorer) settings
" ─────────────────────────────────────────────────────────────────────────────
let g:netrw_banner   = 0    " Disable banner
let g:netrw_liststyle = 3   " Tree-style listing
let g:netrw_browse_split = 4
let g:netrw_altv    = 1     " Open splits to the left
let g:netrw_winsize = 25    " Explorer window width

" ─────────────────────────────────────────────────────────────────────────────
" Miscellaneous tweaks
" ─────────────────────────────────────────────────────────────────────────────
set noswapfile       " Don’t create swap files
set nobackup         " Don’t create backup files
set nowritebackup    " Don’t create writebackup files
set makeprg=make     " Use ‘make’ for :make
set shell=/bin/zsh   " Use zsh as shell

" ─────────────────────────────────────────────────────────────────────────────
" Filetype, plugin and indent detection
" ─────────────────────────────────────────────────────────────────────────────
filetype plugin indent on

" ─────────────────────────────────────────────────────────────────────────────
" Disable unused providers to speed up startup
" ─────────────────────────────────────────────────────────────────────────────
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
" }}}


" LOAD LUA CONFIG: {{{
lua << EOF
require'neodev'.setup{}
require'dressing'.setup{}

local mapnormalmode = { i = { ["<C-j>"] = { "<esc>", type = "command" } } }
require'telescope'.setup{
  pickers = {
    live_grep = {
      mappings = mapnormalmode,
    },
    git_files = {
      mappings = mapnormalmode,
    },
    grep_string = {
      mappings = mapnormalmode,
    },
    find_files = {
      hidden = true,
      mappings = mapnormalmode,
    },
  },
}
require'telescope'.load_extension'media_files'

require'gitsigns'.setup{
  numhl      = true,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
  }
}
require'trouble'.setup{}
require'custom-lsp'
require'custom-bufferline'
require'custom-nvim-tree'
require'custom-which-key'
require'custom-avante'
require'custom-markdown'
EOF
" }}}


" PLUGIN CONFIGURATION: {{{
let g:scrollview_excluded_filetypes = ['NvimTree', 'gitcommit', 'vimwiki', 'fugitive']
let g:scrollview_always_show = 1
" VimWiki:
let g:vimwiki_ext2syntax = {}
let g:vimwiki_list = [{'path': '~/.vim/wiki'}]
" NERD Commenter:
let g:NERDDefaultAlign = "left"
let g:NERDSpaceDelims = 1
" NvimTree:
let g:nvim_tree_group_empty = 1
let g:nvim_tree_add_trailing = 1
let g:nvim_tree_width = 40
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_disable_window_picker = 1
let g:nvim_tree_icons = { 'default': '' }
let g:nvim_tree_width_allow_resize = 1
" Lightline:
let g:lightline = { }
let g:lightline.colorscheme = 'material_vim'
let g:lightline.active = {
  \  'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'modified', 'readonly' ], ['relativepath'] ],
  \  'right': [ [ 'percent', 'lineinfo' ], ['gitsign_status'] , [ 'buffersize' ] ]
  \ }
let g:lightline.component = {
  \ 'gitbranch':      "%{FugitiveHead() != '' ? '  ' . ' ' . FugitiveHead() : ''}",
  \ 'readonly':       "%{&readonly ? '' : ''}",
  \ 'gitsign_status': "%{get(b:,'gitsigns_status','')}",
  \ 'lineinfo': '%{line(".").":".col(".")}'
  \ }
let g:lightline.component_function = {
  \ 'mode':           'LightlineMode',
  \ }
let g:lightline.component_expand = {
  \  'linter_warnings': 'LightlineLinterWarnings',
  \  'linter_errors':   'LightlineLinterErrors',
  \  'linter_ok':       'LightlineLinterOK',
  \  'buffersize':      'FileSize'
  \ }
let g:lightline.enable = { 'tabline': 0 }
let g:lightline.separator = { 'left': '', 'right': '' }
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
" Python Provider:
let g:python_host_prog  = '/usr/bin/python3'
let g:python3_host_prog = '/usr/bin/python3'
" }}}


" HIGHLIGHTS: {{{
" Give the message area a custom background
highlight MsgArea guibg=#1a1a19

" Temporarily highlight text on yank
augroup YankHighlight
  " clear existing autocmds in this group
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup = 'IncSearch', timeout = 300 }
augroup END

" Make NonText characters (e.g. trailing ~) blend into the background
highlight NonText guifg=bg

" Toggle cursorline only in the focused window
" augroup CursorLineToggle
  " clear existing autocmds in this group
  " autocmd!
  " autocmd WinEnter * setlocal cursorline
  " autocmd WinLeave * setlocal nocursorline
" augroup END
" }}}


" AUTOCMDS: {{{
" On Vim startup, cd to the directory of the opened file
augroup AutoChdir
  autocmd!
  autocmd VimEnter * silent! lcd %:p:h
augroup END

" Strip trailing whitespace on save
augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

" Indentation rules by filetype
augroup FiletypeIndent
  autocmd!
  " Go: use tabs (4 spaces per tab)
  autocmd FileType go,lua setlocal shiftwidth=4 tabstop=4 noexpandtab

  " JS/TS/Vimscript: use 2-space (spaces instead of tabs)
  autocmd FileType javascript,typescript,vim setlocal shiftwidth=2 tabstop=2 expandtab
augroup END

" Disable signcolumn and number for certain filetypes
augroup FiletypeDisplay
  autocmd!
  autocmd FileType fugitive,gitcommit,help,vimwiki,vim-plug
        \ setlocal signcolumn=no nonumber wrap linebreak

  " In terminal buffers, hide the signcolumn and line numbers
  autocmd TermOpen * setlocal signcolumn=no nonumber
augroup END

" Restore cursor to last edit position on file open
augroup LastCursor
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
augroup END
" }}}


" HOTKEYS: {{{

" NvimTree: Toggle with Ctrl-b (normal and insert modes)
nnoremap <silent> <C-b> :call CloseSidewinsButNoNvimTree()<CR>
inoremap <silent> <C-b> <C-O>:call CloseSidewinsButNoNvimTree()<CR>

" ─────────────────────────────────────────────────────────────────────────────
" Buffer/Tab Navigation
" ─────────────────────────────────────────────────────────────────────────────
" Cycle through buffers with Alt-l and Alt-h
nnoremap <silent> <A-l> :BufferLineCycleNext<CR>
nnoremap <silent> <A-h> :BufferLineCyclePrev<CR>

" Switch tabs: ( = previous tab, ) = next tab
nnoremap <silent> ( :tabprevious<CR>
nnoremap <silent> ) :tabnext<CR>

" Gitsigns: navigate and manipulate hunks
nnoremap <silent> gn :Gitsigns nav_hunk next preview=true<CR>
nnoremap <silent> gp :Gitsigns nav_hunk prev preview=true<CR>
nnoremap <silent> gx :Gitsigns reset_hunk<CR>
nnoremap <silent> gs :Gitsigns stage_hunk<CR>

" Buffer close
nnoremap <silent> <A-d> :call CloseBuffer()<CR>
nnoremap <silent> <A-D> :call CloseBuffer()<CR>

" ─────────────────────────────────────────────────────────────────────────────
" Mode Switching
" ─────────────────────────────────────────────────────────────────────────────
" Quickly return to NORMAL from insert/terminal/visual with Ctrl-j or jj
inoremap <silent> jj    <Esc>
inoremap <silent> <C-j> <C-\><C-n>
vnoremap <silent> <C-j> <C-\><C-n>
tnoremap <silent> <C-j> <C-\><C-n>

" Enter COMMAND mode by pressing Space in normal mode
nnoremap <Space> :

" ─────────────────────────────────────────────────────────────────────────────
" Commenting
" ─────────────────────────────────────────────────────────────────────────────
" Toggle comments with Ctrl-c (NERDCommenter)
noremap <silent> <C-c> <Plug>NERDCommenterToggle

" ─────────────────────────────────────────────────────────────────────────────
" Finders (Telescope)
" ─────────────────────────────────────────────────────────────────────────────
nnoremap <silent> <C-f>   <cmd>Telescope live_grep<CR>
vnoremap <silent> <C-f>   <cmd>Telescope grep_string<CR>
nnoremap <silent> <C-p>   <cmd>Telescope git_files<CR>
nnoremap <silent> <C-S-P> <cmd>Telescope find_files<CR>

" ─────────────────────────────────────────────────────────────────────────────
" LSP & Symbols
" ─────────────────────────────────────────────────────────────────────────────
" Hover documentation with F1 (bordered if configured in LSP)
nnoremap <silent> <F1> <cmd>lua vim.lsp.buf.hover({
      \ border = "rounded",
      \ silent = true,
      \ max_width = 80,
      \ wrap = true,
      \ })<CR>

" Jump to definition, references, implementations, code actions
nnoremap <silent> <F2>  <cmd>Telescope lsp_definitions<CR>
nnoremap <silent> <F3>  <cmd>Telescope lsp_references<CR>
nnoremap <silent> <F4>  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gi    <cmd>Telescope lsp_implementations<CR>
nnoremap <silent> gd    <cmd>Telescope lsp_definitions<CR>
nnoremap <silent> gr    <cmd>Telescope lsp_references<CR>
nnoremap <silent> gw    <cmd>Telescope lsp_dynamic_workspace_symbols<CR>

" ─────────────────────────────────────────────────────────────────────────────
" Word-Wrapped Movement
" ─────────────────────────────────────────────────────────────────────────────
" Move by display lines when lines wrap
nnoremap <silent> j gj
nnoremap <silent> k gk
map <silent> gl $
map <silent> gh 0

" ─────────────────────────────────────────────────────────────────────────────
" Terminal
" ─────────────────────────────────────────────────────────────────────────────
" Open terminal with Ctrl-T
nnoremap <silent> <C-T> :terminal<CR>

" ─────────────────────────────────────────────────────────────────────────────
" Window/Pane Resizing
" ─────────────────────────────────────────────────────────────────────────────
" Resize height with = (smaller) and - (larger)
nnoremap <silent> = :resize -4<CR>
nnoremap <silent> - :resize +4<CR>

" Resize width with + (narrower) and _ (wider)
nnoremap <silent> + :vertical resize -5<CR>
nnoremap <silent> _ :vertical resize +5<CR>

" ─────────────────────────────────────────────────────────────────────────────
" Text Movement (Move lines up/down)
" ─────────────────────────────────────────────────────────────────────────────
" Normal mode: Alt-j/k to move current line down/up
nnoremap <silent> <A-j> :m .+1<CR>==
nnoremap <silent> <A-k> :m .-2<CR>==

" Insert mode: Alt-j/k to move current line down/up (and re-enter insert)
inoremap <silent> <A-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <A-k> <Esc>:m .-2<CR>==gi

" Visual mode: Alt-j/k to move selected block down/up
vnoremap <silent> <A-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-k> :m '<-2<CR>gv=gv

" ─────────────────────────────────────────────────────────────────────────────
" Other Mappings
" ─────────────────────────────────────────────────────────────────────────────
" Disable Ctrl-LeftMouse to prevent accidental clicks
nnoremap <silent> <C-LeftMouse> <Nop>

" Unfold
nnoremap <C-Space> za

" Visual: search for selection with *
vnoremap <silent> * y/\V<C-R>=escape(@",'/\')<CR><CR>

" TODO: Open TODO list with backtick
nnoremap <silent> ` :call OpenTODO()<CR>
" }}}


" COMMANDS: {{{
command PrettyJSON %!python -m json.tool
" command Diff !kitty @ new-window --new-tab --cwd $(pwd) --no-response git difftool --no-symlinks --dir-diff
" }}}


" FUNCTIONS: {{{
function! CloseSidewins()
  silent! bd */.git//
  silent! bd */index.wiki
  silent! bd *.wiki
  lua require 'nvim-tree.api'.tree.close()
endfunction

function! CloseSidewinsButNoNvimTree()
  silent! bd */.git//
  silent! bd */index.wiki
  silent! bd *.wiki
  set equalalways
  lua require 'nvim-tree.api'.tree.toggle()
endfunction

function! SmartTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
   endif
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

function! LightlineMode()
  return &ft == 'NvimTree' ? '  ' :
        \ &ft == 'fugitive' ? '  ' :
        \ &ft == 'git' ? '  ' :
        \ &ft == 'gitcommit' ? '  ' :
        \ &ft == 'help' ? '  ' :
        \ &ft == 'list' ? '   ' :
        \ &ft == 'undotree' ? '  ' :
        \ &ft == 'vimwiki' ? '  ' :
        \ &ft == 'vim-plug' ? '  ' : lightline#mode()
endfunction

function! OpenTODO()
  call CloseSidewins()
  vsplit
  execute 'VimwikiIndex'
  wincmd H
  vertical resize 40
  set winhl=Normal:NvimTreeNormal
  set wrap
  set signcolumn=no
  execute 'autocmd! WinLeave <buffer=' . bufnr('%') . '> silent! exit'
endfunction

" function! InitializeProjectTasks()
"   for task in asynctasks#source(100)
"     let command = task[0]
"     let title = substitute(substitute(command, '-', ' ', 'g'), '\<\(\w\)\(\w*\)\>', '\u\1\L\2', 'g') . '  ' . task[2]
"     for letter in split(substitute(tolower(trim(command)), 'project-', '', 'g'), '\zs')
"       if has_key(g:which_key_map['m'], letter) == 0
"         let g:which_key_map['m'][letter] = [':AsyncTask ' . command, title]
"         break
"       endif
"     endfor
"   endfor
" endfunction

function! CloseBuffer()
  let l:bufnum = bufnr()
  execute 'bp'
  execute 'bd' . l:bufnum
endfunction
" }}}


" MATERIAL LIGHTLINE THEME: {{{
let g:colors_name = 'material'
let g:material_theme_style = 'darker'
let g:material_terminal_italics = get(g:, 'material_terminal_italics', 0)
let s:bg = { 'gui': '#1a1a19', 'cterm': 'none' }
let s:fg = { 'gui': '#b6b6b5', 'cterm': 231 }
let s:invisibles = { 'gui': '#65738e', 'cterm': 66 }
let s:comments = { 'gui': '#616161', 'cterm': 145 }
let s:caret = { 'gui': '#ffcc00', 'cterm': 220 }
let s:selection = { 'gui': '#404040', 'cterm': 239 }
let s:guides = { 'gui': '#37474f', 'cterm': 17 }
let s:line_numbers = { 'gui': '#3a3a39', 'cterm': 145 }
let s:line_highlight = { 'gui': '#1a2327', 'cterm': 235 }
let s:white = { 'gui': '#d1d1d1', 'cterm': 231 }
let s:black = { 'gui': '#333332', 'cterm': 232 }
let s:darker = { 'gui': '#1a1a1a', 'cterm': 232 }
let s:red = { 'gui': '#ff968c', 'cterm': 203 }
let s:orange = { 'gui': '#F78C6C', 'cterm': 209 }
let s:yellow = { 'gui': '#ffc591', 'cterm': 11 }
let s:green = { 'gui': '#61957f', 'cterm': 2 }
let s:cyan = { 'gui': '#7bb099', 'cterm': 117 }
let s:blue = { 'gui': '#8db4d4', 'cterm': 111 }
let s:paleblue = { 'gui': '#B0C9FF', 'cterm': 152 }
let s:purple = { 'gui': '#C792EA', 'cterm': 176 }
let s:brown = { 'gui': '#c17e70', 'cterm': 137 }
let s:pink = { 'gui': '#FF9CAC', 'cterm': 204 }
let s:violet = { 'gui': '#bb80b3', 'cterm': 139 }

" Defined globally so that the Airline theme has access
if (exists('g:lightline'))
  let s:palette = { 'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'command': {}, 'terminal': {} }

  let s:palette.normal.left = [ [
      \ s:bg.gui,
      \ s:green.gui,
      \ g:material_theme_style == 'lighter' ?
        \ s:white.cterm :
        \ s:black.cterm,
      \ s:green.cterm
    \ ], [
      \ s:fg.gui,
      \ s:line_numbers.gui,
      \ s:fg.cterm,
      \ s:selection.cterm
    \ ]]
  let s:palette.normal.right = s:palette.normal.left

  let s:palette.normal.middle = [ [
      \ s:fg.gui,
      \ s:darker.gui,
      \ s:fg.cterm,
      \ s:selection.cterm
    \ ] ]

  let s:palette.normal.error = [ [
      \ s:bg.gui,
      \ s:red.gui,
      \ g:material_theme_style == 'lighter' ?
        \ s:white.cterm :
        \ s:black.cterm,
      \ s:red.cterm
    \ ] ]

  let s:palette.normal.warning = [ [
      \ s:bg.gui,
      \ s:yellow.gui,
      \ g:material_theme_style == 'lighter' ?
        \ s:white.cterm :
        \ s:black.cterm,
      \ s:yellow.cterm,
    \ ] ]

  let s:palette.insert.left = [ [
      \ s:bg.gui,
      \ s:brown.gui,
      \ g:material_theme_style == 'lighter' ?
        \ s:white.cterm :
        \ s:black.cterm,
      \ s:brown.cterm
    \ ], [
      \ s:fg.gui,
      \ s:line_numbers.gui,
      \ s:fg.cterm,
      \ s:selection.cterm
    \ ] ]
  let s:palette.insert.right = s:palette.insert.left

  let s:palette.replace.left = [ [
      \ s:bg.gui,
      \ s:red.gui,
      \ g:material_theme_style == 'lighter' ?
        \ s:white.cterm :
        \ s:black.cterm,
      \ s:red.cterm
    \ ], [
      \ s:fg.gui,
      \ s:line_numbers.gui,
      \ s:fg.cterm,
      \ s:selection.cterm
    \ ] ]
  let s:palette.replace.right = s:palette.replace.left

  let s:palette.visual.left = [ [
      \ s:bg.gui,
      \ s:purple.gui,
      \ g:material_theme_style == 'lighter' ?
        \ s:white.cterm :
        \ s:black.cterm,
      \ s:blue.cterm
    \ ], [
      \ s:fg.gui,
      \ s:line_numbers.gui,
      \ s:fg.cterm,
      \ s:selection.cterm
    \ ] ]
  let s:palette.visual.right = s:palette.visual.left

  let s:palette.terminal.left = [ [
      \ s:bg.gui,
      \ s:pink.gui,
      \ g:material_theme_style == 'lighter' ?
        \ s:white.cterm :
        \ s:black.cterm,
      \ s:blue.cterm
    \ ], [
      \ s:fg.gui,
      \ s:line_numbers.gui,
      \ s:fg.cterm,
      \ s:selection.cterm
    \ ] ]
  let s:palette.terminal.right = s:palette.terminal.left

  let s:palette.inactive.left =  [ [
      \ s:fg.gui,
      \ s:selection.gui
    \ ], [
      \ s:fg.gui,
      \ s:selection.gui
    \ ] ]
  let s:palette.inactive.right = s:palette.inactive.left

  let s:palette.inactive.middle = [ [
      \ s:fg.gui,
      \ s:darker.gui
    \ ] ]

  let g:lightline#colorscheme#material_vim#palette = lightline#colorscheme#fill(s:palette)
endif
"}}}
" vim:foldmethod=marker:foldlevel=0
