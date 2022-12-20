-- Kommentary
vim.keymap.set('n', '<leader>c<space>', '<Plug>kommentary_line_default', {
  noremap = false,
  silent = false,
})
vim.keymap.set('x', '<leader>c<space>', '<Plug>kommentary_visual_default<C-c>', {
  noremap = false,
  silent = false,
})
