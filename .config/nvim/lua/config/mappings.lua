local has_snippets, snippets = pcall(require, 'snippets')

local function kmap(mode, key, result)
  -- TODO: use vim.api.nvim_buf_set_keymap after
  vim.api.nvim_set_keymap(mode, key, result, {noremap = true, silent = true})
end

local setup_mappings = function()
  -- Completion
  vim.api.nvim_set_keymap('i', '<tab>', '<Plug>(completion_smart_tab)', {noremap = false, silent = false})
  vim.api.nvim_set_keymap('i', '<s-tab>', '<Plug>(completion_smart_s_tab)', {noremap = false, silent = false})

  -- Diagnostics
  kmap('n', '<leader>dn', ':lua vim.lsp.diagnostic.goto_next()<CR>')
  kmap('n', '<leader>dp', ':lua vim.lsp.diagnostic.goto_prev()<CR>')
  kmap('n', '<leader>ds', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')

  -- LSP
  kmap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
  kmap('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
  kmap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
  kmap('n', 'gw', ':lua vim.lsp.buf.document_symbol()<CR>')
  kmap('n', 'gW', ':lua vim.lsp.buf.workspace_symbol()<CR>')
  kmap('n', 'gr', ':lua vim.lsp.buf.references()<CR>')
  kmap('n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>')
  kmap('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
  kmap('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>')
  kmap('n', '<leader>ca', ':lua vim.lsp.buf.code_action()<CR>')
  kmap('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>')

  -- Telescope
  kmap('n', '<C-p>', ':lua require"telescope.builtin".find_files()<CR>')
  kmap('n', '<leader>fr', ':lua require"telescope.builtin".lsp_references()<CR>')
  kmap('n', '<leader>ff', ':lua require"telescope.builtin".file_browser()<CR>')
  kmap('n', '<leader>fs', ':lua require"telescope.builtin".live_grep()<CR>')
  kmap('n', '<leader>fw', ':lua require"telescope.builtin".grep_string(vim.fn.expand("<cword>"))<CR>')
  kmap('n', '<leader>fh', ':lua require"telescope.builtin".help_tags()<CR>')
  kmap('n', '<leader>fb', ':lua require"telescope.builtin".buffers()<CR>')
  kmap('n', '<leader>fq', ':lua require"telescope.builtin".quickfix()<CR>')
  kmap('n', '<leader>fg', ':lua require"telescope.builtin".git_files()<CR>')
  kmap('n', '<leader>ft', ':lua require"telescope.builtin".document_diagnostics()<CR>')
  kmap('n', '<leader>fd', ':lua require"config.dotfiles".search_dotfiles({})<CR>')
  kmap('n', '<leader>fm', ':lua require"telescope".extensions.media_files.media_files()<CR>')

  -- nvim-tree
  kmap('n', '<F2>', ':NvimTreeToggle<CR>')

  -- Misc
  kmap('', '<leader> ', ':noh<CR>')

  -- Clipboard
  kmap('n', '<leader>y', '"+y')
  kmap('n', '<leader>yy', '"+yy')
  kmap('v', '<leader>y', '"+y')
  kmap('n', '<leader>Y', ':%y+<CR>')
  kmap('n', '<leader>p', '"+p')
  kmap('n', '<leader>pp', '"+p')
  kmap('v', '<leader>p', '"+p')
  kmap('n', '<leader>P', ':%p+<CR>')

  -- bufferline
  kmap('n', '<leader>bn', ':BufferLineCycleNext<CR>')
  kmap('n', '<leader>bp', ':BufferLineCyclePrev<CR>')

  kmap('n', '<leader>bl', ':BufferLinePick<CR>')

  -- nerdcommenter
  -- I do not know why, but Vim/Neovim understands <C-/> as <c-_>
  -- for _, c in ipairs({'<C-_>', '<leader>cc'}) do
  --   vim.api.nvim_set_keymap('n', c, '<Plug>NERDCommenterToggle', {noremap = false, silent = false})
  --   vim.api.nvim_set_keymap('v', c, '<Plug>NERDCommenterToggle', {noremap = false, silent = false})
  -- end

  -- moveline
  kmap('n', '<a-j>', ":move .+1<cr>==")
  kmap('i', '<a-j>', "<esc>:move .+1<cr>==gi")
  kmap('v', '<a-j>', ":move '>+1<cr>gv=gv")
  kmap('n', '<a-k>', ":move .-2<cr>==")
  kmap('i', '<a-k>', "<esc>:move .-2<cr>==gi")
  kmap('v', '<a-k>', ":move '<-2<cr>gv=gv")
  kmap('n', '<a-Up>', ":move .+1<cr>==")
  kmap('i', '<a-Up>', "<esc>:move .+1<cr>==gi")
  kmap('v', '<a-Up>', ":move '>+1<cr>gv=gv")
  kmap('n', '<a-Down>', ":move .-2<cr>==")
  kmap('i', '<a-Down>', "<esc>:move .-2<cr>==gi")
  kmap('v', '<a-Down>', ":move '<-2<cr>gv=gv")

  -- Mappings to toggle folds
  -- With the following in your vimrc, you can toggle folds open/closed by pressing F9.
  -- In addition, if you have :set foldmethod=manual, you can visually select some lines, then press F9 to create a fold.
  kmap('i', '<F9>', '<C-O>za')
  kmap('n', '<F9>', 'za')
  kmap('o', '<F9>', '<C-C>za')
  kmap('v', '<F9>', 'zf')

  -- Some good remaps from ThePrimeagen (https://www.youtube.com/watch?v=hSHATqh8svM)
  kmap('n', 'Y', 'y$')       -- Copy to the end of the line
  kmap('n', 'n', 'nzzzv')    -- Keep the search centered
  kmap('n', 'N', 'Nzzzv')    -- Keep the search centered

  -- Undo break points
  characters = {',', '.', '?', '!', '[', ']', '(', ')'}
  for _, c in ipairs(characters) do
    kmap('i', c, c .. '<C-g>u')
  end

  -- Sadistic mode: remap Arrow keys to force me to use hjkl...
  characters = {'<Up>', '<Down>', '<Right>', '<Left>'}
  for _, c in ipairs(characters) do
    kmap('', c, '<nop>')
  end
end

setup_mappings()

-- vim: set ts=2 sw=2 tw=0 et ft=lua :
