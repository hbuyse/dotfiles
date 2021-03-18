require'config.packer'
require'config.mappings'
require'config.lsp'
local hostname = require'config.hostname'

if hostname.getHostname() == "henrib-Latitude-5400" then
  local haswork, work = pcall(require, 'config.work')
end
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
