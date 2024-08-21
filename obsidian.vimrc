imap jj <Esc>
imap <C-j> <C-\><C-n>
nmap <Space> :
map gl $
map gh 0
nmap j gj
nmap k gk
set clipboard=unnamed
exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
nnoremap <C-Space> za
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>
