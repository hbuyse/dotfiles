"""""""""""""
" MOVE LINE "
"""""""""""""

" Mappings to move lines
nnoremap <a-j> :move .+1<cr>==
nnoremap <a-k> :move .-2<cr>==
inoremap <a-j> <esc>:move .+1<cr>==gi
inoremap <a-k> <esc>:move .-2<cr>==gi
vnoremap <a-j> :move '>+1<cr>gv=gv
vnoremap <a-k> :move '<-2<cr>gv=gv

nnoremap <a-Up> :move .+1<cr>==
nnoremap <a-Down> :move .-2<cr>==
inoremap <a-Up> <esc>:move .+1<cr>==gi
inoremap <a-Down> <esc>:move .-2<cr>==gi
vnoremap <a-Up> :move '>+1<cr>gv=gv
vnoremap <a-Down> :move '<-2<cr>gv=gv
