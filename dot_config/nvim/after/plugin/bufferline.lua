local palette = require('gruvbox.palette')

vim.api.nvim_set_hl(0, 'BufferLineSeparatorSelected', { fg = palette.dark1 })
vim.api.nvim_set_hl(0, 'BufferLineSeparator', { fg = palette.dark1 })

require('bufferline').setup({
  options = {
    mode = 'buffers',
    color_icons = true,
    show_buffer_close_icons = false,
    show_close_icons = false,
    modified_icon = '[+]',
    separator_style = 'slant',
    always_show_bufferline = true,
    diagnostics = 'nvim_lsp',
  },
})
