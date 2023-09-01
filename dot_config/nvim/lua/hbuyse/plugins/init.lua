return {
  {
    -- Git wrapper
    'tpope/vim-fugitive',
  },
  {
    -- Super fast git decorations
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({})
    end,
  },
  {
    -- Startup time profiler
    'dstein64/vim-startuptime',
    -- lazy-load on a command
    cmd = 'StartupTime',
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    -- Autopairs
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
      local has_cmp, cmp = pcall(require, 'cmp')
      if has_cmp then
        cmp.event:on(
          'confirm_done',
          require('nvim-autopairs.completion.cmp').on_confirm_done({ map_char = { tex = '' } })
        )
      end
    end,
  },
  {
    -- Indentation guides to all lines (including empty lines)
    'lukas-reineke/indent-blankline.nvim',
  },
  {
    -- Smart and powerful comment
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
  },
  {
    -- Fancy start screen for Vim
    'mhinz/vim-startify',
  },
  {
    -- Better annotation generator
    'danymat/neogen',
    ft = { 'c', 'cpp', 'rust', 'lua', 'python' },
    config = function()
      require('neogen').setup({})
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    -- Add/change/delete surrounding delimiter pairs with ease
    'kylechui/nvim-surround',
  },
  {
    -- Robot framework highlight
    'mfukar/robotframework-vim',
    ft = 'robot',
  },
}
