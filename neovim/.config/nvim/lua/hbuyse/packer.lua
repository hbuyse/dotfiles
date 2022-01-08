-- This file can be loaded by calling `lua require('packer')`

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
    autocmd BufWritePost ~/.config/nvim/lua/* PackerCompile
  augroup end
]],
  false
)

return require('packer').startup({
  function()
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
    use({
      'neovim/nvim-lspconfig',
      requires = {
        'nvim-lua/lsp_extensions.nvim',
      },
    })
    use({
      'onsails/lspkind-nvim',
      config = function()
        -- commented options are defaults
        require('lspkind').init({
          with_text = true,
          symbol_map = {
            Text = '',
            Method = 'ƒ',
            Function = '',
            Constructor = '',
            Variable = '',
            Class = '',
            Interface = 'ﰮ',
            Module = '',
            Property = '',
            Unit = '',
            Value = '',
            Enum = '了',
            Keyword = '',
            Snippet = '﬌',
            Color = '',
            File = '',
            Folder = '',
            EnumMember = '',
            Constant = '',
            Struct = '',
          },
        })
      end,
    })

    -- completion
    use({
      'hrsh7th/nvim-cmp',
      requires = {
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lua' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'L3MON4D3/LuaSnip' },
        { 'rafamadriz/friendly-snippets' },
        { 'onsails/lspkind-nvim' },
      },
      config = function()
        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
        end

        local feedkey = function(key, mode)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
        end

        -- luasnip setup
        local luasnip = require('luasnip')

        -- nvim-cmp setup
        local cmp = require('cmp')

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = {
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, {
              'i',
              's',
            }),

            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, {
              'i',
              's',
            }),
          },
          sources = {
            { name = 'luasnip' },
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'buffer', keyword_length = 5 },
            { name = 'path' },
          },
          formatting = {
            format = require('lspkind').cmp_format({
              with_text = false,
              menu = {
                luasnip = '[snip]',
                nvim_lsp = '[LSP]',
                nvim_lua = '[api]',
                buffer = '[buf]',
                path = '[path]',
              },
            }),
          },
          experimental = {
            native_menu = false,
            ghost_text = true,
          },
        })
      end,
    })

    use({
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
            disable = { 'perl' },
          },
          playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
              toggle_query_editor = 'o',
              toggle_hl_groups = 'i',
              toggle_injected_languages = 't',
              toggle_anonymous_nodes = 'a',
              toggle_language_display = 'I',
              focus_language = 'f',
              unfocus_language = 'F',
              update = 'R',
              goto_node = '<cr>',
              show_help = '?',
            },
          },
        })
      end,
    })

    -- gruvbox
    use({
      'ellisonleao/gruvbox.nvim',
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
        require('nvim-tree').setup({
          autoclose = true,
          view = {
            side = 'left',
            auto_resize = true,
          },
        })
      end,
    })

    -- lualine
    use({
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        local treesitter = require('nvim-treesitter')
        local function treelocation()
          return treesitter.statusline({
            indicator_size = 70,
            type_patterns = { 'class_definition', 'function_definition', 'method_definition' },
            separator = ' -> ',
          })
        end
        require('lualine').setup({
          options = {
            theme = 'gruvbox',
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
            icons_enabled = true,
          },
          sections = {
            lualine_a = { { 'mode' } },
            lualine_b = { { 'branch', icon = '' } },
            lualine_c = {
              { 'filename', file_status = true, path = 1 },
              {
                'diff',
                colored = true,
                symbols = { added = '+', modified = '~', removed = '-' }, -- Changes the symbols used by the diff.
                source = nil,
              },
            },
            lualine_x = {
              treelocation,
              {
                'diagnostics',
                sources = { (vim.version().minor < 6) and 'nvim_lsp' or 'nvim_diagnostic' },
                symbols = { error = ' ', warn = ' ' },
              },
            },
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

    -- Startify
    use('mhinz/vim-startify')

    -- Doxygen WIP
    use(os.getenv('HOME') .. '/Programming/doxygen.nvim')
  end,
})
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
