-- Set the Leader key
vim.g.mapleader = ' '

-- Global options
local opts = {
  guicursor = '',
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

  -- completeopt (:help completopt)
  -- menuone   Use the popup menu also when there is only one match.
  --           Useful when there is additional information about the
  --           match, e.g., what file it comes from.
  -- noinsert  Do not insert any text for a match until the user selects
  --           a match from the menu. Only works in combination with
  --           "menu" or "menuone". No effect if "longest" is present.
  -- noselect  Do not select a match in the menu, force the user to
  --           select one from the menu. Only works in combination with
  --           "menu" or "menuone".
  completeopt = 'menuone,noinsert,noselect',

  -- Disable mouse support
  mouse = '',
}

-- Window options
local wopts = {
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
  listchars = {
    tab = '| ',
    -- eol = '↴',
    -- space = '⋅',
  },
  scrolloff = 999,

  -- Set colorcolumn
  colorcolumn = '120,160',
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
  smartindent = true,
}

for opt, val in pairs(opts) do
  vim.api.nvim_set_option(opt, val)
end

for opt, val in pairs(wopts) do
  -- Special case of 'listchars' dictionnary
  if type(val) == 'table' then
    local tmp = nil
    for k, v in pairs(val) do
      if tmp ~= nil then
        tmp = tmp .. ',' .. k .. ':' .. v
      else
        tmp = k .. ':' .. v
      end
    end
    val = tmp
  end

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
  python2_host_prog = vim.env.HOME .. '/.pyenv/versions/py2nvim/bin/python',
  -- Disable Perl support
  loaded_perl_provider = 0,
  -- Disable Ruby support
  loaded_ruby_provider = 0,
  -- Activate editorconfig file support
  editorconfig = true,
}

for var, val in pairs(gvars) do
  vim.api.nvim_set_var(var, val)
end

vim.api.nvim_exec([[ filetype plugin on ]], false)

require('hbuyse')
