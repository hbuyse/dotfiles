vim.g.DoxygenToolkit_startCommentTag = '/*!'
vim.g.DoxygenToolkit_startCommentBlock = '/* '
vim.g.DoxygenToolkit_briefTag_pre = '\\brief '
vim.g.DoxygenToolkit_paramTag_pre = '\\param[in, out] '
vim.g.DoxygenToolkit_returnTag = '\\return '

-- Neogen
vim.keymap.set('n', '<leader>nf', "<cmd>lua require('neogen').generate({type = 'func'})<CR>")
vim.keymap.set('n', '<leader>nc', "<cmd>lua require('neogen').generate({ type = 'class' })<CR>")
vim.keymap.set('n', '<leader>nt', "<cmd>lua require('neogen').generate({ type = 'type' })<CR>")
