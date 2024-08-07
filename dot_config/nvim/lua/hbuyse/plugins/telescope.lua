return {
  {
    -- Fuzzy finder
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
    },

    opts = {
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

        -- file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        -- grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        -- qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--trim',
        },
      },
    },
    init = function()
      -- Notify support
      local has_notify, _ = pcall(require, 'notify')
      if has_notify then
        require('telescope').load_extension('notify')
      end

      -- Aerial support
      local has_aerial, _ = pcall(require, 'aerial')
      if has_aerial then
        require('telescope').load_extension('aerial')
      end
    end,
    keys = function(plugin, keys)
      local nkeymaps = {
        { '<C-p>', require('telescope.builtin').find_files, desc = 'Search Files' },
        { '<leader>b', require('telescope.builtin').buffers, desc = '[B]uffers' },
        { '<C-b>', require('telescope.builtin').buffers, desc = '[B]uffers' },
        { '<leader>sd', require('telescope.builtin').diagnostics, desc = '[S]earch [D]iagnostics' },
        { '<leader>sf', require('telescope.builtin').find_files, desc = '[S]earch [F]iles' },
        { '<leader>sg', require('telescope.builtin').live_grep, desc = '[S]earch by [G]rep' },
        { '<leader>sh', require('telescope.builtin').help_tags, desc = '[S]earch [H]elp' },
        { '<leader>sr', require('telescope.builtin').lsp_references, desc = '[S]earch [R]eferences' },
        {
          '<leader>sw',
          function()
            require('telescope.builtin').grep_string({ word_match = '-w' })
          end,
          desc = '[S]earch current [W]ord',
        },
        {
          '<leader>dt',
          function()
            require('telescope.builtin').git_files({ cwd = os.getenv('HOME') .. '/.dotfiles' })
          end,
          desc = 'Search in [D]o[T]files',
        },
      }

      local notify = require('telescope').extensions.notify
      if notify ~= nil then
        table.insert(nkeymaps, { '<leader>sn', notify.notify, desc = '[S]earch [N]otifications' })
      end

      local aerial = require('telescope').extensions.aerial
      if aerial then
        table.insert(nkeymaps, { '<leader>ss', aerial.aerial, desc = '[S]earch [S]ymbols' })
      end

      return nkeymaps
    end,
  },
}
