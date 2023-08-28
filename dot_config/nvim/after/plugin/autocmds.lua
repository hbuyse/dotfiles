local lsp = pcall(require, 'lspconfig')
local lsp_extensions = pcall(require, 'lsp_extensions')

if lsp and lsp_extensions then
  -- Enable type inlay hints
  local lsp_inlay_hints_group_id = vim.api.nvim_create_augroup('LSPInlayHints', {})
  vim.api.nvim_create_autocmd({
    'CursorMoved',
    'InsertLeave',
    'BufEnter',
    'BufWinEnter',
    'TabEnter',
    'BufWritePost',
  }, {
    group = lsp_inlay_hints_group_id,
    pattern = '*.rs',
    callback = function()
      lsp_extensions.inlay_hints({
        prefix = '',
        highlight = 'Comment',
        enabled = { 'TypeHint', 'ChainingHint', 'ParameterHint' },
      })
    end,
  })
end

-- Trim whitespace
local trim_whitespace_gid = vim.api.nvim_create_augroup('TrimWhitespace', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = trim_whitespace_gid,
  desc = 'Trim whitespaces before saving',
  callback = function()
    -- Do not remove whitespaces if we are in git diff
    for _, v in ipairs({ 'diff' }) do
      if vim.bo.filetype == v then
        return
      end
    end

    vim.api.nvim_command('%s/\\s\\+$//e')
  end,
})

-- Autojump to last known position in the file
local autojump_gid = vim.api.nvim_create_augroup('AutoJump', {})
vim.api.nvim_create_autocmd('BufReadPost', {
  group = autojump_gid,
  desc = 'Autojump to last known position in the file',
  pattern = '*',
  callback = function(data)
    local last_pos = vim.fn.line('\'"')
    local end_pos = vim.fn.line('$')
    if 0 < last_pos and last_pos <= end_pos then
      vim.fn.execute('normal! g\'"')
    end
  end,
})

-- vim: set ts=2 sw=2 tw=0 et ft=lua :
