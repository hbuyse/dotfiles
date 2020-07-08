"  How can I show errors or warnings in my statusline?
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1

" Write this in your vimrc file
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'c': ['clang-format', 'trim_whitespace'],
\   'markdown': ['trim_whitespace'],
\   'shell': ['shellcheck']
\}

let g:ale_linters = {
\   'c' : ['gcc']
\}

let g:ale_cpp_ccls_init_options = {
\   'cache': {
\       'directory': '/tmp/ccls/cache'
\   }
\ }

let g:ale_completion_enabled = 0
let g:ale_c_build_dir_names = ['build']
let g:ale_c_parse_compile_commands = 1
let g:ale_c_gcc_options = '-std=c11 -Wall -Wextra -Ibuild -Iinclude'
