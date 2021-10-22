-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.api.nvim_command('packadd packer.nvim')
end

-- Only required if you have packer in your `opt` pack
vim.cmd([[packadd packer.nvim]])

-- Automatically compile packer when writing files in $HOME/.config/nvim
vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost ~/.config/nvim/* PackerCompile
  augroup end
]],
  false
)

return require('packer').startup({function()
  -- Packer can manage itself as an optional plugin
  use({ 'wbthomason/packer.nvim', opt = true })

  -- git
  use('tpope/vim-fugitive')
  use({
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gitsigns').setup()
    end,
  })

  -- lsp
  use('neovim/nvim-lspconfig')
  use({
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
    end,
  })

  -- completion
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
      -- luasnip setup
      local luasnip = require('luasnip')

      -- nvim-cmp setup
      local cmp = require('cmp')

      --
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local check_back_space = function()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      cmp.setup({
        --[[ completion = {
          -- Does not perform completion automatically. I can still use manual completion though.
          autocomplete = nil
        }, ]]
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ['<Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
              vim.fn.feedkeys(t('<C-n>'), 'n')
            elseif luasnip.expand_or_jumpable() then
              vim.fn.feedkeys(t('<Plug>luasnip-expand-or-jump'), '')
            elseif check_back_space() then
              vim.fn.feedkeys(t('<tab>'), 'n')
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if vim.fn.pumvisible() == 1 then
              vim.fn.feedkeys(t('<C-p>'), 'n')
            elseif luasnip.jumpable(-1) then
              vim.fn.feedkeys(t('<Plug>luasnip-jump-prev'), '')
            else
              fallback()
            end
          end,
        },
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      })
    end,
  })

  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
      local has_cmp, _ = pcall(require, 'cmp')
      if has_cmp then
        require('nvim-autopairs.completion.cmp').setup({
          map_cr = true, --  map <CR> on insert mode
          map_complete = true, -- it will auto insert `(` after select function or method item
        })
      end
    end,
  })

  -- telescope
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
    },
    config = function()
      require('telescope').setup({
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
            },
          },

          selection_strategy = 'reset',
          sorting_strategy = 'descending',
          scroll_strategy = 'cycle',
          color_devicons = true,
          set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,

          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },

          file_previewer = require('telescope.previewers').vim_buffer_cat.new,
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
        },
      })
    end,
  })

  -- treesitter
  use({
    'nvim-treesitter/nvim-treesitter',
    requires = {
      { 'nvim-treesitter/playground' },
    },
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'maintained',
        highlight = {
          enable = true, -- false will disable the whole extension
        },
      })
    end,
  })

  -- gruvbox
  use({
    'npxbr/gruvbox.nvim',
    requires = { 'rktjmp/lush.nvim' },

    config = function()
      vim.g.gruvbox_contrast_dark = 'medium'
      vim.g.gruvbox_sign_column = 'bg1'
      vim.g.gruvbox_hls_highlight = 'orange'
      vim.api.nvim_exec([[ colorscheme gruvbox ]], false)
    end,
  })

  -- nvim tree
  use({
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      vim.g.nvim_tree_side = 'left'
    end,
  })

  -- lualine
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'gruvbox',
          section_separators = { '', '' },
          component_separators = { '', '' },
          icons_enabled = true,
        },
        sections = {
          lualine_a = { { 'mode', upper = true } },
          lualine_b = { { 'branch', icon = '' } },
          lualine_c = { { 'filename', file_status = true, path = 1 } },
          lualine_x = { { 'diagnostics', sources = { 'nvim_lsp' }, symbols = { error = ' ', warn = ' ' } } },
          lualine_y = { 'encoding', 'fileformat', 'filetype' },
          lualine_z = { 'progress', 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { 'fugitive' },
      })
    end,
  })

  -- indentline
  use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.cmd([[ highlight IndentBlanklineContextChar guifg=#a89984 guibg=NONE gui=NONE gui=nocombine ]])
      require('indent_blankline').setup({
        use_treesitter = true,
        space_char_blankline = ' ',
        show_current_context = true,
        char_list = { '|', '¦', '┆', '┊' },
      })
    end,
  })

  -- doxygen
  use({
    'vim-scripts/DoxygenToolkit.vim',
    config = function()
      vim.g.DoxygenToolkit_startCommentTag = '/*!'
      vim.g.DoxygenToolkit_startCommentBlock = '/* '
      vim.g.DoxygenToolkit_briefTag_pre = '\\brief '
      vim.g.DoxygenToolkit_paramTag_pre = '\\param[in, out] '
      vim.g.DoxygenToolkit_returnTag = '\\return '
    end,
  })

  -- kommentary
  use({
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language('default', {
        prefer_single_line_comments = true,
      })
    end,
  })

  -- colorizer
  use({
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({ 'css', 'javascript', 'vim', 'html', 'ini', 'xdefaults' })
    end,
  })

  -- file-line
  use('bogado/file-line')
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}})
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
