" ─────────────────────────────────────────────────────────────────────────────
" Vim-Plug (https://github.com/junegunn/vim-plug?tab=readme-ov-file#neovim)
"
" Unix:
" $ sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" Windows:
" $ iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
"   ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
"
"  https://github.com/junegunn/vim-plug#neovim
" ─────────────────────────────────────────────────────────────────────────────
call plug#begin()

Plug 'haletsky/rasmus.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate', 'branch': 'master' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" ─────────────────────────────────────────────────────────────────────────────
"  UI & basics
" ─────────────────────────────────────────────────────────────────────────────
if has('termguicolors') | set termguicolors | endif
syntax on
set background=dark
colorscheme rasmus

set number
set signcolumn=yes
set nocursorline
set fillchars=eob:\ ,
set laststatus=3
set cmdheight=1

set mouse=a
set clipboard+=unnamedplus

set ignorecase
set smartcase                          " case-sensitive if pattern has capitals
set incsearch
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.pyc,.git,.hg,.svn,*.jpeg,*.jpg,*.png,*.svg,node_modules,.next,build
set completeopt=menuone,noselect,noinsert
set shortmess+=Ic                       " no intro, quieter completion
set updatetime=300
set scrolloff=3 sidescrolloff=3
set splitbelow splitright

" Files, backups, undo
set hidden
set noswapfile nobackup nowritebackup
silent! call mkdir(has('nvim') ? stdpath('state').'/undo' : expand('~/.vim/undo'), 'p')
let &undodir = has('nvim') ? stdpath('state').'/undo' : expand('~/.vim/undo')
set undofile

" Indentation & wrapping
set smarttab shiftwidth=4 tabstop=4 expandtab
set nowrap
set conceallevel=2

" Folding with Tree-sitter (open by default)
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99
set foldnestmax=10
set nofoldenable

" Sessions
set sessionoptions-=blank

" Performance / keycode timing
set ttimeout
set ttimeoutlen=10

filetype plugin indent on

" ─────────────────────────────────────────────────────────────────────────────
"  Shells (POSIX first; Windows handled below)
" ─────────────────────────────────────────────────────────────────────────────
if executable('zsh')
  let &shell = exepath('zsh')
elseif executable('bash')
  let &shell = exepath('bash')
else
  let &shell = exepath('sh')
endif

" PowerShell on Windows (prefer pwsh)
if has('win32') || has('win64')
  if executable('pwsh')
    set shell=pwsh
  else
    set shell=powershell
  endif
  set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
  set shellquote=\"
  set shellxquote=
  set shellredir=>\ %s\ 2>&1
  set shellpipe=>\ %s\ 2>&1
  set encoding=utf-8
endif

" ─────────────────────────────────────────────────────────────────────────────
"  Providers off
" ─────────────────────────────────────────────────────────────────────────────
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0

" ─────────────────────────────────────────────────────────────────────────────
"  Netrw (built-in)
" ─────────────────────────────────────────────────────────────────────────────
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_winsize=25
let g:netrw_keepdir = 1

" ─────────────────────────────────────────────────────────────────────────────
"  Grep (prefer ripgrep) + proper quickfix formatting
" ─────────────────────────────────────────────────────────────────────────────
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --glob\ '!.git'
else
  if has('win32') || has('win64')
    set grepprg=findstr\ /n\ /s\ /p
  else
    set grepprg=grep\ -R\ -n\ --exclude-dir=.git\ --exclude-dir=node_modules\ --binary-files=without-match\ --line-number\ --color=never
  endif
endif
set grepformat=%f:%l:%c:%m
set path+=**

" ─────────────────────────────────────────────────────────────────────────────
"  Autocmds
" ─────────────────────────────────────────────────────────────────────────────
augroup YankHL
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup='IncSearch', timeout=300}
augroup END

augroup CursorLineToggle
  autocmd!
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" On Vim startup, cd to the directory of the opened file
augroup AutoChdir
  autocmd!
  autocmd VimEnter * silent! cd %:p:h
augroup END

" Strip trailing whitespace (skip Markdown to keep hard wraps)
augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre * if &ft !=# 'markdown' | %s/\s\+$//e | endif
augroup END

" Per-filetype indent
augroup FiletypeIndent
  autocmd!
  autocmd FileType go,lua setlocal shiftwidth=4 tabstop=4 noexpandtab
  autocmd FileType javascript,typescript,vim setlocal shiftwidth=2 tabstop=2 expandtab
augroup END

" Tidy display
augroup FiletypeDisplay
  autocmd!
  autocmd FileType help setlocal signcolumn=no nonumber wrap linebreak
  autocmd TermOpen * setlocal signcolumn=no nonumber
augroup END

" Restore last cursor position (column-accurate)
augroup LastCursor
  autocmd!
  autocmd BufReadPost * if line("'\"")>1 && line("'\"")<=line("$") | execute "normal! g`\"" | endif
augroup END

" Quickfix: close after jumping
augroup QfEnterClose
  autocmd!
  autocmd FileType qf nnoremap <silent><buffer> <CR> <CR>:cclose<CR>
  autocmd FileType qf nnoremap <silent><buffer> q :cclose<CR>
augroup END

" ─────────────────────────────────────────────────────────────────────────────
"  Commands
" ─────────────────────────────────────────────────────────────────────────────
command! PrettyJSON %!python -m json.tool

" ─────────────────────────────────────────────────────────────────────────────
"  Tiny helpers (no external deps)
" ─────────────────────────────────────────────────────────────────────────────

" Toggle netrw like a tree
function! s:ToggleNetrw() abort
  for w in range(1, winnr('$'))
    if getbufvar(winbufnr(w), '&filetype') ==# 'netrw'
      execute w . 'wincmd c'
      return
    endif
  endfor
  Lexplore | vert resize 45
