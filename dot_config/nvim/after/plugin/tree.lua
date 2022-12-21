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
  ['<F2>'] = { cmd = '<cmd>NvimTreeToggle<CR>', desc = 'Toggle Nvim-Tree' },
}
for k, v in pairs(nkeymaps) do
  vim.keymap.set('n', k, v.cmd, { noremap = true, silent = true, desc = v.desc })
end
