" PLUGINS {{{
call plug#begin('~/.vim/plugins')
" Appearance
Plug 'itchyny/lightline.vim'
Plug 'marko-cerovac/material.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
" Apps
Plug 'vimwiki/vimwiki'
" Functionality
Plug 'docunext/closetag.vim'
Plug 'easymotion/vim-easymotion'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'liuchengxu/vim-which-key'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'mbbill/undotree'
Plug 'wakatime/vim-wakatime'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'preservim/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" Neovim 0.5
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'glepnir/lspsaga.nvim'
Plug 'folke/trouble.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/nvim-bufferline.lua'
call plug#end()
" }}}


" LUA SCRIPTS {{{
lua << EOF

require("bufferline").setup({
  options = {
    offsets = {{
      filetype = "NvimTree",
      text = "File Explorer",
      text_align = "center"
    }}
  }
})

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
        autocmd CursorHold <buffer> lua require'lspsaga.diagnostic'.show_line_diagnostics()
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
  preselect = 'disable';
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
  let g:material_italic_comments = v:true
  let g:material_borders = v:true
  let g:material_contrast = v:true
  let g:material_style = 'darker'
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
set fillchars=eob:\ ,vert:\│
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
  \ 'D': [':LspTrouble', 'Diagnostics'],
  \ 'j': [':%!python -m json.tool', 'Pretty json'],
  \ 'l': [':Telescope git_commits', 'Git log'],
  \ 'p': [':Gpull', 'Git pull'],
  \ 'i': [':Lspsaga implement', 'Implementation'],
  \ 's': [':Git | wincmd L | vertical resize 60', 'Git status'],
  \ 'r': [":Lspsaga rename", 'Rename'],
  \ 't': [':tabe | terminal', 'Open a terimnal'],
  \ 'T': [':TagbarToggle', 'Tagbar toggle'],
  \ 'u': [':UndotreeToggle | wincmd t', 'Undo tree'],
  \ }
let g:which_key_map['m'] = { 'name': '+tasks-menu' }

" Vimwiki
let g:vimwiki_list = [{'path': '~/.vim/wiki'}]
" Devicons
let g:DevIconsEnableFoldersOpenClose = 1
" NERD Commenter
let g:NERDDefaultAlign = "left"
let g:NERDSpaceDelims = 1
" NvimTree
let g:nvim_tree_width = 40
let g:nvim_tree_lsp_diagnostics = 1
let g:nvim_tree_group_empty = 1
let g:nvim_tree_add_trailing = 1
let g:nvim_tree_auto_close = 1
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_disable_window_picker = 1
let g:nvim_tree_icons = { 'default': '' }
let g:nvim_tree_width_allow_resize = 1
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
let g:lightline.enable = { 'tabline': 0 }
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
highlight NonText guifg=bg
" }}}


" AUTOCMDS {{{
" Remove traling spaces after save
autocmd BufWritePre * %s/\s\+$//e
" Use tabs vs spaces in Go files
autocmd FileType go setlocal shiftwidth=4 tabstop=4 noet
" Remove signcolunm from certain filetypes
autocmd FileType fugitive,gitcommit,help,vimwiki setlocal signcolumn=no
autocmd TermOpen * setlocal signcolumn=no
" Move cursor to last edited line when open file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Which-key
autocmd VimEnter * silent call InitializeProjectTasks()
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0
  \| autocmd BufLeave <buffer> set laststatus=2
" }}}


" HOTKEYS {{{
inoremap <Tab> <C-R>=SmartTab()<CR>
" Map NvimTreeToggle on Control-b
map <C-b> :NvimTreeToggle<CR>
imap <C-b> <C-O>:NvimTreeToggle<CR>
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
nnoremap <silent><nowait> <F1> <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent><nowait> <F2> :Telescope lsp_definitions<CR>
nnoremap <silent><nowait> <F3> :Telescope lsp_references<CR>
" nnoremap <silent><nowait> <F4> :Telescope lsp_code_actions<CR>
nnoremap <silent><nowait> <F4> <cmd>lua require('lspsaga.codeaction').code_action()<CR>
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

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

function! LightlineGitBranch()
  return FugitiveStatusline()
