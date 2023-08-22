local has_lsp, lspconfig = pcall(require, 'lspconfig')

-- If lspconfig is not present, return
if not has_lsp then
  return
end

-- Set some key mappings
local function lsp_keymaps(client, bufnr)
  local kmap = function(m, lhs, rhs, desc)
    local opts = { remap = false, silent = true, buffer = bufnr, desc = desc }
    vim.keymap.set(m, lhs, rhs, opts)
  end

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
  kmap('n', '<c-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  kmap('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  kmap('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')
end

local function lsp_document_highlight(bufnr)
  local gid = vim.api.nvim_create_augroup('LSPDocumentHighlight', { clear = false })
  vim.api.nvim_clear_autocmds({
    group = gid,
    buffer = bufnr,
  })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = gid,
    desc = 'Highlight document using LSP server capabilities',
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = gid,
    desc = 'Clear document highlights using LSP server capabilities',
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  lsp_keymaps(client, bufnr)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    lsp_document_highlight(bufnr)
  end

  -- Override borders globally
  local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, options, ...)
    options = options or {}
    options.border = options.border or border
    return orig_util_open_floating_preview(contents, syntax, options, ...)
  end

  local nvim_version = vim.version()
  if nvim_version.major >= 0 and nvim_version.minor >= 6 then
    -- Not working with Neovim 0.5
    local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = 'כֿ ' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end
  end
end

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = 'always', -- Or "if_many"
  },
  signs = true,
  underline = true,
})

local function get_clangd_executable()
  local has_scan, scan = pcall(require, 'plenary.scandir')
  if not has_scan then
    return 'clangd'
  end

  local paths = os.getenv('PATH')
  local list_clangd = {
    'clangd-devel',
    'clangd15',
    'clangd-15',
    'clangd14',
    'clangd-14',
    'clangd13',
    'clangd-13',
    'clangd12',
    'clangd-12',
    'clangd11',
    'clangd-11',
    'clangd10',
    'clangd-10',
    'clangd90',
    'clangd-9',
    'clangd',
  }

  for path in string.gmatch(paths, '([^:]+)') do
    local filepaths = scan.scan_dir(path, { hidden = false, search_pattern = 'clangd.*' })
    for _, clangd in ipairs(list_clangd) do
      for _, filepath in ipairs(filepaths) do
        if filepath == path .. '/' .. clangd then
          return filepath
        end
      end
    end
  end

  return 'clangd'
end

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

-- Use a loop to conveniently both setup defined servers and map buffer local keybindings when the language server attaches
local servers = {
  bashls = {
    on_attach = on_attach,
  },
  clangd = {
    cmd = { get_clangd_executable(), '--background-index', '--clang-tidy', '--enable-config' },
    on_attach = on_attach,
  },
  cmake = {
    on_attach = on_attach,
  },
  cssls = {
    on_attach = on_attach,
  },
  jsonls = {
    on_attach = on_attach,
  },
  lua_ls = {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            library = { vim.env.VIMRUNTIME },
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
        })

        client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
        vim.notify(path)
      end
      return true
    end,
    on_attach = on_attach,
  },
  perlls = {
    on_attach = on_attach,
  },
  pyright = {
    on_attach = on_attach,
  },
  robotframework_ls = {
    on_attach = on_attach,
  },
  rust_analyzer = {
    on_attach = on_attach,
    -- From https://rust-analyzer.github.io/manual.html#nvim-lsp
    settings = {
      ['rust-analyzer'] = {
        assist = {
          importGranularity = 'module',
          importPrefix = 'by_self',
        },
        cargo = {
          loadOutDirsFromCheck = true,
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
  texlab = {
    on_attach = on_attach,
  },
  yamlls = {
    on_attach = on_attach,
  },
}

for lsp, conf in pairs(servers) do
  lspconfig[lsp].setup(conf)
end
--  vim: set ts=2 sw=2 tw=0 noet ft=lua :