endfunction

" Close current buffer but preserve layout
function! CloseBuffer() abort
  let l:list = getbufinfo({'buflisted':1})
  if len(l:list) > 1
    bprevious | execute 'bdelete ' . bufnr('%')
  else
    enew | bdelete #
  endif
endfunction

" Simple comment toggler (uses 'commentstring')
function! s:ToggleCommentRange(line1, line2) range abort
  let l:cs = &l:commentstring
  if empty(l:cs) | let l:cs = '# %s' | endif
  let l:pref = substitute(l:cs, '%s', '', '')
  let l:pref = substitute(l:pref, '\s\+$', '', '')
  let l:rx = '^\s*' . escape(l:pref, '#*/\^$.~[](){}+?|-')
  let l:is_commented = 1
  for lnum in range(a:line1, a:line2)
    if getline(lnum) !~ l:rx | let l:is_commented = 0 | break | endif
  endfor
  for lnum in range(a:line1, a:line2)
    let l:ln = getline(lnum)
    call setline(lnum, l:is_commented ? substitute(l:ln, l:rx . '\s\?', '', '') : (l:pref . ' ' . l:ln))
  endfor
endfunction

" Poor-man's "LSP"
function! s:GotoDef() abort
  try
    execute 'tag ' . expand('<cword>')
  catch
    execute 'vimgrep /\<' . expand('<cword>') . '\>/gj **/*'
    copen
  endtry
endfunction
function! s:FindRefs() abort
  execute 'vimgrep /\<' . expand('<cword>') . '\>/gj **/*'
  copen
endfunction

" ─────────────────────────────────────────────────────────────────────────────
"  Keymaps
" ─────────────────────────────────────────────────────────────────────────────
" Optional leader: uncomment to adopt <Space> as <Leader> (conflicts with the
" Space → ":" mapping below, so pick one style and stick with it).
" let mapleader = ' '

" Netrw toggle (like NvimTree) on <C-b>
nnoremap <silent> <C-b> :call <SID>ToggleNetrw()<CR>
inoremap <silent> <C-b> <C-o>:call <SID>ToggleNetrw()<CR><Esc>

" Buffers/Tabs
nnoremap <silent> <M-l> :bnext<CR>
nnoremap <silent> <M-h> :bprevious<CR>
nnoremap <silent> <A-l> :bnext<CR>
nnoremap <silent> <A-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <Esc>l :bnext<CR>
nnoremap <silent> <Esc>h :bprevious<CR>
nnoremap <silent> ( :tabprevious<CR>
nnoremap <silent> ) :tabnext<CR>
nnoremap <silent> <A-d> :call CloseBuffer()<CR>
nnoremap <silent> <A-D> :call CloseBuffer()<CR>

" Mode switching
inoremap <silent> jj <Esc>
inoremap <silent> <C-j> <C-\><C-n>
vnoremap <silent> <C-j> <C-\><C-n>
tnoremap <silent> <C-j> <C-\><C-n>

" Command-line on Space (comment this if you enable <Leader>=Space)
nnoremap <Space> :

" Finders (fzf): <C-p> prefers Git files; falls back to Files; <C-f> to Rg or :grep
nnoremap <silent><expr> <C-p> isdirectory('.git') ? ":GFiles<CR>" : ":Files<CR>"
nnoremap <silent> <C-f> :silent! RG<CR>

" DIY “LSP”
nnoremap <silent> <F1> :help <C-r><C-w><CR>
nnoremap <silent> <F2> :call <SID>GotoDef()<CR>
nnoremap <silent> <F3> :call <SID>FindRefs()<CR>
nnoremap <silent> <F4> :echo 'Apply code action (manual)'<CR>
nnoremap <silent> gi    :call <SID>FindRefs()<CR>
nnoremap <silent> gd    :call <SID>GotoDef()<CR>
nnoremap <silent> gr    :call <SID>FindRefs()<CR>
nnoremap <silent> gw    :vimgrep /\<\k\+\>/gj **/* \| copen<CR>

" Wrapped-line movement
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> gl $
nnoremap <silent> gh 0

" Terminal
nnoremap <silent> <C-T> :terminal<CR>

" Resize height with = (smaller) and - (larger)
nnoremap <silent> = :resize -4<CR>
nnoremap <silent> - :resize +4<CR>

" Resize width with + (narrower) and _ (wider)
nnoremap <silent> + :vertical resize -5<CR>
nnoremap <silent> _ :vertical resize +5<CR>

" Move lines up/down
nnoremap <silent> <A-j> :m .+1<CR>==
nnoremap <silent> <A-k> :m .-2<CR>==
inoremap <silent> <A-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <A-k> <Esc>:m .-2<CR>==gi
vnoremap <silent> <A-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-k> :m '<-2<CR>gv=gv

" Comment toggles (avoid <C-c> conflicts in some terminals)
nnoremap <silent> <C-c> :<C-u>call <SID>ToggleCommentRange(line('.'), line('.'))<CR>
xnoremap <silent> <C-c> :<C-u>call <SID>ToggleCommentRange(line("'<"), line("'>"))<CR>

" Misc
nnoremap <silent> <C-LeftMouse> <Nop>
nnoremap <C-Space> za
xnoremap <silent> * y/\V<C-R>=escape(@",'/\')<CR><CR>

" ─────────────────────────────────────────────────────────────────────────────
"  Tree-sitter
" ─────────────────────────────────────────────────────────────────────────────
lua << EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua","vim","vimdoc","bash","python","javascript","typescript","go","json","html","css","yaml" },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
}
EOF
