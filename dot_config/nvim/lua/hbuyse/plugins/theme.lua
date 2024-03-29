return {
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local palette = require('gruvbox').palette

      vim.g.gruvbox_contrast_dark = 'medium'
      vim.g.gruvbox_sign_column = 'bg1'
      vim.g.gruvbox_hls_highlight = 'orange'
      vim.o.background = 'dark'
      require('gruvbox').setup({
        overrides = {
          -- Set the colors for LSP floating window
          NormalFloat = { bg = palette.dark1, fg = palette.light1 },
          FloatBorder = { bg = palette.dark1, fg = palette.light1 },
        },
      })
      vim.cmd('colorscheme gruvbox')
    end,
  },
  {
    -- Blazing fast and easy to configure Neovim statusline written in Lua
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      options = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        icons_enabled = true,
      },
      sections = {
        lualine_a = { { 'mode' } },
        lualine_b = { { 'branch', icon = '' } },
        lualine_c = {
          { 'filename', file_status = true, path = 1 },
          {
            'diff',
            colored = true,
            symbols = { added = '+', modified = '~', removed = '-' }, -- Changes the symbols used by the diff.
            source = nil,
          },
        },
        lualine_x = {
          {
            'diagnostics',
            sources = { (vim.version().minor < 6) and 'nvim_lsp' or 'nvim_diagnostic' },
            symbols = { error = ' ', warn = ' ' },
          },
        },
        lualine_y = { 'encoding', 'fileformat', 'filetype' },
        lualine_z = { 'progress', 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { 'fugitive' },
    },
    config = true,
  },
  {
    -- bufferline (tabline)
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local palette = require('gruvbox').palette
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
            fg = palette.dark1,
          },
          separator_selected = {
            fg = palette.dark1,
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
