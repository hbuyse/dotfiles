-- This file can be loaded by calling `lua require('packer')`
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup({
  function(use)
    -- Packer can manage itself as an optional plugin
    use({ 'wbthomason/packer.nvim' })

    -- git
    use({
      'tpope/vim-fugitive',
    })

    use({
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup({})
      end,
    })

    use({
      'neovim/nvim-lspconfig',
    })

    use({
      'hrsh7th/nvim-cmp',
      requires = {
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lua' },
        { 'saadparwaiz1/cmp_luasnip' },

        -- Snippets
        { 'L3MON4D3/LuaSnip' },
        { 'rafamadriz/friendly-snippets' },

        -- Icons
        { 'onsails/lspkind-nvim' },
      },
    })

    use('windwp/nvim-autopairs')

    -- telescope
    use({
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-lua/popup.nvim' },
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-tree/nvim-web-devicons' },
        { 'nvim-telescope/telescope-file-browser.nvim' },
      },
    })

    -- treesitter
    use({
      'nvim-treesitter/nvim-treesitter',
      requires = {
        { 'nvim-treesitter/playground' },
      },
      run = ':TSUpdate',
    })

    -- gruvbox
    use({
      'ellisonleao/gruvbox.nvim',
      requires = { 'rktjmp/lush.nvim' },
    })

    -- nvim tree
    use({
      'nvim-tree/nvim-tree.lua',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true },
      branch = 'master',
    })

    -- lualine
    use({
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    })

    -- indentline
    use('lukas-reineke/indent-blankline.nvim')

    -- doxygen
    use('vim-scripts/DoxygenToolkit.vim')

    -- comments
    use({
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    })

    -- colorizer
    use('norcalli/nvim-colorizer.lua')

    -- Startify
    use('mhinz/vim-startify')

    -- Markdown preview
    use({
      'iamcco/markdown-preview.nvim',
      ft = 'markdown',
      run = function()
        vim.fn['mkdp#util#install']()
      end,
    })

    -- Neogen
    use({
      'danymat/neogen',
      config = function()
        require('neogen').setup({})
      end,
      tag = '*',
      requires = 'nvim-treesitter/nvim-treesitter',
    })

    -- surround.vim
    use({
      'kylechui/nvim-surround',
      tag = '*', -- Use for stability; omit to use `main` branch for the latest features
      config = function()
        require('nvim-surround').setup({
          -- Configuration here, or leave empty to use defaults
        })
      end,
    })

    -- bufferline (tabline)
    use({
      'akinsho/bufferline.nvim',
      tag = '*',
      requires = 'nvim-tree/nvim-web-devicons',
    })

    -- robot framework highlight
    use('mfukar/robotframework-vim')

    -- Notifier
    use({
      'rcarriga/nvim-notify',
      tag = '*',
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end,
})
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
