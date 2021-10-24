local M = {}

function M.getHostname()
  local f = io.open('/etc/hostname')
  local hostname = f:read('*a') or ''
  f:close()
  hostname = string.gsub(hostname, '\n$', '')
  return hostname
end

return M
-- vim: set ts=2 sw=2 tw=0 noet ft=lua :
