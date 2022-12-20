-- This file can be loaded by calling `lua require('packer')`

local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

-- Only required if you have packer in your `opt` pack
vim.api.nvim_command('packadd packer.nvim')

return require('packer').startup({
  function()
    -- Packer can manage itself as an optional plugin
    use({ 'wbthomason/packer.nvim', opt = true })

    -- git
    use({
      'tpope/vim-fugitive',
    })

    use({
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
      },
    })

    use({
      'VonHeikemen/lsp-zero.nvim',
      requires = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' },
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lua' },

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
        { 'kyazdani42/nvim-web-devicons' },
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
      'kyazdani42/nvim-tree.lua',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    })

    -- lualine
    use({
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    })

    -- indentline
    use('lukas-reineke/indent-blankline.nvim')

    -- doxygen
    use('vim-scripts/DoxygenToolkit.vim')

    -- kommentary
    use('b3nj5m1n/kommentary')

    -- colorizer
    use('norcalli/nvim-colorizer.lua')

    -- file-line
    use('bogado/file-line')

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
      requires = 'nvim-treesitter/nvim-treesitter',
    })

    -- surround.vim
    use('kylechui/nvim-surround')

    -- bufferline (tabline)
    use({
      'akinsho/bufferline.nvim',
      tag = 'v3.*',
      requires = 'kyazdani42/nvim-web-devicons',
    })

    -- robot framework highlight
    use('mfukar/robotframework-vim')
  end,
})
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
