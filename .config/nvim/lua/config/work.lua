-- Window options
local wopts = {
  wrap = false,
}

-- Buffer options
local bopts = {
  expandtab = false,
  autoindent = true,
  copyindent = true,
  softtabstop = 0,
  shiftwidth = 4,
  tabstop = 4,
}

for opt, val in pairs(wopts) do
  vim.api.nvim_win_set_option(0, opt, val)
  vim.api.nvim_set_option(opt, val)
end

for opt, val in pairs(bopts) do
  vim.api.nvim_buf_set_option(0, opt, val)
  vim.api.nvim_set_option(opt, val)
end
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