endfunction

function! LightlineMode()
  return &ft == 'NvimTree' ? '  ' :
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


" MATERIAL LIGHTLINE THEME {{{
let g:colors_name = 'material'
let g:material_theme_style = 'darker'
let g:material_terminal_italics = get(g:, 'material_terminal_italics', 0)
let s:bg = { 'gui': '#263238', 'cterm': 'none' }
let s:fg = { 'gui': '#eeffff', 'cterm': 231 }
let s:invisibles = { 'gui': '#65738e', 'cterm': 66 }
let s:comments = { 'gui': '#546e7a', 'cterm': 145 }
let s:caret = { 'gui': '#ffcc00', 'cterm': 220 }
let s:selection = { 'gui': '#2c3b41', 'cterm': 239 }
let s:guides = { 'gui': '#37474f', 'cterm': 17 }
let s:line_numbers = { 'gui': '#37474f', 'cterm': 145 }
let s:line_highlight = { 'gui': '#1a2327', 'cterm': 235 }
let s:white = { 'gui': '#ffffff', 'cterm': 231 }
let s:black = { 'gui': '#000000', 'cterm': 232 }
let s:red = { 'gui': '#ff5370', 'cterm': 203 }
let s:orange = { 'gui': '#f78c6c', 'cterm': 209 }
let s:yellow = { 'gui': '#ffcb6b', 'cterm': 11 }
let s:green = { 'gui': '#c3e88d', 'cterm': 2 } " 186 –– almost perfect match
let s:cyan = { 'gui': '#89ddff', 'cterm': 117 }
let s:blue = { 'gui': '#82aaff', 'cterm': 111 }
let s:paleblue = { 'gui': '#b2ccd6', 'cterm': 152 }
let s:purple = { 'gui': '#c792ea', 'cterm': 176 }
let s:brown = { 'gui': '#c17e70', 'cterm': 137 }
let s:pink = { 'gui': '#f07178', 'cterm': 204 }
let s:violet = { 'gui': '#bb80b3', 'cterm': 139 }
if g:material_theme_style == 'palenight' || g:material_theme_style == 'palenight-community'
  let s:bg = { 'gui': '#292d3e', 'cterm': 'none' }
  let s:fg = { 'gui': '#a6accd', 'cterm': 146 }
  let s:invisibles = { 'gui': '#4e5579', 'cterm': 60 }
  let s:comments = { 'gui': '#676e95', 'cterm': 60 }
  let s:selection = { 'gui': '#343b51', 'cterm': 60 }
  let s:guides = { 'gui': '#4e5579', 'cterm': 60 }
  let s:line_numbers = { 'gui': '#3a3f58', 'cterm': 60 }
  let s:line_highlight = { 'gui': '#1c1f2b', 'cterm': 234 }
elseif g:material_theme_style == 'darker' || g:material_theme_style == 'darker-community'
  let s:bg = { 'gui': '#212121', 'cterm': 'none' }
  let s:fg = { 'gui': '#eeffff', 'cterm': 231 }
  let s:invisibles = { 'gui': '#65737e', 'cterm': 66 }
  let s:comments = { 'gui': '#545454', 'cterm': 59 }
  let s:selection = { 'gui': '#2c2c2c', 'cterm': 237 }
  let s:guides = { 'gui': '#424242', 'cterm': 0 }
  let s:line_numbers = { 'gui': '#424242', 'cterm': 0 }
  let s:line_highlight = { 'gui': '#171717', 'cterm': 0 }
elseif g:material_theme_style == 'ocean' || g:material_theme_style == 'ocean-community'
  let s:bg = { 'gui': '#0f111a', 'cterm': 'none' }
  let s:fg = { 'gui': '#8f93a2', 'cterm': 103 }
  let s:invisibles = { 'gui': '#80869e', 'cterm': 103 }
  let s:comments = { 'gui': '#464b5d', 'cterm': 60 }
  let s:selection = { 'gui': '#1f2233', 'cterm': 60 }
  let s:guides = { 'gui': '#3b3f51', 'cterm': 17 }
  let s:line_numbers = { 'gui': '#3b3f51', 'cterm': 60 }
  let s:line_highlight = { 'gui': '#0a0c12', 'cterm': 0 }
