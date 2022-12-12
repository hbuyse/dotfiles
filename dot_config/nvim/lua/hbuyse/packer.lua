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
          mode = 'symbol_text',
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
        { 'nvim-telescope/telescope-file-browser.nvim' },
      },
      config = function()
        require('telescope').setup({
          defaults = {
            prompt_prefix = '   ',

            winblend = 0,

            layout_strategy = 'vertical',
            layout_config = {
              horizontal = {
                height = 0.9,
                height_padding = 0.1,
                preview_cutoff = 120,
                preview_width = 0.6,
                prompt_position = 'top',
                width = 0.8,
                width_padding = 0.1,
              },
              vertical = {
                -- height = 0.9,
                height_padding = 1,
                -- preview_cutoff = 120,
                -- preview_height = 0.5,
                prompt_position = 'top',
                -- width = 0.8,
                width_padding = 0.05,
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
        require('telescope').load_extension('file_browser')
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
          ensure_installed = 'all',
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
        local palette = require('gruvbox.palette')
        local has_bufferline, _ = pcall(require, 'bufferline')

        vim.g.gruvbox_contrast_dark = 'medium'
        vim.g.gruvbox_sign_column = 'bg1'
        vim.g.gruvbox_hls_highlight = 'orange'
        vim.api.nvim_exec([[ colorscheme gruvbox ]], false)

        -- Set the colors for LSP floating window
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#4F4945' })
        vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#4F4945', fg = palette.light1 })

        -- Set colorcolumn colors
        vim.api.nvim_set_hl(0, 'ColorColumn', { bg = palette.dark1 })

        if has_bufferline then
          vim.api.nvim_set_hl(0, 'BufferLineSeparatorVisible', { fg = palette.bright_orange })
          vim.api.nvim_set_hl(0, 'BufferLineSeparatorSelected', { fg = palette.dark1 })
        end
      end,
    })

    -- nvim tree
    use({
      'kyazdani42/nvim-tree.lua',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        require('nvim-tree').setup({
          view = {
            side = 'left',
            number = true,
          },
          actions = {
            open_file = {
              resize_window = true,
            },
          },
        })
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
        require('colorizer').setup({
          filetypes = { 'css', 'javascript', 'vim', 'html', 'dosini', 'xdefaults' },
          user_default_options = {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            names = true, -- "Name" codes like Blue or blue
            RRGGBBAA = true, -- #RRGGBBAA hex codes
            AARRGGBB = true, -- 0xAARRGGBB hex codes
            rgb_fn = false, -- CSS rgb() and rgba() functions
            hsl_fn = false, -- CSS hsl() and hsla() functions
            css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            -- Available modes for `mode`: foreground, background,  virtualtext
            mode = 'background', -- Set the display mode.
            -- Available methods are false / true / "normal" / "lsp" / "both"
            -- True is same as normal
            tailwind = false, -- Enable tailwind colors
            -- parsers can contain values used in |user_default_options|
            sass = { enable = false, parsers = { css } }, -- Enable sass colors
            virtualtext = '■',
          },
          -- all the sub-options of filetypes apply to buftypes
          buftypes = {},
        })
      end,
    })

    -- file-line
    use({
      'bogado/file-line',
    })

    -- Startify
    use('mhinz/vim-startify')

    -- Markdown preview
    use({
      'iamcco/markdown-preview.nvim',
      ft = 'markdown',
      run = function()
        vim.fn['mkdp#util#install']()
      end,
      -- run = 'cd app && yarn install',
      config = function()
        vim.g.mkdp_browser = 'chromium'
        -- set to 1, nvim will open the preview window after entering the markdown buffer
        -- default: 0
        vim.g.mkdp_auto_start = 0

        -- set to 1, the nvim will auto close current preview window when change
        -- from markdown buffer to another buffer
        -- default: 1
        vim.g.mkdp_auto_close = 1

        -- set to 1, the vim will refresh markdown when save the buffer or
        -- leave from insert mode, default 0 is auto refresh markdown as you edit or
        -- move the cursor
        -- default: 0
        vim.g.mkdp_refresh_slow = 0

        -- set to 1, the MarkdownPreview command can be use for all files,
        -- by default it can be use in markdown file
        -- default: 0
        vim.g.mkdp_command_for_global = 0

        -- set to 1, preview server available to others in your network
        -- by default, the server listens on localhost (127.0.0.1)
        -- default: 0
        vim.g.mkdp_open_to_the_world = 0

        -- use custom IP to open preview page
        -- useful when you work in remote vim and preview on local browser
        -- more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
        -- default empty
        vim.g.mkdp_open_ip = ''

        -- specify browser to open preview page
        -- default: ''
        vim.g.mkdp_browser = ''

        -- set to 1, echo preview page url in command line when open preview page
        -- default is 0
        vim.g.mkdp_echo_preview_url = 0

        -- a custom vim function name to open preview page
        -- this function will receive url as param
        -- default is empty
        vim.g.mkdp_browserfunc = ''

        -- options for markdown render
        -- mkit: markdown-it options for render
        -- katex: katex options for math
        -- uml: markdown-it-plantuml options
        -- maid: mermaid options
        -- disable_sync_scroll: if disable sync scroll, default 0
        -- sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
        --   middle: mean the cursor position alway show at the middle of the preview page
        --   top: mean the vim top viewport alway show at the top of the preview page
        --   relative: mean the cursor position alway show at the relative positon of the preview page
        -- hide_yaml_meta: if hide yaml metadata, default is 1
        -- sequence_diagrams: js-sequence-diagrams options
        -- content_editable: if enable content editable for preview page, default: v:false
        -- disable_filename: if disable filename header for preview page, default: 0
        vim.g.mkdp_preview_options = {
          mkit = {},
          katex = {},
          uml = {},
          maid = {},
          disable_sync_scroll = 0,
          sync_scroll_type = 'middle',
          hide_yaml_meta = 1,
          sequence_diagrams = {},
          flowchart_diagrams = {},
          content_editable = false,
          disable_filename = 0,
        }

        -- use a custom markdown style must be absolute path
        -- like '/Users/username/markdown.css' or expand('~/markdown.css')
        vim.g.mkdp_markdown_css = ''

        -- use a custom highlight style must absolute path
        -- like '/Users/username/highlight.css' or expand('~/highlight.css')
        vim.g.mkdp_highlight_css = ''

        -- use a custom port to start server or random for empty
        vim.g.mkdp_port = ''

        -- preview page title
        -- ${name} will be replace with the file name
        vim.g.mkdp_page_title = '「${name}」'

        -- recognized filetypes
        -- these filetypes will have MarkdownPreview... commands
        vim.g.mkdp_filetypes = { 'markdown' }
      end,
    })

    -- Neogen
    use({
      'danymat/neogen',
      config = function()
        require('neogen').setup({})
      end,
      requires = 'nvim-treesitter/nvim-treesitter',
    })

    -- surround.vim
    use({
      'kylechui/nvim-surround',
      config = function()
        require('nvim-surround').setup()
      end,
    })

    -- bufferline (tabline)
    use({
      'akinsho/bufferline.nvim',
      tag = 'v2.*',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require('bufferline').setup({
          options = {
            mode = 'buffers',
            color_icons = true,
            show_buffer_close_icons = false,
            separator_style = 'slant',
            always_show_bufferline = true,
          },
        })
      end,
    })

    -- robot framework highlight
    use('mfukar/robotframework-vim')
  end,
})
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
