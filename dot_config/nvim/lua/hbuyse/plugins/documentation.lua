return {
  {
    -- Better annotation generator
    'danymat/neogen',
    ft = { 'c', 'cpp', 'rust', 'lua', 'python' },
    config = true,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      {
        '<leader>nf',
        function()
          require('neogen').generate({ type = 'func' })
        end,
        desc = 'Generate documentation for function',
      },
      {
        '<leader>nc',
        function()
          require('neogen').generate({ type = 'class' })
        end,
        desc = 'Generate documentation for class',
      },
      {
        '<leader>nt',
        function()
          require('neogen').generate({ type = 'type' })
        end,
        desc = 'Generate documentation for type',
      },
    },
  },
}