elseif g:material_theme_style == 'lighter' || g:material_theme_style == 'lighter-community'
  set background=light
  let s:bg = { 'gui': '#fafafa', 'cterm': 'none' }
  let s:fg = { 'gui': '#90a4ae', 'cterm': 109 }
  let s:invisibles = { 'gui': '#e7eaec', 'cterm': 189 }
  let s:comments = { 'gui': '#90a4ae', 'cterm': 109 }
  let s:caret = { 'gui': '#272727', 'cterm': 0 }
  let s:selection = { 'gui': '#ebf4f3', 'cterm': 254 }
  let s:guides = { 'gui': '#b0bec5', 'cterm': 146 }
  let s:line_numbers = { 'gui': '#cfd8dc', 'cterm': 188 }
  let s:line_highlight = { 'gui': '#ecf0f1', 'cterm': 253 }
  let s:white = { 'gui': '#ffffff', 'cterm': 231 }
  let s:black = { 'gui': '#000000', 'cterm': 0 }
  let s:red = { 'gui': '#e53935', 'cterm': 160 }
  let s:orange = { 'gui': '#f76d47', 'cterm': 202 }
  let s:yellow = { 'gui': '#ffb62c', 'cterm': 214 }
  let s:green = { 'gui': '#91b859', 'cterm': 107 }
  let s:cyan = { 'gui': '#39adb5', 'cterm': 37 }
  let s:blue = { 'gui': '#6182b8', 'cterm': 67 }
  let s:paleblue = { 'gui': '#8796b0', 'cterm': 103 }
  let s:purple = { 'gui': '#7c4dff', 'cterm': 99 }
  let s:brown = { 'gui': '#c17e70', 'cterm': 137 }
  let s:pink = { 'gui': '#ff5370', 'cterm': 203 }
  let s:violet = { 'gui': '#945eb8', 'cterm': 97 }
endif

