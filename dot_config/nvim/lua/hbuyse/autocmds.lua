local packer = require('packer')
local lsp = require('lspconfig')
local lsp_extensions = require('lsp_extensions')

local has_stylua, stylua = pcall(require, 'formatters.stylua')
local has_perltidy, perltidy = pcall(require, 'formatters.perltidy')
local has_jsontool, jsontool = pcall(require, 'formatters.jsontool')

if packer then
  -- Automatically compile packer when writing files in $HOME/.config/nvim
  local packer_gid = vim.api.nvim_create_augroup('AutoPackerCompilation', {})
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = packer_gid,
    desc = 'Automatic compilation of Neovim plugins',
    pattern = '*.lua',
    callback = function(data)
      local nvim_configdir = os.getenv('HOME') .. '/.config/nvim'
      if string.match(data.match, nvim_configdir) then
        packer.compile()
      end
    end,
  })
end

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

-- Automatically format Lua code
if has_stylua and vim.fn.executable('stylua') == 1 then
  local gid = vim.api.nvim_create_augroup('StyluaAuto', {})
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = gid,
    desc = 'Stylua Code Formatter',
    pattern = '*.lua',
    callback = function()
      stylua.format()
    end,
  })
end

-- Automatically format Perl code
if has_perltidy and vim.fn.executable('perltidy') == 1 then
  local gid = vim.api.nvim_create_augroup('PerltidyAuto', {})
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = gid,
    desc = 'Perltidy Code Formatter',
    pattern = { '*.pl', '*.pm' },
    callback = function()
      perltidy.format()
    end,
  })
end

-- Automatically format Perl code
if has_jsontool then
  local gid = vim.api.nvim_create_augroup('JsonFormaterAuto', {})
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = gid,
    desc = 'JSON Code Formatter',
    pattern = '*.json',
    callback = function()
      jsontool.format()
    end,
  })
end

-- Trim whitespace
local trim_whitespace_gid = vim.api.nvim_create_augroup('TrimWhitespace', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = trim_whitespace_gid,
  desc = 'Trim whitespaces before saving',
  command = '%s/\\s\\+$//e',
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
