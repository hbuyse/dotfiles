return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'auto',
        background = {
          light = 'latte',
          dark = 'mocha',
        },
      })
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  },
  {
    'SmiteshP/nvim-navic',
    config = true,
    opts = {
      icons = {
        File = '󰈙 ',
        Module = ' ',
        Namespace = '󰌗 ',
        Package = ' ',
        Class = '󰌗 ',
        Method = '󰆧 ',
        Property = ' ',
        Field = ' ',
        Constructor = ' ',
        Enum = '󰕘',
        Interface = '󰕘',
        Function = '󰊕 ',
        Variable = '󰆧 ',
        Constant = '󰏿 ',
        String = '󰀬 ',
        Number = '󰎠 ',
        Boolean = '◩ ',
        Array = '󰅪 ',
        Object = '󰅩 ',
        Key = '󰌋 ',
        Null = '󰟢 ',
        EnumMember = ' ',
        Struct = '󰌗 ',
        Event = ' ',
        Operator = '󰆕 ',
        TypeParameter = '󰊄 ',
      },
      lsp = {
        auto_attach = false,
        preference = nil,
      },
      highlight = true,
      separator = '  ',
      depth_limit = 0,
      depth_limit_indicator = '..',
      safe_output = true,
      lazy_update_context = false,
      click = false,
    },
  },
  {
    -- Blazing fast and easy to configure Neovim statusline written in Lua
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'SmiteshP/nvim-navic',
    },
    opts = {
      options = {
        theme = 'catppuccin',
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
      winbar = {
        lualine_c = {
          {
            function()
              return require('nvim-navic').get_location()
            end,
            cond = function()
              return require('nvim-navic').is_available()
            end,
          },
        },
      },
    },
    config = true,
  },
  {
    -- bufferline (tabline)
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
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
      })
    end,
    lazy = false,
    keys = {
      { 'H', '<cmd>BufferLineCyclePrev<CR>', desc = 'Move to previous bufferline' },
      { 'L', '<cmd>BufferLineCycleNext<CR>', desc = 'Move to next bufferline' },
    },
  },
}
