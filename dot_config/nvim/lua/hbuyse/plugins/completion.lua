local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

return {
  {
    'hrsh7th/nvim-cmp',
    -- load cmp on InsertEnter
    event = 'InsertEnter',
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'saadparwaiz1/cmp_luasnip' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },

      -- Icons
      { 'onsails/lspkind-nvim' },
    },
    config = function()
      -- luasnip setup
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()

      -- nvim-cmp setup
      local cmp = require('cmp')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {
            'i',
            's',
          }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            'i',
            's',
          }),
        },
        sources = {
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'buffer', keyword_length = 5 },
          { name = 'path' },
        },
        formatting = {
          format = require('lspkind').cmp_format({
            with_text = false,
            mode = 'symbol',
            maxwidth = 50,
            menu = {
              luasnip = '[snip]',
              nvim_lsp = '[LSP]',
              nvim_lua = '[api]',
              buffer = '[buf]',
              path = '[path]',
            },
          }),
        },
        experimental = {
          native_menu = false,
          ghost_text = true,
        },
      })
    end,
  },
  {
    -- Autopairs
    'windwp/nvim-autopairs',
    config = true,
    init = function()
      local has_cmp, cmp = pcall(require, 'cmp')
      if has_cmp then
        cmp.event:on(
          'confirm_done',
          require('nvim-autopairs.completion.cmp').on_confirm_done({ map_char = { tex = '' } })
        )
      end
    end,
  },
}
