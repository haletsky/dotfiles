" PLUGINS: {{{
call plug#begin('~/.vim/plugins')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'neovim/nvim-lspconfig'
Plug 'kvrohit/rasmus.nvim'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'docunext/closetag.vim'
Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }
Plug 'easymotion/vim-easymotion'
Plug 'folke/trouble.nvim'
Plug 'hashivim/vim-terraform'
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
Plug 'jparise/vim-graphql'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'leafgarland/typescript-vim'
Plug 'lewis6991/gitsigns.nvim'
" Plug 'liuchengxu/vim-which-key'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'onsails/lspkind.nvim'
Plug 'plasticboy/vim-markdown'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'
Plug 'MunifTanjim/nui.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'yetone/avante.nvim'
Plug 'folke/which-key.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'nvchad/volt'
Plug 'nvchad/menu'

" Optional:
" Plug 'github/copilot.vim'
" Plug 'zbirenbaum/copilot.lua'
" Plug 'hrsh7th/cmp-copilot'
" Plug 'zbirenbaum/copilot-cmp'
call plug#end()
" }}}


" BASE SETTINGS: {{{
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

syntax on
try
  colorscheme rasmus
catch
endtry
set autoread
set background=dark
set clipboard+=unnamedplus
set completeopt=menuone,noselect
set conceallevel=2
set cursorline
set encoding=utf8
set fillchars=eob:\ ,vert:\│
set foldenable
set foldlevelstart=10
set foldmethod=syntax
set foldnestmax=10
set hidden
set ignorecase
set langmenu=en
set laststatus=3
set list listchars=tab:\ \ ,trail:⎵,precedes:<,extends:>
set makeprg=make
set mouse=a
set nobackup
set nocompatible
set noshowcmd
set noshowmode
set noswapfile
set nowrap
set nowritebackup
set number
set sessionoptions-=blank
set shortmess+=F
set shortmess+=c
set signcolumn=yes
set smarttab shiftwidth=4 tabstop=4 expandtab
set undodir=~/.vim/undo
set undofile
set updatetime=500
set wildignore=*.pyc,.git,.hg,.svn,*.jpeg,*.jpg,*.png,*.svg,node_modules,.next,build
set wildmenu
silent set is hl
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
let &shell='/bin/zsh'
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
" }}}


" LOAD LUA CONFIG: {{{
lua << EOF
require'telescope'.setup{
  pickers = {
    find_files = {
      mappings = {
        i = {
          ["<C-j>"] = { "<esc>", type = "command" },
        },
      },
    },
  },
}
require'telescope'.load_extension'media_files'
require'gitsigns'.setup{
  numhl      = true,
  current_line_blame = true,
}
require'trouble'.setup{
  use_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client
}
require'custom-lsp'
require'custom-bufferline'
require'custom-nvim-tree'
require'copyright-license'.setup{
  path =  "/Users/bkhaletskyi/adi/developer-hub",
  copyright_string = [[
/**
 * Copyright (c) 2025 Analog Devices, Inc. All Rights Reserved.
 * This software is proprietary and confidential to Analog Devices, Inc. and its licensors.
 */]],
}