" Defined globally so that the Airline theme has access
let g:material_colorscheme_map = {}
let g:material_colorscheme_map.bg = s:bg
let g:material_colorscheme_map.fg = s:fg
let g:material_colorscheme_map.invisibles = s:invisibles
let g:material_colorscheme_map.comments = s:comments
let g:material_colorscheme_map.caret = s:caret
let g:material_colorscheme_map.selection = s:selection
let g:material_colorscheme_map.guides = s:guides
let g:material_colorscheme_map.line_numbers = s:line_numbers
let g:material_colorscheme_map.line_highlight = s:line_highlight
let g:material_colorscheme_map.white = s:white
let g:material_colorscheme_map.black = s:black
let g:material_colorscheme_map.red = s:red
let g:material_colorscheme_map.orange = s:orange
let g:material_colorscheme_map.yellow = s:yellow
let g:material_colorscheme_map.green = s:green
let g:material_colorscheme_map.cyan = s:cyan
let g:material_colorscheme_map.blue = s:blue
let g:material_colorscheme_map.paleblue = s:paleblue
let g:material_colorscheme_map.purple = s:purple
let g:material_colorscheme_map.brown = s:brown
let g:material_colorscheme_map.pink = s:pink
let g:material_colorscheme_map.violet = s:violet
if (exists('g:lightline'))
  let s:lighter_middle_fg = g:material_theme_style == 'lighter' ?
    \ g:material_colorscheme_map.fg :
    \ g:material_colorscheme_map.invisibles

  let s:palette = { 'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {} }

  let s:palette.normal.left = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.cyan.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.cyan.cterm
    \ ], [
      \ g:material_colorscheme_map.fg.gui,
      \ g:material_colorscheme_map.line_numbers.gui,
      \ g:material_colorscheme_map.fg.cterm,
      \ g:material_colorscheme_map.selection.cterm
    \ ] ]

  let s:palette.normal.right = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.cyan.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.cyan.cterm
    \ ], [
      \ g:material_colorscheme_map.fg.gui,
      \ g:material_colorscheme_map.line_numbers.gui,
      \ g:material_colorscheme_map.fg.cterm,
      \ g:material_colorscheme_map.selection.cterm
    \ ] ]

  let s:palette.normal.middle = [ [
      \ s:lighter_middle_fg.gui,
      \ g:material_colorscheme_map.selection.gui,
      \ s:lighter_middle_fg.cterm,
      \ g:material_colorscheme_map.selection.cterm
    \ ] ]

  let s:palette.normal.error = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.red.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.red.cterm
    \ ] ]

  let s:palette.normal.warning = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.yellow.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.yellow.cterm,
    \ ] ]

  let s:palette.insert.left = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.purple.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.purple.cterm
    \ ], [
      \ g:material_colorscheme_map.fg.gui,
      \ g:material_colorscheme_map.line_numbers.gui,
      \ g:material_colorscheme_map.fg.cterm,
      \ g:material_colorscheme_map.selection.cterm
    \ ] ]

  let s:palette.insert.right = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.purple.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.purple.cterm
    \ ], [
      \ g:material_colorscheme_map.fg.gui,
      \ g:material_colorscheme_map.line_numbers.gui,
      \ g:material_colorscheme_map.fg.cterm,
      \ g:material_colorscheme_map.selection.cterm
    \ ] ]

  let s:palette.replace.left = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.green.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.green.cterm
    \ ], [
      \ g:material_colorscheme_map.fg.gui,
      \ g:material_colorscheme_map.line_numbers.gui,
      \ g:material_colorscheme_map.fg.cterm,
      \ g:material_colorscheme_map.selection.cterm
    \ ] ]

  let s:palette.replace.right = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.green.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.green.cterm
    \ ], [
      \ g:material_colorscheme_map.fg.gui,
      \ g:material_colorscheme_map.line_numbers.gui,
      \ g:material_colorscheme_map.fg.cterm,
      \ g:material_colorscheme_map.selection.cterm
    \ ] ]

  let s:palette.visual.left = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.blue.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.blue.cterm
    \ ], [
      \ g:material_colorscheme_map.fg.gui,
      \ g:material_colorscheme_map.line_numbers.gui,
      \ g:material_colorscheme_map.fg.cterm,
      \ g:material_colorscheme_map.selection.cterm
    \ ] ]

  let s:palette.visual.right = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.blue.gui,
      \ g:material_theme_style == 'lighter' ?
        \ g:material_colorscheme_map.white.cterm :
        \ g:material_colorscheme_map.black.cterm,
      \ g:material_colorscheme_map.blue.cterm
    \ ], [
      \ g:material_colorscheme_map.fg.gui,
      \ g:material_colorscheme_map.line_numbers.gui,
      \ g:material_colorscheme_map.fg.cterm,
      \ g:material_colorscheme_map.selection.cterm
    \ ] ]

  let s:palette.inactive.left =  [ [
      \ s:lighter_middle_fg.gui,
      \ g:material_colorscheme_map.selection.gui
    \ ], [
      \ s:lighter_middle_fg.gui,
      \ g:material_colorscheme_map.selection.gui
    \ ] ]

  let s:palette.inactive.right = [ [
      \ s:lighter_middle_fg.gui,
      \ g:material_colorscheme_map.selection.gui
    \ ], [
      \ s:lighter_middle_fg.gui,
      \ g:material_colorscheme_map.selection.gui
    \ ] ]

  let s:palette.inactive.middle = [ [
      \ s:lighter_middle_fg.gui,
      \ g:material_colorscheme_map.selection.gui
    \ ] ]

  let s:palette.tabline.left = [ [
      \ g:material_colorscheme_map.fg.gui,
      \ g:material_colorscheme_map.line_numbers.gui
    \ ] ]

  let s:palette.tabline.middle = [ [
      \ s:lighter_middle_fg.gui,
      \ g:material_colorscheme_map.selection.gui
    \ ] ]

  let s:palette.tabline.right = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.cyan.gui
    \ ] ]

  let s:palette.tabline.tabsel = [ [
      \ g:material_colorscheme_map.bg.gui,
      \ g:material_colorscheme_map.cyan.gui
    \ ] ]

  let g:lightline#colorscheme#material_vim#palette = lightline#colorscheme#fill(s:palette)
endif
"}}}

" vim:foldmethod=marker:foldlevel=0
