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
set notermguicolors
set t_Co=256
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

" Show physical tabulations define by tabstop
set list lcs=tab:\|\ 

" Encoding
set encoding=UTF-8

" Always show the sign column (used by git-gutter and ALE)
set signcolumn=yes

" Automatic installation of vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
Plug 'w0rp/ale'

" Autocompletion for Vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Management ctags
Plug 'ludovicchabant/vim-gutentags'

" Cscope
Plug 'brookhong/cscope.vim'

" A vim plugin to display the indention levels with thin vertical lines
Plug 'yggdroot/indentline'

" Vim plugin that displays tags in a window, ordered by scope
Plug 'majutsushi/tagbar'

" Icon
Plug 'ryanoasis/vim-devicons'

" Colorschemes
Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'drewtempelmeyer/palenight.vim'

" Statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" CTRL-L will mute highlighted search results
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

"Add ruler to 120 characters
set colorcolumn=120
highlight ColorColumn ctermbg=235 guibg=#262626

" Colorscheme
set background=dark
colorscheme gruvbox

" Change the color of the indentLine
let g:indentLine_color_gui = 236
" Change the character of the indentLine
"let g:indentLine_char = '▏'

"Show hidden files in NerdTree by default
let NERDTreeShowHidden=1

" How can I open NERDTree automatically when vim starts up on opening a directory?
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" How can I map a specific key or shortcut to open NERDTree?
map <F2> :NERDTreeToggle<CR>

" Tagbar configuration
nmap <F8> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

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

" COC
source $HOME/.config/nvim/coc.vim

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

function! IsOnSomeParticularMachine(hostname)
    return match(system("echo -n $HOST"), a:hostname) >= 0
endfunction

if IsOnSomeParticularMachine("T480") || IsOnSomeParticularMachine("CG8250")
	source $HOME/.config/nvim/personnal.vim
else
	source $HOME/.config/nvim/work.vim
endif
