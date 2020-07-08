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
set expandtab
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
filetype plugin on

" Always enable the statusline
set laststatus=2

" Show current line
set cursorline

" Open new split panes to right and bottom, which feels more natural than Vim’s default:
set splitbelow
set splitright

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
Plug 'airblade/vim-gitgutter'

" Comment functions so powerful—no comment necessary.
Plug 'scrooloose/nerdcommenter'

" surround.vim: quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" Fuzzy file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Autocompletion for Vim
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

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
Plug 'gruvbox-community/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'drewtempelmeyer/palenight.vim'

" Statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Doxygen
Plug 'vim-scripts/DoxygenToolkit.vim'
call plug#end()

" CTRL-L will mute highlighted search results
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

source $HOME/.config/nvim/gruvbox.vim
source $HOME/.config/nvim/folding.vim
source $HOME/.config/nvim/ruler.vim
source $HOME/.config/nvim/indentline.vim
source $HOME/.config/nvim/nerdtree.vim
source $HOME/.config/nvim/nerdcommenter.vim
source $HOME/.config/nvim/tagbar.vim
source $HOME/.config/nvim/lsp.vim
source $HOME/.config/nvim/moveline.vim
source $HOME/.config/nvim/modeline.vim
source $HOME/.config/nvim/autojump.vim
source $HOME/.config/nvim/clipboard.vim
source $HOME/.config/nvim/gitcommit.vim
source $HOME/.config/nvim/fzf-bindings.vim
source $HOME/.config/nvim/vsearch.vim
source $HOME/.config/nvim/gitgutter.vim
source $HOME/.config/nvim/extra-whitespaces.vim

" Limit the display of the branch to 32 characters
let g:airline#extensions#branch#displayed_head_limit = 32

" Cscope mappings
nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>

function! IsOnSomeParticularMachine(hostname)
    return match(system("echo -n $HOST"), a:hostname) >= 0
endfunction

if IsOnSomeParticularMachine("T480") || IsOnSomeParticularMachine("CG8250")
	source $HOME/.config/nvim/personnal.vim
else
	source $HOME/.config/nvim/work.vim
endif
