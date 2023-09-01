return {
  {
    -- bufferline (tabline)
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local palette = require('gruvbox.palette')
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
          offsets = {
            {
              filetype = 'neo-tree',
              text = 'File Explorer',
              highlight = 'Directory',
              text_align = 'left',
              separator = true,
            },
          },
        },
        highlights = {
          separator = {
            fg = palette.colors.dark1,
          },
          separator_selected = {
            fg = palette.colors.dark1,
          },
        },
      })
    end,
    init = function()
      local keymaps = {
        H = { cmd = '<cmd>BufferLineCyclePrev<CR>', desc = 'Move to previous bufferline' },
        L = { cmd = '<cmd>BufferLineCycleNext<CR>', desc = 'Move to next bufferline' },
      }
      for k, v in pairs(keymaps) do
        vim.keymap.set('n', k, v.cmd, { remap = false, silent = true, desc = v.desc })
      end
    end,
  },
}
