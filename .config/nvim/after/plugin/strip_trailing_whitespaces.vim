" Trim whitespaces before saving
function! StripTrailingWhitespace()
    " Don't strip on these filetypes
    " if &ft =~ 'ruby\|javascript\|perl'
    if &ft =~ 'vim'
        return
    endif
    %s/\s\+$//e
endfun
autocmd BufWritePre * call StripTrailingWhitespace()

