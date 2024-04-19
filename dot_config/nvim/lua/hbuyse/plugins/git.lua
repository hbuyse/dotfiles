return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'nvim-telescope/telescope.nvim', -- optional
      'sindrets/diffview.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
    },
    config = true,
    keys = {
      {
        '<leader>gs',
        function()
          require('neogit').open()
        end,
      },
      {
        '<leader>gc',
        function()
          require('neogit').open({ 'commit' })
        end,
      },
      {
        '<leader>gl',
        function()
          require('neogit').open({ 'log' })
        end,
      },
    },
  },
  {
    -- Super fast git decorations
    'lewis6991/gitsigns.nvim',
    config = true,
  },
  {
    'FabijanZulj/blame.nvim',
    config = true,
  },
}
