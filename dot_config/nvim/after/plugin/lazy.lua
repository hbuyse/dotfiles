local has_lazy, lazy = pcall(require, 'lazy')

if not has_lazy then
  return
end

vim.keymap.set('n', '<F12>', lazy.home, { noremap = true, silent = true, desc = 'Open Lazy homepage' })
