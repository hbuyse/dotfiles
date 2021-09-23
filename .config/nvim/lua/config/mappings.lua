local function kmap(mode, key, result)
  -- TODO: use vim.api.nvim_buf_set_keymap after
  vim.api.nvim_set_keymap(mode, key, result, {noremap = true, silent = true})
end

local setup_mappings = function()
  -- Telescope
  kmap('n', '<C-p>',      ':lua require"telescope.builtin".find_files()<CR>')
  kmap('n', '<leader>fr', ':lua require"telescope.builtin".lsp_references()<CR>')
  kmap('n', '<leader>fs', ':lua require"telescope.builtin".live_grep()<CR>')
  kmap('n', '<leader>fw', ':lua require"telescope.builtin".grep_string({search = vim.fn.expand("<cword>")})<CR>')
  kmap('n', '<leader>fh', ':lua require"telescope.builtin".help_tags()<CR>')
  kmap('n', '<leader>fb', ':lua require"telescope.builtin".buffers()<CR>')
  kmap('n', '<leader>fq', ':lua require"telescope.builtin".quickfix()<CR>')
  kmap('n', '<leader>fg', ':lua require"telescope.builtin".git_files()<CR>')
  kmap('n', '<leader>ft', ':lua require"telescope.builtin".document_diagnostics()<CR>')
  kmap('n', '<leader>fd', ':lua require"config.dotfiles".search_dotfiles({})<CR>')

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

  -- Kommentary
  vim.api.nvim_set_keymap("n", "<leader>c<space>", "<Plug>kommentary_line_default", {noremap = false, silent = false})
  vim.api.nvim_set_keymap("x", "<leader>c<space>", "<Plug>kommentary_visual_default<C-c>", {noremap = false, silent = false})

  -- moveline
  kmap('n', '<a-j>', ":move .+1<cr>==")
  kmap('i', '<a-j>', "<esc>:move .+1<cr>==gi")
  kmap('v', '<a-j>', ":move '>+1<cr>gv=gv")
  kmap('n', '<a-k>', ":move .-2<cr>==")
  kmap('i', '<a-k>', "<esc>:move .-2<cr>==gi")
  kmap('v', '<a-k>', ":move '<-2<cr>gv=gv")

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
  local undocharacters = {',', '.', '?', '!', '[', ']', '(', ')', '/', '\'', '"', ' '}
  for _, c in ipairs(undocharacters) do
    kmap('i', c, c .. '<C-g>u')
  end

  -- Sadistic mode: remap Arrow keys to force me to use hjkl...
  local modes = {
    '', -- Normal, Visual, Select, Operator-pending
    'i' -- Insert
  }
  local characters = {'<Up>', '<Down>', '<Right>', '<Left>', '<PageUp>', '<PageDown>'}
  for _, mode in ipairs(modes) do
    for _, c in ipairs(characters) do
      kmap(mode, c, '<nop>')
    end
  end

  -- In INSERT mode, doing 'jk' is equivalent to <Esc> (retunr to NORMAL mode)
  kmap('i', 'jk', '<Esc>')
end

setup_mappings()

-- vim: set ts=2 sw=2 tw=0 et ft=lua :
