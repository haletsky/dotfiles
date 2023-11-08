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
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'jparise/vim-graphql'
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim'
" Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'ANGkeith/telescope-terraform-doc.nvim'
Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'folke/trouble.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'lewis6991/gitsigns.nvim'
Plug 'hashivim/vim-terraform'
Plug 'plasticboy/vim-markdown'
" Plug 'TimUntersberger/neogit'
Plug 'sindrets/diffview.nvim'
" Plug 'github/copilot.vim'
" Plug 'zbirenbaum/copilot.lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
Plug 'hrsh7th/nvim-cmp'

" Plug 'hrsh7th/cmp-copilot'
" Plug 'zbirenbaum/copilot-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'onsails/lspkind.nvim'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
" Plug 'mbbill/undotree'
" Plug 'rcarriga/nvim-notify'
" Plug 'preservim/tagbar'
" Plug 'lukas-reineke/indent-blankline.nvim'
" Plug 'edluffy/hologram.nvim'
" Plug 'wakatime/vim-wakatime'
call plug#end()
" }}}


" LUA SCRIPTS {{{
lua << EOF

-- require'copilot'.setup{}
require'nvim-web-devicons'.setup{}
-- require("copilot_cmp").setup{}

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      --- completion = cmp.config.window.bordered(),
      --- documentation = cmp.config.window.bordered(),
    },
    view = {
      entries = "custom" -- can be "custom", "wildmenu" or "native"
    },
    preselect = cmp.PreselectMode.None,
    --- formatting = {
      --- format = require'lspkind'.cmp_format({ mode = 'text' }),
    --- },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      --- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          local entry = cmp.get_selected_entry()
          if not entry then
	          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
	        else
	          cmp.confirm()
	        end
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp', group_index = 0 },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'nvim_lsp_signature_help' },
      -- { name = 'nvim_lsp_document_symbol' },
      -- { name = 'copilot', group_index = 2 },
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

require('diffview').setup{}
--- require('neogit').setup{
  --- disable_hint = true,
  --- integrations = {
    --- diffview = true
  --- },
--- }

