local has_ls, ls = pcall(require, 'luasnip')

if not has_ls then
  return
end

local types = require('luasnip.util.types')

-- Every unspecified option will be set to the default.
ls.config.set_config({
  history = true,
  -- Update more often, :h events for more info.
  updateevents = 'TextChanged,TextChangedI',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { 'choiceNode', 'Comment' } },
      },
    },
  },
  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  enable_autosnippets = true,
})

require('luasnip.loaders.from_vscode').lazy_load()
-- vim: set ts=2 sw=2 tw=0 noet ft=lua :
