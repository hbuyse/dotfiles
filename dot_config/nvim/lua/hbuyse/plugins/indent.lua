return {
  {
    -- Indentation guides to all lines (including empty lines)
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      local hooks = require('ibl.hooks')

      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- https://github.com/ellisonleao/gruvbox.nvim/blob/6e4027ae957cddf7b193adfaec4a8f9e03b4555f/lua/gruvbox.lua#L87C12-L87C21
        vim.api.nvim_set_hl(0, 'IblScope', { fg = '#a89984', bold = true, nocombine = true })
        -- https://github.com/ellisonleao/gruvbox.nvim/blob/6e4027ae957cddf7b193adfaec4a8f9e03b4555f/lua/gruvbox.lua#L80
        vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#7c6f64', bold = false, nocombine = true })
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
