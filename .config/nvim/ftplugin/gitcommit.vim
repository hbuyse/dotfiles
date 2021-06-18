function! GitCommitPositionZeroAndStartInsertMode()
	call setpos('.', [0, 1, 1, 0])
	start
endfunction

" Always start on first line of git commit message
" From: https://vim.fandom.com/wiki/Always_start_on_first_line_of_git_commit_message
au! BufEnter COMMIT_EDITMSG call GitCommitPositionZeroAndStartInsertMode()
