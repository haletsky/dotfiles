"
" Install Vim-Plug (https://github.com/junegunn/vim-plug?tab=readme-ov-file#neovim)
"
" Unix:
" $ sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" Windows:
" $ iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
"   ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
"
call plug#begin()

Plug 'haletsky/rasmus.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate', 'branch': 'master' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()


" Truecolor + syntax
if has('termguicolors') | set termguicolors | endif
syntax on
set background=dark
colorscheme rasmus

" Basics
set ttimeout
set ttimeoutlen=10
set clipboard+=unnamedplus
set mouse=a
set number
set nocursorline
set signcolumn=yes
set fillchars=eob:\ ,
set ignorecase
set wildmenu
set wildignore+=*.pyc,.git,.hg,.svn,*.jpeg,*.jpg,*.png,*.svg,node_modules,.next,build
set completeopt=menuone,noselect
set shortmess+=Fc
set foldenable foldnestmax=10 foldlevelstart=10
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set hidden
set undodir=~/.vim/undo | set undofile
set updatetime=500
set autoread
set smarttab shiftwidth=4 tabstop=4 expandtab
set nowrap
set conceallevel=2
set laststatus=2
set sessionoptions-=blank
set noswapfile nobackup nowritebackup
filetype plugin indent on

" Use zsh if present
if executable('zsh')
  set shell=/bin/zsh
else
  set shell=/bin/sh
endif

" ── Use PowerShell on Windows (prefers pwsh, falls back to powershell) ──────
if has('win32') || has('win64')
  if executable('pwsh')
    set shell=pwsh
  else
    set shell=powershell
  endif
  " Non-interactive, predictable, and UTF-8 friendly
  set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
  " Quoting rules so :! and :make work reliably
  set shellquote=\"
  set shellxquote=
  " Capture stderr with stdout for :read !, :make, etc.
  set shellredir=>\ %s\ 2>&1
  " Pipe output to a file when Vim needs it (e.g. :makeprg)
  set shellpipe=>\ %s\ 2>&1
  " Use UTF-8 to avoid mojibake
  set encoding=utf-8
  let $PSModulePath=$PSModulePath  " (forces env refresh in some setups)
endif

" Providers off
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0

" Netrw (built-in)
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_winsize=25

" Grep: prefer ripgrep if available (fallbacks are shell-friendly on Windows too)
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --glob\ '!.git'
elseif has('win32') || has('win64')
  set grepprg=findstr\ /n\ /s\ /p
else
  set grepprg=grep\ -R\ -n\ --exclude-dir=.git\ --exclude-dir=node_modules\ --binary-files=without-match\ --line-number\ --color=never
endif

" Make ** recursive searching work with :find
set path+=**

" ─────────────────────────────────────────────────────────────────────────────
" Highlights & UX niceties (no heredocs; inline :lua call is safe)
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

" Autochdir to file dir
augroup AutoChdir
  autocmd!
  autocmd VimEnter * silent! lcd %:p:h
augroup END

" Strip trailing whitespace
augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

" Indentation by filetype
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

" Restore last cursor position
augroup LastCursor
  autocmd!
  autocmd BufReadPost * if line("'\"")>1 && line("'\"")<=line("$") | exec "normal! g'\"" | endif
augroup END

" Close quickfix after opening an entry
augroup QfEnterClose
  autocmd!
  autocmd FileType qf nnoremap <silent><buffer> <CR> <CR>:cclose<CR>
  autocmd FileType qf nnoremap <silent><buffer> q :cclose<CR>
augroup END

" ─────────────────────────────────────────────────────────────────────────────
" Commands
" ─────────────────────────────────────────────────────────────────────────────
command! PrettyJSON %!python -m json.tool

" ─────────────────────────────────────────────────────────────────────────────
" Functions (no-deps stand-ins)
" ─────────────────────────────────────────────────────────────────────────────

" Toggle netrw (Explorer) like NvimTree
function! s:ToggleNetrw() abort
  for w in range(1, winnr('$'))
    if getbufvar(winbufnr(w), '&filetype') ==# 'netrw'
      execute w . 'wincmd c'
      return
    endif
  endfor
  Lexplore
  vert resize 45
endfunction

" Close current buffer, keep window layout
function! CloseBuffer() abort
  let l:bn = bufnr('%')
  bprevious | execute 'bdelete ' . l:bn
endfunction

" Small, generic comment toggler (respects 'commentstring')
function! s:ToggleCommentRange(line1, line2) range abort
  let l:cs = &l:commentstring
  if l:cs ==# '' | let l:cs = '# %s' | endif
  let l:pref = substitute(l:cs, '%s', '', '')
  let l:pref = substitute(l:pref, '\s\+$', '', '')
  let l:is_commented = 1
  for lnum in range(a:line1, a:line2)
    if getline(lnum) !~ '^\s*' . escape(l:pref, '#*/\^$.~[](){}+?|-')
      let l:is_commented = 0 | break
    endif
  endfor
  for lnum in range(a:line1, a:line2)
    let l:ln = getline(lnum)
    if l:is_commented
      call setline(lnum, substitute(l:ln, '^\s*' . escape(l:pref,'#*/\^$.~[](){}+?|-') . '\s\?', '', ''))
    else
      call setline(lnum, l:pref . ' ' . l:ln)
    endif
  endfor
