require('nvim-tree').setup({
  view = {
    side = 'left',
    number = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
})

local nkeymaps = {
  ['<F2>'] = '<cmd>NvimTreeToggle<CR>',
}
for map, cmd in pairs(nkeymaps) do
  vim.keymap.set('n', map, cmd, { noremap = true, silent = true })
end
