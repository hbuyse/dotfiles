-- Set the Leader key
vim.g.mapleader = ' '

-- Global options
local opts = {
  guicursor = "",
  showmatch = false,
  showmode = false,
  hlsearch = true,
  hidden = true,
  errorbells = false,
  ignorecase = true,
  smartcase = true,
  backup = false,
  undodir = vim.fn.stdpath('data') .. '/undodir',
  incsearch = true,
  termguicolors = true,

  -- Open new split pames to the right and the bottom
  splitbelow = true,
  splitright = true,

  -- Better display for messages
  cmdheight = 2,

  -- Better experience for diagnostics messages
  updatetime = 400,

  -- Encoding
  encoding = 'utf-8',

  syntax = 'on',
  completeopt = "menuone,noinsert,noselect"
}

-- Window options
local wopts = {
  -- Always enable the statusline
  statusline = '2',

  -- wrap
  wrap = false,

  -- display line numbers
  number = true,

  -- display relative line numbers
  relativenumber = true,

  -- Show current line
  cursorline = true,

  -- Show physicale tabulations define by stop
  list = true,

  -- Show the sign column for git-gutter (always 1 column)
  signcolumn = 'yes:1',

  -- folding options
  foldmethod = 'manual',
  foldnestmax = 10,
  foldenable = false,
  foldlevel = 2,

  -- Show tab delimiter
  listchars = 'tab:| ',
  scrolloff = 999
}

-- Buffer options
local bopts = {
  expandtab = false,
  swapfile = false,
  undofile = true,
  tabstop = 4,
  softtabstop = 4,
  shiftwidth = 4,
  autoindent = true,
  smartindent = true
}

for opt, val in pairs(opts) do
  vim.api.nvim_set_option(opt, val)
end

for opt, val in pairs(wopts) do
  vim.api.nvim_win_set_option(0, opt, val)
  vim.api.nvim_set_option(opt, val)
end

for opt, val in pairs(bopts) do
  vim.api.nvim_buf_set_option(0, opt, val)
  vim.api.nvim_set_option(opt, val)
end

local gvars = {
  -- Python programs
  python3_host_prog = vim.env.HOME .. '/.pyenv/versions/py3nvim/bin/python',
  python2_host_prog = vim.env.HOME .. '/.pyenv/versions/py2nvim/bin/python'
}

for var, val in pairs(gvars) do
  vim.api.nvim_set_var(var, val)
end

vim.api.nvim_exec([[ filetype plugin on ]], false)

require'config'
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
