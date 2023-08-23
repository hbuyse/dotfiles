local has_notify, _ = pcall(require, 'notify')

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

local nkeymaps = {
  ['<C-p>'] = { cmd = require('telescope.builtin').find_files, desc = 'Search Files' },
  ['<leader>sb'] = { cmd = require('telescope.builtin').buffers, desc = '[S]earch [B]uffers' },
  ['<leader>sd'] = { cmd = require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics' },
  ['<leader>sf'] = { cmd = require('telescope.builtin').find_files, desc = '[S]earch [F]iles' },
  ['<leader>sg'] = { cmd = require('telescope.builtin').live_grep, desc = '[S]earch by [G]rep' },
  ['<leader>sh'] = { cmd = require('telescope.builtin').help_tags, desc = '[S]earch [H]elp' },
  ['<leader>sr'] = { cmd = require('telescope.builtin').lsp_references, '[S]earch [R]eferences' },
  ['<leader>sw'] = {
    cmd = function()
      require('telescope.builtin').grep_string({ word_match = '-w' })
    end,
    desc = '[S]earch current [W]ord',
  },
  ['<leader>dt'] = {
    cmd = function()
      require('telescope.builtin').git_files({ cwd = os.getenv('HOME') .. '/.local/share/chezmoi' })
    end,
    desc = 'Search in [D]o[T]files',
  },
}

if has_notify then
  require('telescope').load_extension('notify')
  nkeymaps['<leader>sn'] = { cmd = require('telescope').extensions.notify.notify, desc = '[S]earch [N]otifications' }
end

for k, v in pairs(nkeymaps) do
  vim.keymap.set('n', k, v.cmd, { noremap = true, silent = true, desc = v.desc })
end