require'render-markdown'.setup{
    heading = {
        enabled = true,
        width = 'block',
    },
    code = {
        style = 'normal'
    },
}
local wk = require'which-key'
wk.setup{
    triggers = {
        { "<auto>", mode = "nixsotc" },
        { "m", mode = { "n", "v" } },
    }
}
wk.add{
    { "mg", group = 'git' },
    { 'mgn', "<cmd>exec 'lua require(\"gitsigns\").next_hunk({ preview = true })'<cr>", desc = 'Jump to next hunk' },
    { 'mgp', "<cmd>Gitsigns prev_hunk<cr>",                                 desc = 'Jump to previous hunk' },
    { 'mgP', "<cmd>Gitsigns preview_hunk<cr>",                              desc = 'Preview hunk' },
    { 'mgB', "<cmd>Git blame<cr>",                                          desc = 'Blame' },
    { 'mgf', "<cmd>Git fetch<cr>",                                          desc = 'Fetch' },
    { 'mgd', "<cmd>Gdiff<cr>",                                              desc = 'Diff' },
    { 'mgl', "<cmd>Telescope git_commits<cr>",                              desc = 'Log' },
    { 'mgb', "<cmd>Telescope git_branches<cr>",                             desc = 'Branches' },
    { 'mgL', "<cmd>Telescope git_bcommits<cr>",                             desc = 'Log of the file' },

    { "mp", "<cmd>Git pull<cr>",                                            desc = "Git Pull" },
    { "mP", "<cmd>Git push<cr>",                                            desc = "Git Push" },
    { "md", "<cmd>Trouble diagnostics toggle<cr>",                          desc = "Diagnostics" },
    { "mj", "<cmd>%!python3.12 -m json.tool<cr>",                           desc = "Pretty JSON" },
    { "mi", "<cmd>Telescope lsp_implementations<cr>",                       desc = "Implementation" },
    { "mf", '<cmd>exec "lua vim.lsp.buf.format()"<cr>',                     desc = 'Format the file' },
    { "mF", "<cmd>NvimTreeFindFile<cr>",                                    desc = "Open the current file in Tree" },
    { "ms", "<cmd>call CloseSidewins() | execute 'Git' | wincmd H | vertical resize 40 | setlocal winhl=Normal:NvimTreeNormal noequalalways<cr>", desc = 'Git status' },
    { 'mS', '<cmd>call CloseSidewins() | call OpenTODO()<cr>',              desc = 'Sketch Book' },
    { 'mr', '<cmd>exec "lua vim.lsp.buf.rename()"<cr>',                     desc = 'Rename' },
    { 'mt', '<cmd>!yarn prettier:fix<cr>',                                  desc = 'Prettier Fix' },
    { 'mw', '<cmd>setlocal wrap linebreak<cr>',                             desc = 'Wrap text in window' },
}
require'dressing'.setup{}
--- require("menu").open(options, opts)
--require'avante'.setup{
--  ---@alias Provider "openai" | "claude" | "azure"  | "copilot" | "cohere" | [string]
--  windows = {
--    wrap = true, -- similar to vim.o.wrap
--    width = 30, -- default % based on available width
--    sidebar_header = {
--      align = "right", -- left, center, right for title
--      rounded = false,
--    },
--  },
--}
EOF
" }}}


" PLUGIN CONFIGURATION: {{{
let g:scrollview_excluded_filetypes = ['NvimTree', 'gitcommit', 'vimwiki', 'fugitive']
let g:scrollview_always_show = 1
" VimWiki:
let g:vimwiki_ext2syntax = {}
let g:vimwiki_list = [{'path': '~/.vim/wiki'}]
" WhichKey:
" let g:which_key_use_floating_win = 0
" let g:which_key_sort_horizontal = 0
" let g:which_key_map = {
"   \ 'name': 'menu',
"   \ 'P': [':Git push', 'Git push'],
"   \ 'd': [':Trouble', 'Diagnostics'],
"   \ 'c': [':lua vim.lsp.buf.code_action()', 'Code Action'],
"   \ 'j': [':%!python3.12 -m json.tool', 'Pretty json'],
"   \ 'p': [':Git pull', 'Git pull'],
"   \ 'i': [':Telescope lsp_implementations', 'Implementation'],
"   \ 'f': [':exec "lua vim.lsp.buf.format()"', 'Format a file'],
"   \ 'F': [':NvimTreeFindFile', 'Open current File in Tree'],
"   \ 's': [':call CloseSidewins() | execute "Git" | wincmd H | vertical resize 40 | setlocal winhl=Normal:NvimTreeNormal noequalalways', 'Git status'],
"   \ 'S': [':call CloseSidewins() | call OpenTODO()', 'Sketch Book'],
"   \ 'r': [':exec "lua vim.lsp.buf.rename()"', 'Rename'],
"   \ 't': [':!yarn prettier:fix', 'Run prettier:fix'],
"   \ 'w': [':setlocal wrap linebreak', 'Wrap text in window']
"   \ }
" " let g:which_key_map['m'] = { 'name': '+tasks-menu' }
" let g:which_key_map['g'] = {
"   \ 'name': '+git-menu',
"   \ 'n': [':exec "lua require(\"gitsigns\").next_hunk({ preview = true })"', 'Jump to next hunk'],
"   \ 'p': [':Gitsigns prev_hunk', 'Jump to previous hunk'],
"   \ 'P': [':Gitsigns preview_hunk', 'Preview hunk'],
"   \ 'B': [':Git blame', 'Blame'],
"   \ 'f': [':Git fetch', 'Fetch'],
"   \ 'd': [':Gdiff', 'Diff'],
"   \ 'l': [':Telescope git_commits', 'Log'],
"   \ 'b': [':Telescope git_branches', 'Branches'],
"   \ 'L': [':Telescope git_bcommits', 'Log of the file']
"   \ }
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
let g:python_host_prog  = '/opt/homebrew/bin/python3'
let g:python3_host_prog = '/opt/homebrew/bin/python3'
" }}}


" HIGHLIGHTS: {{{
highlight MsgArea guibg=#1a1a19
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=300 }
augroup END
highlight NonText guifg=bg
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END
" }}}


