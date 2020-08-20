source $HOME/.config/nvim/gruvbox.vim
source $HOME/.config/nvim/trailingwhitespace.vim
source $HOME/.config/nvim/ruler.vim
source $HOME/.config/nvim/indentline.vim
source $HOME/.config/nvim/nerdtree.vim
source $HOME/.config/nvim/ale.vim
source $HOME/.config/nvim/coc.vim
source $HOME/.config/nvim/moveline.vim
source $HOME/.config/nvim/clang-format.vim

" Cscope mappings
nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>

" vim: set ts=4 sw=4 tw=78 et :
