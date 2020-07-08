" Folding
set foldmethod=manual
set foldnestmax=10
set nofoldenable
set foldlevel=2

" Mappings to toggle folds
" With the following in your vimrc, you can toggle folds open/closed by pressing F9.
" In addition, if you have :set foldmethod=manual, you can visually select some lines, then press F9 to create a fold.
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf
