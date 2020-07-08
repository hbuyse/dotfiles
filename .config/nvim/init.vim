" Enable syntax highlighting
syntax on

set guicursor=
set noshowmatch
set noshowmode
set hlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set noexpandtab
set smartindent
set number " Show line numbers
set relativenumber " Show relative line numbersr
set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8

" Always enable the statusline
set laststatus=2

" Show current line
set cursorline

" Open new split panes to right and bottom, which feels more natural than Vim’s default:
set splitbelow
set splitright

" Folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=100

"
set list lcs=tab:\|\ 

if !has('gui_running')
  set t_Co=256
endif

call plug#begin(stdpath('data') . '/plugged')
"Plug 'powerline/powerline'

" A tree explorer plugin for vim.
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Git
Plug 'tpope/vim-fugitive'

" surround.vim: quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" Fuzzy file finder
Plug 'ctrlpvim/ctrlp.vim'

" Auto complete brackets, quotes
"Plug 'jiangmiao/auto-pairs'

" Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
Plug 'w0rp/ale'

" Autocompletion for Vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Cscope
Plug 'brookhong/cscope.vim'

" A vim plugin to display the indention levels with thin vertical lines
Plug 'yggdroot/indentline'

" Vim plugin that displays tags in a window, ordered by scope
Plug 'majutsushi/tagbar'

" Colorschemes
Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'drewtempelmeyer/palenight.vim'

" Statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

"Add ruler to 120 characters
set colorcolumn=120
highlight ColorColumn ctermbg=235 guibg=#262626

" Colorscheme
set background=dark
colorscheme gruvbox

" Change the color of the indentLine
let g:indentLine_color_gui = '#A6A6A6'
" Change the character of the indentLine
"let g:indentLine_char = '▏'

"Show hidden files in NerdTree by default
let NERDTreeShowHidden=1

" How can I open a NERDTree automatically when vim starts up if no files were specified?
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" How can I open NERDTree automatically when vim starts up on opening a directory?
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" How can I map a specific key or shortcut to open NERDTree?
map <F2> :NERDTreeToggle<CR>

" Tagbar configuration
nmap <F8> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

"  How can I show errors or warnings in my statusline?
let g:airline#extensions#ale#enabled = 1

" Write this in your vimrc file
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'c': ['clang-format', 'trim_whitespace'],
\   'markdown': ['trim_whitespace']
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



""""""""""""
" COC.NVIM "
""""""""""""

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

"""""""""""""""""""""
" REMAPPING Alt+j/k "
"""""""""""""""""""""

" Mappings to move lines
nnoremap <A-j> :move .+1<CR>==
nnoremap <A-k> :move .-2<CR>==
inoremap <A-j> <Esc>:move .+1<CR>==gi
inoremap <A-k> <Esc>:move .-2<CR>==gi
vnoremap <A-j> :move '>+1<CR>gv=gv
vnoremap <A-k> :move '<-2<CR>gv=gv

" Type '//' to search for the visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Cscope mappings
nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>

" Format file using Ctrl+k and on save
if has('python')
  map <C-K> :pyf /usr/share/clang/clang-format-10/clang-format.py<cr>
  imap <C-K> <c-o>:pyf /usr/share/clang/clang-format-10/clang-format.py<cr>
elseif has('python3')
  map <C-K> :py3f /usr/share/clang/clang-format-10/clang-format.py<cr>
  imap <C-K> <c-o>:py3f /usr/share/clang/clang-format-10/clang-format.py<cr>
endif

" Format C/C++ files using clang-format
" function Formatonsave()
"   let l:lines="all"
"   if has('python')
"     pyf /usr/share/clang/clang-format-10/clang-format.py
"   elseif has('python3')
"     py3f /usr/share/clang/clang-format-10/clang-format.py
"   endif
" endfunction
" autocmd BufWritePre *.h,*.cc,*.cpp,*.c call Formatonsave()

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Uncomment the following to have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
