local function kmap(mode, key, result, desc)
  vim.keymap.set(mode, key, result, { remap = false, silent = true, desc = desc })
end

-- Misc
kmap('', '<leader><space>', '<Cmd>nohlsearch<Bar>diffupdate<CR><C-L>', 'Clear highlight')

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
kmap('n', '<a-j>', ':move .+1<cr>==', 'Move current line down')
kmap('n', '<a-k>', ':move .-2<cr>==', 'Move current line up')
kmap('i', '<a-j>', '<esc>:move .+1<cr>==gi', 'Move current line down')
kmap('i', '<a-k>', '<esc>:move .-2<cr>==gi', 'Move current line up')
kmap('v', '<a-j>', ":move '>+1<cr>gv=gv", 'Move selection down')
kmap('v', '<a-k>', ":move '<-2<cr>gv=gv", 'Move selection up')

-- Mappings to toggle folds
-- With the following in your vimrc, you can toggle folds open/closed by pressing F9.
-- In addition, if you have :set foldmethod=manual, you can visually select some lines, then press F9 to create a fold.
kmap('i', '<F9>', '<C-O>za')
kmap('n', '<F9>', 'za')
kmap('o', '<F9>', '<C-C>za')
kmap('v', '<F9>', 'zf')

-- Some good remaps from ThePrimeagen (https://www.youtube.com/watch?v=hSHATqh8svM)
kmap('n', 'n', 'nzzzv', 'Keep the search centered') -- Keep the search centered
kmap('n', 'N', 'Nzzzv', 'Keep the search centered') -- Keep the search centered

-- From one of my colleagues
kmap('n', '*', '*N') -- Do not go to the next word but highlight all iterations of the current word

-- Undo break points
local undocharacters = { ',', '.', '?', '!', '[', ']', '(', ')', '/', "'", '"', ' ' }
for _, c in ipairs(undocharacters) do
  kmap('i', c, c .. '<C-g>u', 'Undo breakpoints')
end

-- Sadistic mode: remap Arrow keys to force me to use hjkl...
local modes = {
  '', -- Normal, Visual, Select, Operator-pending
  'i', -- Insert
}
local characters = { '<Up>', '<Down>', '<Right>', '<Left>', '<PageUp>', '<PageDown>' }
for _, mode in ipairs(modes) do
  for _, c in ipairs(characters) do
    kmap(mode, c, '<nop>', 'Disable key ' .. c)
  end
end

-- In INSERT mode, doing 'jk' is equivalent to <Esc> (return to NORMAL mode)
kmap('i', 'jk', '<Esc>', 'jk == <Esc>')

-- Do nothing
kmap('n', 'Q', '<nop>', 'Disable key Q')

-- Do not move the cursor when doing 'J' in normal mode
kmap('n', 'J', 'mzJ`z')

-- Remap the p command in visual mode so that it first deletes to the black hole register
kmap('x', '<leader>p', '"_dP')

-- Open command to replace the word under cursor in the whole document
-- Not using kmap since we need to modify the command line
vim.keymap.set(
  'n',
  '<leader>rd',
  ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',
  { desc = '[R]eplace word under cursor in whole [D]ocument' }
)
vim.keymap.set(
  'n',
  '<leader>rl',
  ':s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',
  { desc = '[R]eplace word under cursor in current [L]ine' }
)

local has_lazy, lazy = pcall(require, 'lazy')
if has_lazy then
  kmap('n', '<F12>', lazy.home, 'Open Lazy homepage')
end

kmap('n', '<C-s>', '<cmd>vsplit<CR>')
kmap('n', '<C-h>', '<cmd>split<CR>')

-- vim: set ts=2 sw=2 tw=0 et ft=lua :
