local function kmap(mode, key, result)
  -- TODO: use vim.api.nvim_buf_set_keymap after
  vim.keymap.set(mode, key, result, { noremap = true, silent = true })
end

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
  ['<C-p>'] = '<cmd>lua require"telescope.builtin".find_files()<CR>',
  ['<leader>fs'] = '<cmd>lua require"telescope.builtin".live_grep()<CR>',
  ['<leader>fw'] = '<cmd>lua require"telescope.builtin".grep_string({search = vim.fn.expand("<cword>")})<CR>',
  ['<leader>ff'] = '<cmd>lua require"telescope.builtin".grep_string()<CR>',
  ['<leader>fh'] = '<cmd>lua require"telescope.builtin".help_tags()<CR>',
  ['<leader>fb'] = '<cmd>lua require"telescope.builtin".buffers()<CR>',
  ['<leader>fq'] = '<cmd>lua require"telescope.builtin".quickfix()<CR>',
  ['<leader>fg'] = '<cmd>lua require"telescope.builtin".git_files()<CR>',
  ['<leader>dt'] = '<cmd>lua require"telescope.builtin".git_files({cwd = os.getenv("HOME") .. "/.local/share/chezmoi"})<CR>',
}
for map, cmd in pairs(nkeymaps) do
  vim.keymap.set('n', map, cmd, { noremap = true, silent = true })
end
