require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'arduino',
    'awk',
    'bash',
    'bibtex',
    'c',
    'cmake',
    'comment',
    'cpp',
    'css',
    'devicetree',
    'diff',
    'dockerfile',
    'func',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'go',
    'html',
    'htmldjango',
    'http',
    'ini',
    'jq',
    'json',
    'json5',
    'latex',
    'llvm',
    'lua',
    'luadoc',
    'luap',
    'luau',
    'make',
    'markdown',
    'markdown_inline',
    'meson',
    'ninja',
    'nix',
    'passwd',
    'perl',
    'po',
    'proto',
    'puppet',
    'python',
    'query',
    'rst',
    'rust',
    'scheme',
    'scss',
    'sql',
    'toml',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
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
  ['<F3>'] = { cmd = '<cmd>TSPlaygroundToggle<CR>', desc = 'Toggle TreeSitter Playground' },
}
for k, v in pairs(nkeymaps) do
  vim.keymap.set('n', k, v.cmd, { noremap = true, silent = true, desc = v.desc })
end
