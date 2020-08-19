""""""""""""""""
" CLANG-FORMAT "
""""""""""""""""

" Format file using Ctrl+k and on save
if has('python')
  map <C-K> :pyf /usr/share/clang/clang-format-10/clang-format.py<cr>
  imap <C-K> <c-o>:pyf /usr/share/clang/clang-format-10/clang-format.py<cr>
elseif has('python3')
  map <C-K> :py3f /usr/share/clang/clang-format-10/clang-format.py<cr>
  imap <C-K> <c-o>:py3f /usr/share/clang/clang-format-10/clang-format.py<cr>
endif

" Clang format on C/C++ file when saving
function! Formatonsave()
  let l:formatdiff = 1
  pyf ~/llvm/tools/clang/tools/clang-format/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()
