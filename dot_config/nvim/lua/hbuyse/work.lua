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
  vim.api.nvim_set_option_value(opt, val, { win = 0 })
  -- vim.api.nvim_set_option_value(opt, val, { scope = 'global' })
end

for opt, val in pairs(bopts) do
  vim.api.nvim_set_option_value(opt, val, { bufnr = 0 })
  -- vim.api.nvim_set_option_value(opt, val, { scope = 'global' })
end
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
