""""""""""""
" NERDTREE "
""""""""""""

"Show hidden files in NerdTree by default
let NERDTreeShowHidden=1

" How can I open a NERDTree automatically when vim starts up if no files were specified?
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" How can I open NERDTree automatically when vim starts up on opening a directory?
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" How can I map a specific key or shortcut to open NERDTree?
map <F2> :NERDTreeToggle<CR>

