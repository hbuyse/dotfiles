" Show trailing whitespace, spaces before a tab and tabs that are not at the
" start of a line
highlight ExtraWhitespace ctermbg=108 guibg=#689d6a
match ExtraWhitespace /\s\+$\| \+\ze\t\| [^\t]\zs\t\+/
