return {
  {
    -- Indentation guides to all lines (including empty lines)
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      use_treesitter = true,
      show_current_context = true,
      show_current_context_start = false,
      space_char_blankline = ' ',
      char_list = { '|', '¦', '┆', '┊' },
    },
  },
}
