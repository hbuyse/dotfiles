""""""""""""""""
" CLANG-FORMAT "
""""""""""""""""

" Clang format on C/C++ file when saving
function! AutoClangFormatOnSave()
    let l:files = []
    let l:lines = "all"
    let l:formatdiff = 0
    if has('bsd')
        let l:formatdiff = 1 " Format changes only
        let l:files = [
        \   "/usr/local/llvm-devel/share/clang/clang-format.py",
        \   "/usr/local/llvm11/share/clang/clang-format.py",
        \   "/usr/local/llvm10/share/clang/clang-format.py",
        \   "/usr/local/llvm90/share/clang/clang-format.py"
        \]
    elseif has('unix')
        let l:files = [
        \   "/usr/share/clang/clang-format-12/clang-format.py",
        \   "/usr/share/clang/clang-format-11/clang-format.py",
        \   "/usr/share/clang/clang-format-10/clang-format.py",
        \   "/usr/share/clang/clang-format.py"
        \]
    endif
    let l:file = ""

    " Use the first file found
    for i in l:files
        if filereadable(i)
            let l:file=i
            break
        endif
    endfor

    " Execute if python3 is supported
    if has('python3')
        execute "py3f" l:file
    endif
endfunction
autocmd BufWritePre *.c,*.h,*.cc,*.cpp call AutoClangFormatOnSave()
" vim: set ts=4 sw=4 tw=78 et :
