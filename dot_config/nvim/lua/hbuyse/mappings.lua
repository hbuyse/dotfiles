local function kmap(mode, key, result)
  vim.keymap.set(mode, key, result, { remap = false, silent = true })
end

-- Misc
kmap('', '<leader><space>', '<Cmd>nohlsearch<Bar>diffupdate<CR><C-L>')

-- Clipboard
kmap('n', '<leader>y', '"+y')
kmap('n', '<leader>yy', '"+yy')
kmap('v', '<leader>y', '"+y')
kmap('n', '<leader>Y', '<cmd>%y+<CR>')
kmap('n', '<leader>p', '"+p')
kmap('n', '<leader>pp', '"+p')
kmap('v', '<leader>p', '"+p')
kmap('n', '<leader>P', '<cmd>%p+<CR>')

-- moveline
vim.keymap.set('n', '<a-j>', ':move .+1<cr>==')
vim.keymap.set('n', '<a-k>', ':move .-2<cr>==')
vim.keymap.set('i', '<a-j>', '<esc>:move .+1<cr>==gi')
vim.keymap.set('i', '<a-k>', '<esc>:move .-2<cr>==gi')
vim.keymap.set('v', '<a-j>', ":move '>+1<cr>gv=gv")
vim.keymap.set('v', '<a-k>', ":move '<-2<cr>gv=gv")

-- Mappings to toggle folds
-- With the following in your vimrc, you can toggle folds open/closed by pressing F9.
-- In addition, if you have :set foldmethod=manual, you can visually select some lines, then press F9 to create a fold.
kmap('i', '<F9>', '<C-O>za')
kmap('n', '<F9>', 'za')
kmap('o', '<F9>', '<C-C>za')
kmap('v', '<F9>', 'zf')

-- Some good remaps from ThePrimeagen (https://www.youtube.com/watch?v=hSHATqh8svM)
kmap('n', 'n', 'nzzzv') -- Keep the search centered
kmap('n', 'N', 'Nzzzv') -- Keep the search centered

-- From one of my colleagues
kmap('n', '*', '*N') -- Do not go to the next word but highlight all iterations of the current word

-- Undo break points
local undocharacters = { ',', '.', '?', '!', '[', ']', '(', ')', '/', "'", '"', ' ' }
for _, c in ipairs(undocharacters) do
  kmap('i', c, c .. '<C-g>u')
end

-- Sadistic mode: remap Arrow keys to force me to use hjkl...
local modes = {
  '', -- Normal, Visual, Select, Operator-pending
  'i', -- Insert
}
local characters = { '<Up>', '<Down>', '<Right>', '<Left>', '<PageUp>', '<PageDown>' }
for _, mode in ipairs(modes) do
  for _, c in ipairs(characters) do
    kmap(mode, c, '<nop>')
  end
end

-- In INSERT mode, doing 'jk' is equivalent to <Esc> (retunr to NORMAL mode)
kmap('i', 'jk', '<Esc>')

-- Buffer movement
kmap('n', 'H', '<cmd>BufferLineCyclePrev<CR>')
kmap('n', 'L', '<cmd>BufferLineCycleNext<CR>')

-- Do nothing
kmap('n', 'Q', '<nop>')

-- Do not move the curso when doing 'J' in normal mode
kmap('n', 'J', 'mzJ`z')

-- Remap the p command in visual mode so that it first deletes to the black hole register
kmap('x', '<leader>p', '"_dP')

-- Open command to replace the word under cursor in the whole document
kmap('n', '<leader>s', ':%s/<<C-r><C-w>>/<C-r><C-w>/gI<Left><Left><Left>')

-- vim: set ts=2 sw=2 tw=0 et ft=lua :