" AUTOCMDS: {{{
autocmd VimEnter * silent cd %:p:h
" Remove traling spaces after save
autocmd BufWritePre * %s/\s\+$//e
" Use tabs or spaces for different filetypes
autocmd FileType go setlocal shiftwidth=4 tabstop=4 noet
autocmd FileType javascript,typescript setlocal shiftwidth=2 tabstop=2 et
" Remove signcolunm from certain filetypes
" autocmd FileType fugitive,gitcommit,help,vimwiki,vim-plug,markdown setlocal signcolumn=no nonumber wrap linebreak
autocmd FileType fugitive,gitcommit,help,vimwiki,vim-plug setlocal signcolumn=no nonumber wrap linebreak
autocmd TermOpen * setlocal signcolumn=no
" Move cursor to last edited line when open file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Which-key
" autocmd VimEnter * silent call InitializeProjectTasks()
" autocmd! FileType which_key
" autocmd  FileType which_key set laststatus=3
"   \| autocmd BufLeave <buffer> set laststatus=3
autocmd TermOpen * setlocal nonumber
" }}}


" HOTKEYS: {{{
" inoremap <Tab> <C-R>=SmartTab()<CR>
" Map NvimTreeToggle on Control-b
map <silent> <C-b> :call CloseSidewinsButNoNvimTree()<CR>
imap <silent> <C-b> <C-O> :call CloseSidewinsButNoNvimTree()<CR>
" Tab movement
noremap <A-l> :BufferLineCycleNext<CR>
noremap <A-h> :BufferLineCyclePrev<CR>
nnoremap ( :tabp<CR>
nnoremap ) :tabn<CR>
" Siwtch to NORMAL mode with jj or C-j
imap jj <Esc>
imap <C-j> <C-\><C-n>
vmap <C-j> <C-\><C-n>
tnoremap <C-j> <C-\><C-n>
" COMMAND mode by space
nmap <Space> :
" Comment code
map <C-c> <Plug>NERDCommenterToggle
" Finders
map <C-f> <cmd>Telescope live_grep<CR>
map <C-p> <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--glob,!.git<CR>
map <C-g> <cmd>Telescope symbols<CR>
" Which-key menu
" nnoremap <silent><nowait> m <cmd>WhichKey! g:which_key_map<CR>
" Move to word in file
map f <Plug>(easymotion-bd-W)
nnoremap <silent><nowait> <F1> <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent><nowait> <F2> <cmd>Telescope lsp_definitions<CR>
nnoremap <silent><nowait> <F3> <cmd>Telescope lsp_references<CR>
" nnoremap <silent><nowait> <F4> :Telescope lsp_code_actions<CR>
nnoremap <silent><nowait> <F4> <cmd>lua vim.lsp.buf.code_action()<CR>
map j gj
map k gk
map gl $
map gh 0
map gi <cmd>Telescope lsp_implementations<CR>
map gd <cmd>Telescope lsp_definitions<CR>
map gr <cmd>Telescope lsp_references<CR>
map gw <cmd>Telescope lsp_dynamic_workspace_symbols<CR>
nnoremap gn <cmd>Gitsigns next_hunk preview=true<CR>
nnoremap gp <cmd>Gitsigns prev_hunk preview=true<CR>
nnoremap gx <cmd>Gitsigns reset_hunk<CR>
nnoremap gs <cmd>Gitsigns stage_hunk<CR>
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
map <C-LeftMouse> <Nop>
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <silent> <A-D> :call CloseBuffer()<CR>

" nnoremap mt <cmd>Git push<CR>
" nnoremap mP <cmd>Git push<CR>
" nnoremap mp <cmd>Git pull<CR>
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

" Mouse support
set mouse=a
" set ttymouse=sgr
" set balloonevalterm
" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
" execute "set <FocusGained>=\<Esc>[I"
" execute "set <FocusLost>=\<Esc>[O"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''
" vim:foldmethod=marker:foldlevel=0
