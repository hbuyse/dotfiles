local stylua = require('formatters.stylua')
local perltidy = require('formatters.perltidy')
local jsontool = require('formatters.jsontool')

-- Automatically format Lua code
if vim.fn.executable('stylua') == 1 then
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
if vim.fn.executable('perltidy') == 1 then
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
local gid = vim.api.nvim_create_augroup('JsonFormaterAuto', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = gid,
  desc = 'JSON Code Formatter',
  pattern = '*.json',
  callback = function()
    jsontool.format()
  end,
})
