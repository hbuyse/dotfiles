local has_lsp, lspconfig = pcall(require, 'lspconfig')
local has_telescope, _ = pcall(require, 'telescope')
local has_scan, scan = pcall(require, 'plenary.scandir')
local hostname = require('hbuyse.hostname')

-- If lspconfig is not present, return
if not has_lsp then
  return
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Diagnostics keymaps
  buf_set_keymap('n', '<leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>ds', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

  -- LSP keymaps
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- Telescope
  if has_telescope then
    buf_set_keymap('n', '<leader>fr', '<cmd>lua require"telescope.builtin".lsp_references()<CR>', opts)
    buf_set_keymap('n', '<leader>fd', '<cmd>lua require"telescope.builtin".diagnostics()<CR>', opts)
    buf_set_keymap('n', '<leader>fdd', '<cmd>lua require"telescope.builtin".diagnostics({bufnr=0})<CR>', opts)
    buf_set_keymap('n', '<leader>fc', '<cmd>lua require"telescope.builtin".lsp_code_actions()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    local gid = vim.api.nvim_create_augroup('LSPDocumentHighlight', {})
    vim.api.nvim_create_autocmd('CursorHold', {
      group = gid,
      desc = 'Highlight document using LSP server capabilities',
      buffer = vim.api.nvim_get_current_buf(),
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = gid,
      desc = 'Clear document highlights using LSP server capabilities',
      buffer = vim.api.nvim_get_current_buf(),
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end

  -- Override borders globally
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, options, ...)
    local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
    options = options or {}
    options.border = options.border or border
    return orig_util_open_floating_preview(contents, syntax, options, ...)
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      source = 'always', -- Or "if_many"
    },
    signs = true,
    underline = true,
  })

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

local function prepare_sumneko_lua_language_server()
  -- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
  local sumneko_root_path = ''
  local sumneko_binary = ''
  local my_hostname = hostname.getHostname()

  if my_hostname == nil or my_hostname == 'freebsd' then
    return nil
  elseif my_hostname == 'T480' then
    sumneko_root_path = '/usr/lib/lua-language-server'
    sumneko_binary = sumneko_root_path .. '/bin/lua-language-server'
  else
    sumneko_root_path = os.getenv('HOME') .. '/.local/lua-language-server'
    sumneko_binary = sumneko_root_path .. '/bin/lua-language-server'
  end

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  return {
    cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
    on_attach = on_attach,
  }
end

local function get_cland_executable()
  if not has_scan then
    return 'clangd'
  end

  local paths = os.getenv('PATH')
  local list_clangd = {
    'clangd-devel',
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

-- Use a loop to conveniently both setup defined servers and map buffer local keybindings when the language server attaches
local servers = {
  clangd = {
    cmd = { get_cland_executable(), '--background-index', '--clang-tidy', '--enable-config' },
    on_attach = on_attach,
  },
  pyright = {
    on_attach = on_attach,
  },
  bashls = {
    on_attach = on_attach,
  },
  sumneko_lua = prepare_sumneko_lua_language_server(),
  perlls = {
    on_attach = on_attach,
  },
  texlab = {
    on_attach = on_attach,
  },
  jsonls = {
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
}

for lsp, conf in pairs(servers) do
  lspconfig[lsp].setup(conf)
end
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
