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
    -- Quickstart configs for Nvim LSP
    'neovim/nvim-lspconfig',
  },
  {
    -- Autopairs
    'windwp/nvim-autopairs',
  },
  {
    -- Fuzzy finder
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
    },
  },
  {
    -- Treesitter configurations and abstraction layer
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'nvim-treesitter/playground' },
    },
    build = ':TSUpdate',
  },
  {
    -- File Explorer For Neovim Written In Lua
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    -- Blazing fast and easy to configure Neovim statusline written in Lua
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
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
    -- Markdown preview
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
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
    -- bufferline (tabline)
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {
    -- Robot framework highlight
    'mfukar/robotframework-vim',
    ft = 'robot',
  },
  {
    -- Fancy, configurable, notification manager
    'rcarriga/nvim-notify',
  },
}
