-- This file can be loaded by calling `lua require('plugins')` from your init.vim

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
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
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
    'norcalli/snippets.nvim',
    config = function()
      require'snippets'.use_suggested_mappings()
    end
  }

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'kyazdani42/nvim-web-devicons'},
    },
    config = function()
      require('telescope').setup {
        defaults = {
          prompt_prefix = ' > ',

          winblend = 0,

          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              width_padding = 0.1,
              height_padding = 0.1,
              preview_width = 0.6,
              prompt_position = 'bottom',
              preview_cutoff = 120,
            },
            vertical = {
              width_padding = 0.05,
              height_padding = 1,
              preview_height = 0.5,
              prompt_position = 'bottom',
              preview_cutoff = 120,
            }
          },

          selection_strategy = 'reset',
          sorting_strategy = 'descending',
          scroll_strategy = 'cycle',
          color_devicons = true,
          set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,

          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},

          file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
          grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
          qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
          },
        }
      }
    end
  }

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      {'nvim-treesitter/playground'}
    },
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
      ensure_installed = {"c", "cpp", "python", "lua", "bash", "json", "rust", "rst"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      highlight = {
        enable = true              -- false will disable the whole extension
      },
    }
    end
  }

  -- gruvbox
  use {
    "npxbr/gruvbox.nvim",
    requires = {"rktjmp/lush.nvim"},
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

  -- kommentary
  use 'b3nj5m1n/kommentary'

  -- colorizer
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup{'css', 'javascript', 'vim', 'html', 'ini', 'xdefaults'}
    end
  }

  -- file-line
  use 'bogado/file-line'
end)
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