endfunction

nnoremap <silent> <C-c> :<C-u>set opfunc=<SID>CommentOp<CR>g@
xnoremap <silent> <C-c> :<C-u>call <SID>ToggleCommentRange(line("'<"), line("'>"))<CR>

function! s:CommentOp(type) abort
  if a:type ==# 'line'
    call <SID>ToggleCommentRange(line('.'), line('.'))
  else
    normal! `[V`]
    call <SID>ToggleCommentRange(line("'<"), line("'>"))
  endif
endfunction

" Poor-man's "LSP"
nnoremap <silent> K :help <C-r><C-w><CR>
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

" Git helpers without plugins
nnoremap <silent> gx :silent! !git checkout -- %<CR>:edit<CR>
nnoremap <silent> gs :silent! !git add %<CR>:echo 'Staged current file'<CR>
nnoremap <silent> gn :if &diff<Bar>normal! ]c<Bar>else<Bar>cnext<Bar>endif<CR>
nnoremap <silent> gp :if &diff<Bar>normal! [c<Bar>else<Bar>cprevious<Bar>endif<CR>

" ─────────────────────────────────────────────────────────────────────────────
" Mappings – preserved semantics with built-in stand-ins
" ─────────────────────────────────────────────────────────────────────────────

" NetRW toggle like NvimTree on <C-b>
nnoremap <silent> <C-b> :call <SID>ToggleNetrw()<CR>
inoremap <silent> <C-b> <C-o>:call <SID>ToggleNetrw()<CR><Esc>

" Buffer/Tab nav
" Primary
nnoremap <silent> <M-l> :bnext<CR>
nnoremap <silent> <M-h> :bprevious<CR>
nnoremap <silent> <A-l> :bnext<CR>
nnoremap <silent> <A-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <C-h> :bprevious<CR>
" Fallback for terminals that send ESC + key
nnoremap <silent> <Esc>l :bnext<CR>
nnoremap <silent> <Esc>h :bprevious<CR>

nnoremap <silent> ( :tabprevious<CR>
nnoremap <silent> ) :tabnext<CR>

" Close buffer
nnoremap <silent> <A-d> :call CloseBuffer()<CR>
nnoremap <silent> <A-D> :call CloseBuffer()<CR>

" Mode switching
inoremap <silent> jj <Esc>
inoremap <silent> <C-j> <C-\><C-n>
vnoremap <silent> <C-j> <C-\><C-n>
tnoremap <silent> <C-j> <C-\><C-n>

" Command mode on Space
nnoremap <Space> :

" Finders (Telescope stand-ins)
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <C-f> :RG<CR>

" “LSP” keys
nnoremap <silent> <F1> :help <C-r><C-w><CR>
nnoremap <silent> <F2> :call <SID>GotoDef()<CR>
nnoremap <silent> <F3> :call <SID>FindRefs()<CR>
nnoremap <silent> <F4> :echo 'Apply code action (manual)'<CR>
nnoremap <silent> gi    :call <SID>FindRefs()<CR>
nnoremap <silent> gd    :call <SID>GotoDef()<CR>
nnoremap <silent> gr    :call <SID>FindRefs()<CR>
nnoremap <silent> gw    :vimgrep /\<\k\+\>/gj **/* <Bar> copen<CR>

" Wrapped-line movement
nnoremap <silent> j gj
nnoremap <silent> k gk
map <silent> gl $
map <silent> gh 0

" Terminal
nnoremap <silent> <C-T> :terminal<CR>

" Window resize
nnoremap <silent> = :resize -4<CR>
nnoremap <silent> - :resize +4<CR>
nnoremap <silent> + :vertical resize -5<CR>
nnoremap <silent> _ :vertical resize +5<CR>

" Move lines up/down
nnoremap <silent> <A-j> :m .+1<CR>==
nnoremap <silent> <A-k> :m .-2<CR>==
inoremap <silent> <A-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <A-k> <Esc>:m .-2<CR>==gi
vnoremap <silent> <A-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-k> :m '<-2<CR>gv=gv

" Misc
nnoremap <silent> <C-LeftMouse> <Nop>
nnoremap <C-Space> za
xnoremap <silent> * y/\V<C-R>=escape(@",'/\')<CR><CR>


" ── Basic Lua configuration ─────────────────────────────────────────────────────
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "vim", "vimdoc", "bash", "python", "javascript", "typescript", "go", "json", "html", "css", "yaml" },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
}
EOF
" ─────────────────────────────────────────────────────────────────────────────
