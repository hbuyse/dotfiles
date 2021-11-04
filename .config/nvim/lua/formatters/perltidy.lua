local Job = require('plenary.job')

local perltidy = {}

perltidy.format = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- stylua: ignore
  local j = Job:new({
    'perltidy',
    '-q',
    '-',
    writer = vim.api.nvim_buf_get_lines(0, 0, -1, false),
  })

  local output = j:sync()

  if j.code ~= 0 then
    -- Schedule this so that it doesn't do dumb stuff like printing two things.
    vim.schedule(function()
      print('[perltidy] Failed to process due to errors')
    end)

    return
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
  pcall(vim.api.nvim_buf_clear_namespace, bufnr, Luasnip_ns_id, 0, -1)

  -- Handle some weird snippet problems. Not everyone will necessarily have this problem.
  Luasnip_current_nodes = Luasnip_current_nodes or {}
  Luasnip_current_nodes[bufnr] = nil
end

return perltidy
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
