local palette = require('gruvbox.palette')

-- ----------------
-- Indent Blankline
-- ----------------
require('indent_blankline').setup({
  use_treesitter = true,
  show_current_context = true,
  show_current_context_start = false,
  space_char_blankline = ' ',
  char_list = { '|', '¦', '┆', '┊' },
})

local group = vim.api.nvim_create_augroup('IndentBlanklineHighlight', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local indentblankline = {
      IndentBlanklineChar = palette.colors.dark4, -- Highlight of indent character
      IndentBlanklineSpaceChar = palette.colors.dark4, -- Highlight of space character
      IndentBlanklineSpaceCharBlankline = palette.colors.neutral_red, -- Highlight of space character on blank lines.
      IndentBlanklineContextChar = palette.colors.light2, -- Highlight of indent character when base of current context
      IndentBlanklineContextSpaceChar = palette.neutral_red, -- Highlight of space characters one indent level of the current context
      IndentBlanklineContextStart = palette.neutral_red, -- Highlight of the first line of the current context.
    }
    for name, color in pairs(indentblankline) do
      vim.api.nvim_set_hl(0, name, { foreground = color, nocombine = true })
    end
  end,
  group = group,
})

vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { foreground = palette.colors.neutral_red, nocombine = true })
vim.api.nvim_set_hl(0, 'IndentBlanklineContextStart', { special = palette.colors.visual_grey, underline = true })
vim.api.nvim_set_hl(0, 'IndentBlanklineContextSpaceChar', { nocombine = true })

vim.g.gruvbox_contrast_dark = 'medium'
vim.g.gruvbox_sign_column = 'bg1'
vim.g.gruvbox_hls_highlight = 'orange'
vim.o.background = 'dark'
require('gruvbox').setup({
  overrides = {
    -- Set the colors for LSP floating window
    NormalFloat = { bg = palette.colors.dark1, fg = palette.colors.light1 },
    FloatBorder = { bg = palette.colors.dark1, fg = palette.colors.light1 },

    -- Set colorcolumn colors
    ColorColumn = { bg = palette.colors.dark1 },
  },
})
vim.cmd('colorscheme gruvbox')
--  vim: set ts=2 sw=2 tw=0 noet ft=lua :
