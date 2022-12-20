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

local nkeymaps = {
  ['<F3>'] = '<cmd>TSPlaygroundToggle<CR>',
}
for map, cmd in pairs(nkeymaps) do
  vim.keymap.set('n', map, cmd, { noremap = true, silent = true })
end
