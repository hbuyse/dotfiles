return {
  {
    -- Indentation guides to all lines (including empty lines)
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      local palette = require('gruvbox').palette
      local hooks = require('ibl.hooks')

      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'IblScope', { fg = palette.light4, bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, 'IblIndent', { fg = palette.dark4, bold = false, nocombine = true })
      end)

      require('ibl').setup({
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
        },
        indent = {
          char = { '|', '¦', '┆', '┊' },
        },
      })
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
