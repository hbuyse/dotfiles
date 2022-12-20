local lsp = require('lsp-zero')
local has_telescope, _ = pcall(require, 'telescope')

lsp.preset('recommended')

lsp.ensure_installed({
  'clangd',
  'pyright',
  'bashls',
  'texlab',
  'jsonls',
  'sumneko_lua',
  'rust_analyzer',
  'robotframework_ls',
})

-- Fix Undefined global 'vim'
lsp.configure('sumneko_lua', {
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Setup some mappings
lsp.setup_nvim_cmp({
  mapping = lsp.defaults.cmp_mappings({
    ['<C-Space>'] = require('cmp').mapping.complete(),
  }),
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = ' ',
    warn = ' ',
    hint = ' ',
    info = '  ',
  },
})

-- Set some key mappings
local function lsp_keymaps(client, bufnr)
  local kmap = function(m, lhs, rhs)
    local opts = { remap = false, silent = true, buffer = bufnr }
    vim.keymap.set(m, lhs, rhs, opts)
  end
  --
  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    kmap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
  elseif client.server_capabilities.documentRangeFormattingProvider then
    kmap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
  end

  -- Diagnostics keymaps
  kmap('n', '<leader>dn', vim.diagnostic.goto_next)
  kmap('n', '<leader>dp', vim.diagnostic.goto_prev)
  kmap('n', '<leader>ds', vim.diagnostic.open_float)

  -- LSP keymaps
  kmap('n', 'gd', vim.lsp.buf.definition)
  kmap('n', 'gD', vim.lsp.buf.declaration)
  kmap('n', 'gi', vim.lsp.buf.implementation)
  kmap('n', 'gw', vim.lsp.buf.document_symbol)
  kmap('n', 'gW', vim.lsp.buf.workspace_symbol)
  kmap('n', 'gr', vim.lsp.buf.references)
  kmap('n', 'gt', vim.lsp.buf.type_definition)
  kmap('n', 'K', vim.lsp.buf.hover)
  kmap('n', '<c-k>', vim.lsp.buf.signature_help)
  kmap('n', '<leader>ca', vim.lsp.buf.code_action)
  kmap('n', '<leader>rn', vim.lsp.buf.rename)

  -- Telescope
  if has_telescope then
    local builtin = require('telescope.builtin')
    kmap('n', '<leader>fr', builtin.lsp_references)
    kmap('n', '<leader>fd', builtin.diagnostics)
  end
end

local function lsp_document_highlight(bufnr)
  local gid = vim.api.nvim_create_augroup('LSPDocumentHighlight', {})
  vim.api.nvim_create_autocmd('CursorHold', {
    group = gid,
    desc = 'Highlight document using LSP server capabilities',
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.document_highlight()
    end,
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = gid,
    desc = 'Clear document highlights using LSP server capabilities',
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.clear_references()
    end,
  })
end

lsp.on_attach(function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  lsp_keymaps(client, bufnr)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    lsp_document_highlight(bufnr)
  end

  -- Override borders globally
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, options, ...)
    local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
    options = options or {}
    options.border = options.border or border
    return orig_util_open_floating_preview(contents, syntax, options, ...)
  end
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = 'always', -- Or "if_many"
  },
  signs = true,
  underline = true,
})

require('lspkind').init({
  mode = 'symbol_text',
  symbol_map = {
    Text = '',
    Method = 'ƒ',
    Function = '',
    Constructor = '',
    Variable = '',
    Class = '',
    Interface = 'ﰮ',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '了',
    Keyword = '',
    Snippet = '﬌',
    Color = '',
    File = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
  },
})
