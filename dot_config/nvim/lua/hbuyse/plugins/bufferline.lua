return {
  {
    -- bufferline (tabline)
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
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
    },
    init = function()
      local palette = require('gruvbox.palette')
      vim.api.nvim_set_hl(0, 'BufferLineSeparatorSelected', { fg = palette.colors.dark1 })
      vim.api.nvim_set_hl(0, 'BufferLineSeparator', { fg = palette.colors.dark1 })
    end,
    keys = {
      { 'H', '<cmd>BufferLineCyclePrev<CR>', 'Move to previous bufferline' },
      { 'L', '<cmd>BufferLineCycleNext<CR>', 'Move to next bufferline' },
    },
  },
}
