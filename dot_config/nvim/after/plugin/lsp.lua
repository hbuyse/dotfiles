require('mason').setup({
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
})
require('mason-tool-installer').setup({

  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {
    -- LSPs
    'awk-language-server',
    'bash-language-server',
    'clangd',
    'cmake-language-server',
    'json-lsp',
    'nginx-language-server',
    'robotframework-lsp',
    'rust-analyzer',
    'lua-language-server',
    'pyright',
    'texlab',
    'yaml-language-server',

    -- Linters
    'cmakelang',
    --'commitlint',
    'cpplint',
    'gitlint',
    'pylint',
    'shellcheck',
    'markdownlint',
    'rstcheck',
    'yamllint',

    -- Formatters
    'beautysh',
    'black',
    'clang-format',
    'cmakelang',
    'fixjson',
    'isort',
    'jq',
    'rustfmt',
    'stylua',
    'xmlformatter',
    'yamlfmt',
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = false,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = true,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  start_delay = 0,
})
require('mason.settings').set({
  ui = {
    border = 'rounded',
  },
})

local lsp = require('lsp-zero')
local has_telescope, _ = pcall(require, 'telescope')

-- lsp.preset('recommended')
local function custom_preset()
  local opts = require('lsp-zero.presets').recommended()

  opts[1] = 'custom'
  -- Disable preset keymaps to not pollute my keymaps
  opts.set_lsp_keymaps = false

  return opts
end

lsp.set_preferences(custom_preset())

lsp.ensure_installed({
  'awk_ls', -- awk-language-server
  'bashls', -- bash-language-server
  'clangd', -- clangd
  'cmake', -- cmake-language-server
  'jsonls', -- json-lsp
  -- 'nginx-language-server' (not in lspconfig for now)
  'robotframework_ls', -- robotframework-lsp
  'rust_analyzer', -- rust_analyzer
  'sumneko_lua', -- lua-language-server
  'pyright', -- pyright
  'texlab', -- texlab
  'yamlls', -- yaml-language-server
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
  local kmap = function(m, lhs, rhs, desc)
    local opts = { remap = false, silent = true, buffer = bufnr, desc = desc }
    vim.keymap.set(m, lhs, rhs, opts)
  end
  --
  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    kmap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', 'Format current buffer with LSP')
  elseif client.server_capabilities.documentRangeFormattingProvider then
    kmap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', 'Format current buffer with LSP')
  end

  -- Diagnostics keymaps
  kmap('n', '<leader>dn', vim.diagnostic.goto_next, '[D]iagnostic [N]ext')
  kmap('n', '<leader>dp', vim.diagnostic.goto_prev, '[D]iagnostic [P]revious')
  kmap('n', '<leader>dl', vim.diagnostic.open_float, '[D]iagnostics In [L]ine')

  -- LSP keymaps
  kmap('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  kmap('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  kmap('n', 'gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  kmap('n', '<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
  kmap('n', '<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
  kmap('n', 'gr', vim.lsp.buf.references, '[G]oto [R]eferences')
  kmap('n', 'gt', vim.lsp.buf.type_definition, '[G]oto [T]ype definition')
  kmap('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
  kmap('n', '<c-k>', vim.lsp.buf.signature_help, 'Signature Documenation')
  kmap('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  kmap('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')
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

require('fidget').setup({})
--  vim: set ts=2 sw=2 tw=0 noet ft=lua :
