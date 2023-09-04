return {
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local palette = require('gruvbox.palette')

      local group = vim.api.nvim_create_augroup('IndentBlanklineHighlight', { clear = false })
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          local indentblankline = {
            IndentBlanklineChar = palette.colors.dark4, -- Highlight of indent character
            IndentBlanklineSpaceChar = palette.colors.dark4, -- Highlight of space character
            IndentBlanklineSpaceCharBlankline = palette.colors.neutral_red, -- Highlight of space character on blank lines.
            IndentBlanklineContextChar = palette.colors.light2, -- Highlight of indent character when base of current context
            IndentBlanklineContextSpaceChar = palette.colors.visual_grey, -- Highlight of space characters one indent level of the current context
            IndentBlanklineContextStart = palette.colors.neutral_red, -- Highlight of the first line of the current context.
          }
          for name, color in pairs(indentblankline) do
            vim.api.nvim_set_hl(0, name, { foreground = color, bold = true, nocombine = true })
          end
        end,
        group = group,
      })

      vim.g.gruvbox_contrast_dark = 'medium'
      vim.g.gruvbox_sign_column = 'bg1'
      vim.g.gruvbox_hls_highlight = 'orange'
      vim.o.background = 'dark'
      require('gruvbox').setup({
        overrides = {
          -- Set the colors for LSP floating window
          NormalFloat = { bg = palette.colors.dark1, fg = palette.colors.light1 },
          FloatBorder = { bg = palette.colors.dark1, fg = palette.colors.light1 },
        },
      })
      vim.cmd('colorscheme gruvbox')
    end,
  },
}
