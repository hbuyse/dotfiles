require('nvim-autopairs').setup({})
local has_cmp, cmp = pcall(require, 'cmp')
if has_cmp then
  cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done({ map_char = { tex = '' } }))
end
