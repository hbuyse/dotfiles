-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  vim.api.nvim_command('packadd packer.nvim')
end

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]


return require'packer'.startup(function()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  -- git
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'

  -- lsp
  use 'neovim/nvim-lspconfig'
  use {
    'nvim-lua/completion-nvim',
    requires = {
      { 'norcalli/snippets.nvim' },
    }
  }
  use 'anott03/nvim-lspinstall'
  use {
    'onsails/lspkind-nvim',
    config = function()
      -- commented options are defaults
      require('lspkind').init({
          -- with_text = true,
          -- symbol_map = {
          --   Text = '',
          --   Method = 'ƒ',
          --   Function = '',
          --   Constructor = '',
          --   Variable = '',
          --   Class = '',
          --   Interface = 'ﰮ',
          --   Module = '',
          --   Property = '',
          --   Unit = '',
          --   Value = '',
          --   Enum = '了',
          --   Keyword = '',
          --   Snippet = '﬌',
          --   Color = '',
          --   File = '',
          --   Folder = '',
          --   EnumMember = '',
          --   Constant = '',
          --   Struct = ''
          -- },
      })
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-media-files.nvim'},
      {'jremmen/vim-ripgrep'},
    }
  }

  -- gruvbox
  use {
    'gruvbox-community/gruvbox',
    config = function()
      vim.g.gruvbox_contrast_dark = 'medium'
      vim.g.gruvbox_sign_column = 'bg1'
      vim.g.gruvbox_hls_highlight = 'orange'
      vim.api.nvim_exec([[ colorscheme gruvbox ]], false)
    end
  }

  -- nvim tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      vim.g.nvim_tree_side = 'left'
    end
  }

  -- lualine
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require('lualine').setup{
        options = {
          theme = 'gruvbox',
          section_separators = {'', ''},
          component_separators = {'', ''},
          icons_enabled = true,
        },
        sections = {
          lualine_a = { {'mode', upper = true} },
          lualine_b = { {'branch', icon = ''} },
          lualine_c = { {'filename', file_status = true} },
          lualine_x = { {'diagnostics', sources = {'nvim_lsp'}} },
          lualine_y = { 'encoding', 'fileformat', 'filetype' },
          lualine_z = { 'progress', 'location'  },
        },
        inactive_sections = {
          lualine_a = {  },
          lualine_b = {  },
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {  },
          lualine_z = {   }
        },
        extensions = { 'fugitive' }
      }
    end
  }

  -- indentline
  use {
    'yggdroot/indentline',
    config = function()
      vim.g.indentLine_color_term = 243
      vim.g.indentLine_color_gui = '#7c6f64'
      vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
    end
  }

  -- doxygen
  use {
    'vim-scripts/DoxygenToolkit.vim',
    config = function()
      vim.g.DoxygenToolkit_startCommentTag = "/*!"
      vim.g.DoxygenToolkit_startCommentBlock = "/* "
      vim.g.DoxygenToolkit_briefTag_pre = "\\brief "
      vim.g.DoxygenToolkit_paramTag_pre = "\\param[in, out] "
      vim.g.DoxygenToolkit_returnTag = "\\return "
      vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
    end
  }

  -- nerdcommenter
  use {
    'preservim/nerdcommenter',
    config = function()
      -- Create default mappings
      vim.g.NERDCreateDefaultMappings = 1

      -- Add spaces after comment delimiters by default
      vim.g.NERDSpaceDelims = 1

      -- Use compact syntax for prettified multi-line comments
      vim.g.NERDCompactSexyComs = 1

      -- Align line-wise comment delimiters flush left instead of following code indentation
      vim.g.NERDDefaultAlign = 'left'

      -- Add your own custom formats or override the defaults
      vim.g.NERDCustomDelimiters = {
        c = {
          left = '/**',
          right = '*/'
        }
      }

      -- Allow commenting and inverting empty lines (useful when commenting a region)
      vim.g.NERDCommentEmptyLines = 1

      -- Enable trimming of trailing whitespace when uncommenting
      vim.g.NERDTrimTrailingWhitespace = 1

      -- Enable NERDCommenterToggle to check all selected lines is commented or not
      vim.g.NERDToggleCheckAllLines = 1
    end
  }

  -- colorizer
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup{'css', 'javascript', 'vim', 'html', 'ini', 'xdefaults'}
    end
  }
end)
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