require('nvim-tree').setup({
  diagnostics = {
    enable = true,
  },
  view = {
    width = 40,
  },
  prefer_startup_root = true,
  hijack_unnamed_buffer_when_opening = true,
  actions = {
    use_system_clipboard = true,
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = false,
      }
    }
  },
  renderer = {
    icons = {
        show = {
          folder_arrow = false,
        }
    },
    indent_markers = {
      enable = true,
    },
  },
})
require('gitsigns').setup{}
require("bufferline").setup({
  options = {
    separator_style = "slant",
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
    }, {
      filetype = "gitcommit",
      text = "GIT commit",
      text_align = "center"
    }, {
      filetype = "vim-plug",
      text = "VIM Plug",
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
  if client.server_capabilities.document_highlight then
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
local servers = { 'clangd', 'jsonls', 'tsserver', 'gopls', 'bashls', 'terraformls', 'yamlls', 'jdtls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
          on_attach = on_attach,
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
  }
end

require('telescope').load_extension('terraform_doc')
require('telescope').load_extension('media_files')
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
  let &shell='/bin/zsh'
  let g:material_italic_comments = v:true
  let g:material_borders = v:true
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
set laststatus=3
set list listchars=tab:\ \ ,trail:⎵,precedes:<,extends:>
set mouse=a
set nobackup
set nocompatible
set noincsearch
set number
set noshowcmd
set noshowmode
set noswapfile
set nowrap
set makeprg=make
set nowritebackup
set sessionoptions-=blank
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
let g:scrollview_excluded_filetypes = ['NvimTree', 'gitcommit']
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
  \ 'name': 'menu',
  \ 'P': [':Git push', 'Git push'],
  \ 'd': [':Trouble', 'Diagnostics'],
  \ 'c': [':Telescope lsp_code_actions layout_strategy=vertical', 'Code Action'],
  \ 'j': [':%!python -m json.tool', 'Pretty json'],
  \ 'p': [':Git pull', 'Git pull'],
  \ 'i': [':Telescope lsp_implementations', 'Implementation'],
  \ 'f': [':exec "lua vim.lsp.buf.format()"', 'Format a file'],
  \ 'F': [':NvimTreeFindFile', 'Open current File in Tree'],
  \ 's': [':call CloseSidewins() | execute "Git" | wincmd H | vertical resize 40 | setlocal winhl=Normal:NvimTreeNormal noequalalways', 'Git status'],
  \ 'S': [':call CloseSidewins() | call OpenTODO()', 'Sketch Book'],
  \ 'r': [':exec "lua vim.lsp.buf.rename()"', 'Rename'],
  \ 't': [':terminal', 'Open a terimnal'],
  \ 'w': [':setlocal wrap linebreak', 'Wrap text in window']
  \ }
  "\ 'T': [':TagbarToggle', 'Tagbar toggle'],
  "\ 'u': [':UndotreeToggle | wincmd t', 'Undo tree'],
let g:which_key_map['m'] = { 'name': '+tasks-menu' }
let g:which_key_map['g'] = {
  \ 'name': '+git-menu',
  \ 'n': [']c', 'Jump to next hunk'],
  \ 'p': [':Gitsigns prev_hunk', 'Jump to previous hunk'],
  \ 'P': [':Gitsigns preview_hunk', 'Preview hunk'],
  \ 'b': [':Git blame', 'Blame'],
  \ 'f': [':Git fetch', 'Fetch'],
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
let g:nvim_tree_group_empty = 1
let g:nvim_tree_add_trailing = 1
let g:nvim_tree_width = 40
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
" let g:lightline.inactive = { 'left': [[], ['filename']], 'right': [] }
let g:lightline.component = {
  \ 'relativepath':   "%{WebDevIconsGetFileTypeSymbol() . ' ' . expand('%:.')}",
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
let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
" }}}


" HIGHLIGHTS {{{
highlight HighlightedyankRegion term=bold guifg=#000000 guibg=#e5c07b
highlight NonText guifg=bg
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END
" }}}


" AUTOCMDS {{{
autocmd VimEnter * silent cd %:p:h
" Remove traling spaces after save
autocmd BufWritePre * %s/\s\+$//e
" Use tabs vs spaces in Go files
autocmd FileType go setlocal shiftwidth=4 tabstop=4 noet
" Remove signcolunm from certain filetypes
autocmd FileType fugitive,gitcommit,help,vimwiki,vim-plug,markdown setlocal signcolumn=no nonumber wrap linebreak
autocmd TermOpen * setlocal signcolumn=no
" Move cursor to last edited line when open file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Which-key
autocmd VimEnter * silent call InitializeProjectTasks()
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0
  \| autocmd BufLeave <buffer> set laststatus=3
autocmd TermOpen * setlocal nonumber
" }}}


" HOTKEYS {{{
" inoremap <Tab> <C-R>=SmartTab()<CR>
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
map <C-f> <cmd>Telescope live_grep<CR>
map <C-p> <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--glob,!.git<CR>
map <C-g> <cmd>Telescope symbols<CR>
" Which-key menu
nnoremap m :WhichKey! g:which_key_map<CR>
" Move to word in file
map f <Plug>(easymotion-bd-W)
nnoremap <silent><nowait> <F1> <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent><nowait> <F2> <cmd>Telescope lsp_definitions<CR>
nnoremap <silent><nowait> <F3> <cmd>Telescope lsp_references<CR>
" nnoremap <silent><nowait> <F4> :Telescope lsp_code_actions<CR>
nnoremap <silent><nowait> <F4> <cmd>lua vim.lsp.buf.code_action()<CR>
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
map <C-LeftMouse> <Nop>
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <silent> <A-D> :call CloseBuffer()<CR>
" }}}


" COMMANDS {{{
command PrettyJSON %!python -m json.tool
" command Diff !kitty @ new-window --new-tab --cwd $(pwd) --no-response git difftool --no-symlinks --dir-diff
" }}}


" FUNCTIONS {{{
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
        \ &ft == 'help' ? '  ' :
        \ &ft == 'list' ? '   ' :
        \ &ft == 'undotree' ? '  ' :
        \ &ft == 'vimwiki' ? '  ' :
        \ &ft == 'vim-plug' ? '  ' : lightline#mode()
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

function! CloseBuffer()
  let l:bufnum = bufnr()
  execute 'bp'
  execute 'bd' . l:bufnum
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
let s:darker = { 'gui': '#1a1a1a', 'cterm': 232 }
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
