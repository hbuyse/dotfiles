""""""""""""""""
" CLANG-FORMAT "
""""""""""""""""

" Clang format on C/C++ file when saving
function! AutoClangFormatOnSave()
    let l:lines = "all"
    let l:files = [
    \   "/usr/share/clang/clang-format-10/clang-format.py",
    \   "/usr/share/clang/clang-format.py"
    \]
    let l:file = ""

    for i in l:files
        if filereadable(i)
            let l:file=i
            break
        endif
    endfor

    if has('python')
        execute "pyf" l:file
    elseif has('python3')
        execute "py3f " l:file
    endif
endfunction
autocmd BufWritePre *.c,*.h,*.cc,*.cpp call AutoClangFormatOnSave()
" vim: set ts=4 sw=4 tw=78 et :
