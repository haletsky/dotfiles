" PLUGINS {{{
call plug#begin('~/.vim/plugins')
Plug 'itchyny/lightline.vim'
Plug 'marko-cerovac/material.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'leafgarland/typescript-vim'
Plug 'vimwiki/vimwiki'
Plug 'docunext/closetag.vim'
Plug 'easymotion/vim-easymotion'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'liuchengxu/vim-which-key'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'mbbill/undotree'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'preservim/tagbar'
Plug 'jparise/vim-graphql'
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'glepnir/lspsaga.nvim'
Plug 'folke/trouble.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'lewis6991/gitsigns.nvim'
" Plug 'wakatime/vim-wakatime'
call plug#end()
" }}}


" LUA SCRIPTS {{{
lua << EOF

require('gitsigns').setup{}
require("bufferline").setup({
  options = {
    sort_by = function (bufa, bufb)
      return bufa.extension < bufb.extension
    end,
    diagnostics = "nvim_lsp",
    offsets = {{
      filetype = "NvimTree",
      text = "File Explorer",
      text_align = "center"
    }, {
      filetype = "fugitive",
      text = "GIT",
      text_align = "center"
    }, {
      filetype = "vimwiki",
      text = "Sketch Book",
      text_align = "center"
    }, {
      filetype = "fugitiveblame",
      text = "Git blame",
      text_align = "center"
    }},
    custom_filter = function(buf, buf_nums)
      if vim.bo[buf].filetype == 'vimwiki' then return false end
      if vim.bo[buf].filetype == 'fugitive' then return false end

      local length = vim.fn.tabpagenr('$')
      local currenttab = vim.fn.tabpagenr()

      for i=1, length, 1 do
        if i ~= currenttab then
          for k,v in pairs(vim.fn.tabpagebuflist(i)) do
            if v == buf then
              return false
            end
          end
        end
      end

      return true
    end
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
local servers = { "jsonls", "rls", "tsserver", "clangd", 'gopls', 'graphql', 'bashls', 'terraformls' }
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
  " let g:material_borders = v:true
  " let g:material_contrast = v:true
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
" Vimwiki
let g:vimwiki_ext2syntax = {}
" AsyncTask
let g:asyncrun_open = 6
let g:asyncrun_rootmarks = ['.git']
let g:asynctasks_term_pos = 'right'
" Which-key
let g:which_key_use_floating_win = 0
let g:which_key_sort_horizontal = 0
let g:which_key_map = {
  \ 'P': [':Git push', 'Git push'],
  \ 'd': [':LspTrouble', 'Diagnostics'],
  \ 'j': [':%!python -m json.tool', 'Pretty json'],
  \ 'p': [':Gpull', 'Git pull'],
  \ 'i': [':Telescope lsp_implementations', 'Implementation'],
  \ 's': [':call CloseSidewins() | execute "Git" | wincmd H | vertical resize 40 | setlocal winhl=Normal:NvimTreeNormal', 'Git status'],
  \ 'r': [":Lspsaga rename", 'Rename'],
  \ 't': [':terminal', 'Open a terimnal'],
  \ 'T': [':TagbarToggle', 'Tagbar toggle'],
  \ 'u': [':UndotreeToggle | wincmd t', 'Undo tree']
  \ }
let g:which_key_map['m'] = { 'name': '+tasks-menu' }
let g:which_key_map['g'] = {
  \ 'name': '+git-menu',
  \ 'n': [']c', 'Jump to next hunk'],
  \ 'p': [':Gitsigns prev_hunk', 'Jump to previous hunk'],
  \ 'P': [':Gitsigns preview_hunk', 'Preview hunk'],
  \ 'b': [':Gblame', 'Blame'],
  \ 'd': [':Gdiff', 'Diff'],
  \ 'l': [':Telescope git_commits', 'Log'],
  \ 'B': [':Telescope git_branches', 'Branches'],
  \ 'L': [':Telescope git_bcommits', 'Log of the file']
  \ }
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
  \  'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'modified', 'readonly' ], ['relativepath'] ],
  \  'right': [ [ 'percent', 'lineinfo' ], ['gitsign_status'] , [ 'buffersize' ] ]
  \ }
let g:lightline.inactive = { 'left': [[], ['filename']], 'right': [] }
let g:lightline.component = {
  \ 'relativepath':   "%{winwidth(0) > 70 ? WebDevIconsGetFileTypeSymbol() . ' ' . expand('%') : expand('%:t')}",
  \ 'gitbranch':      "%{winwidth(0) > 70 ? FugitiveHead() != '' ? ' ' . ' ' . FugitiveHead() : '' : ''}",
  \ 'readonly':       "%{&readonly ? '' : ''}",
  \ 'gitsign_status': "%{winwidth(0) > 70 ? get(b:,'gitsigns_status','') : ''}",
  \ 'lineinfo': '%{winwidth(0)>70?line(".").":".col("."):""}'
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
autocmd VimEnter * silent cd %:p:h
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
map <silent> <C-b> :call CloseSidewinsButNoNvimTree()<CR>
imap <silent> <C-b> <C-O> :call CloseSidewinsButNoNvimTree()<CR>
" Tab movement
noremap <A-l> :BufferLineCycleNext<CR>
noremap <A-h> :BufferLineCyclePrev<CR>
nnoremap ( :tabp<CR>
nnoremap ) :tabn<CR>
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
map <silent> ` :call OpenTODO()<CR>
" }}}


" COMMANDS {{{
command PrettyJSON %!python -m json.tool
" command Diff !kitty @ new-window --new-tab --cwd $(pwd) --no-response git difftool --no-symlinks --dir-diff
" }}}


" FUNCTIONS {{{
function! CloseSidewins()
  silent! bd */.git/index
  silent! bd */index.wiki
  silent! bd *.wiki
  lua require 'nvim-tree'.close()
endfunction

function! CloseSidewinsButNoNvimTree()
  silent! bd */.git/index
  silent! bd */index.wiki
  silent! bd *.wiki
  lua require 'nvim-tree'.toggle()
endfunction

function! SmartTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
   endif
endfunction

function! FileSize() abort
    if (winwidth(0) < 70)
      return ''
    endif

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
        \ &ft == 'help' ? '  ' :
        \ &ft == 'list' ? '   ' :
        \ &ft == 'undotree' ? '  ' :
        \ &ft == 'vimwiki' ? '  ' :
        \ &ft == 'vim-plug' ? '  ' :
        \ winwidth(0) > 70 ? lightline#mode() : ''
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
let s:bg = { 'gui': '#212121', 'cterm': 'none' }
let s:fg = { 'gui': '#B0BEC5', 'cterm': 231 }
let s:invisibles = { 'gui': '#65738e', 'cterm': 66 }
let s:comments = { 'gui': '#616161', 'cterm': 145 }
let s:caret = { 'gui': '#ffcc00', 'cterm': 220 }
let s:selection = { 'gui': '#404040', 'cterm': 239 }
let s:guides = { 'gui': '#37474f', 'cterm': 17 }
let s:line_numbers = { 'gui': '#424242', 'cterm': 145 }
let s:line_highlight = { 'gui': '#1a2327', 'cterm': 235 }
let s:white = { 'gui': '#EEFFFF', 'cterm': 231 }
let s:black = { 'gui': '#000000', 'cterm': 232 }
let s:red = { 'gui': '#F07178', 'cterm': 203 }
let s:orange = { 'gui': '#F78C6C', 'cterm': 209 }
let s:yellow = { 'gui': '#FFCB6B', 'cterm': 11 }
let s:green = { 'gui': '#C3E88D', 'cterm': 2 } " 186 –– almost perfect match
let s:cyan = { 'gui': '#89DDFF', 'cterm': 117 }
let s:blue = { 'gui': '#82AAFF', 'cterm': 111 }
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
      \ s:bg.gui,
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
      \ s:bg.gui
    \ ] ]

  let g:lightline#colorscheme#material_vim#palette = lightline#colorscheme#fill(s:palette)
endif
"}}}

" vim:foldmethod=marker:foldlevel=0
