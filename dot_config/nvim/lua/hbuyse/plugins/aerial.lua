return {
  {
    'stevearc/aerial.nvim',
    opts = {
      backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },
      layout = { max_width = 0.3 },
    },
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<F3>', '<cmd>AerialToggle!<CR>', desc = 'Symbols outline' },
    },
  },
}
