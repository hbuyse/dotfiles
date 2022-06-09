local packages = {
  'hbuyse.packer',
  'hbuyse.mappings',
  'hbuyse.lsp',
  'hbuyse.snippets',
  'hbuyse.autocmds',
}
for _, v in ipairs(packages) do
  require(v)
end

local hostname = require('hbuyse.hostname')

if hostname.getHostname() == 'henrib-Latitude-5400' then
  local haswork, work = pcall(require, 'hbuyse.work')
end
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
