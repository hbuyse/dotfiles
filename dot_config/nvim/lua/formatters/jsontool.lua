local Job = require('plenary.job')

local jsontool = {}

jsontool.format = function(bufnr)
  if vim.g.python3_host_prog == nil then
    print('[jsontool] python3_host_prog not set.')
    return
  end

  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- jsontool: ignore
  local j = Job:new({
    command = vim.g.python3_host_prog,
    args = { '-m', 'json.tool', '-' },
    writer = vim.api.nvim_buf_get_lines(0, 0, -1, false),
    on_stderr = function(error, data, job)
      print('[jsontool] ' .. data)
    end,
  })

  local output = j:sync()

  if j.code ~= 0 then
    return
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
  pcall(vim.api.nvim_buf_clear_namespace, bufnr, Luasnip_ns_id, 0, -1)

  -- Handle some weird snippet problems. Not everyone will necessarily have this problem.
  Luasnip_current_nodes = Luasnip_current_nodes or {}
  Luasnip_current_nodes[bufnr] = nil
end

return jsontool
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
