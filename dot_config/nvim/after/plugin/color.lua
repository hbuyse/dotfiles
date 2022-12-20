local palette = require('gruvbox.palette')

vim.g.gruvbox_contrast_dark = 'medium'
vim.g.gruvbox_sign_column = 'bg1'
vim.g.gruvbox_hls_highlight = 'orange'
require('gruvbox').setup()
vim.cmd('colorscheme gruvbox')

-- Set the colors for LSP floating window
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#4F4945' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#4F4945', fg = palette.light1 })

-- Set colorcolumn colors
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = palette.dark1 })

-- ----------------
-- Indent Blankline
-- ----------------
for name, color in pairs({
  IndentBlanklineChar = palette.dark4, -- Highlight of indent character
  IndentBlanklineSpaceChar = palette.dark4, -- Highlight of space character
  -- IndentBlanklineSpaceCharBlankline = palette.neutral_red, -- Highlight of space character on blank lines.
  IndentBlanklineContextChar = palette.light2, -- Highlight of indent character when base of current context
  -- IndentBlanklineContextSpaceChar = palette.neutral_red, -- Highlight of space characters one indent level of the current context
  -- IndentBlanklineContextStart = palette.neutral_red, -- Highlight of the first line of the current context.
}) do
  vim.api.nvim_set_hl(0, name, { fg = color, nocombine = true })
end
require('indent_blankline').setup({
  use_treesitter = true,
  show_current_context = true,
  show_current_context_start = false,
  space_char_blankline = ' ',
  char_list = { '|', '¦', '┆', '┊' },
})
--  vim: set ts=2 sw=2 tw=0 noet ft=lua :
