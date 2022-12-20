require('lualine').setup({
  options = {
    theme = 'gruvbox',
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
})
