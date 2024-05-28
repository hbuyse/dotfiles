--- Retrieve the latest version of clangd (absolute path)
---@return string filepath absolute path to the latest version of clangd
local function get_clangd_executable()
  local has_scan, scan = pcall(require, 'plenary.scandir')
  if not has_scan then
    return 'clangd'
  end

  local paths = os.getenv('PATH')
  local list_clangd = {
    'clangd-devel',
    'clangd17',
    'clangd-17',
    'clangd16',
    'clangd-16',
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

  -- gmatch returns an iterator function
  for path in paths:gmatch('([^:]+)') do
    local filepaths = scan.scan_dir(path, { hidden = false, search_pattern = 'clangd.*' })
    for _, clangd in ipairs(list_clangd) do
      for i = #filepaths, 1, -1 do
        local filepath = filepaths[i]
        if filepath == path .. '/' .. clangd then
          return filepath
        end
      end
    end
  end

  return 'clangd'
end

--- Setup mapping when attaching LSP server
---@param client table LSP client
---@param bufnr integer Buffer number
local function lsp_keymaps(client, bufnr)
  --- Wrapper function to set keymap
  ---@param m string|table The modes
  ---@param lhs string Keymap
  ---@param rhs string|function Command called when pressing keymap
  ---@param desc string Keymap description
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

--- Create augroup and autocommands for InlayHints
---@param bufnr integer Buffer number
local function lsp_inlay_hints(bufnr)
  local inlay_hints_group = vim.api.nvim_create_augroup('InlayHints', { clear = false })

  -- Initial inlay hint display.
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'n' or mode == 'v' then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  vim.api.nvim_create_autocmd('InsertEnter', {
    group = inlay_hints_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    end,
  })
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = inlay_hints_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end,
  })
end

--- Callback called when attaching to LSP server
---@param client table LSP client
---@param bufnr integer Buffer number
local function on_attach(client, bufnr)
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

  lsp_keymaps(client, bufnr)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    lsp_document_highlight(bufnr)
    require('nvim-navic').attach(client, bufnr)
  end

  if not vim.lsp.inlay_hint then
    vim.notify('Neovim not supporting', vim.log.levels.INFO, { title = 'InlayHints' })
  elseif not client.server_capabilities.inlayHintProvider then
    vim.notify('Server not supporting', vim.log.levels.INFO, { title = 'InlayHints' })
  else
    lsp_inlay_hints(bufnr)
    vim.notify('Activated', vim.log.levels.INFO, { title = 'InlayHints' })
  end
end

return {
  {
    -- Quickstart configs for Nvim LSP
    'neovim/nvim-lspconfig',
    dependencies = {
      'SmiteshP/nvim-navic',
    },
    config = function()
      -- Override borders globally
      local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, options, ...)
        options = options or {}
        options.border = options.border or border
        return orig_util_open_floating_preview(contents, syntax, options, ...)
      end

      local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end

      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = true, -- Or "if_many"
        },
        signs = true,
        underline = true,
      })

      -- Use a loop to conveniently both setup defined servers and map buffer local keybindings when the language
      -- server attaches
      local servers = {
        bashls = {},
        clangd = {
          cmd = {
            get_clangd_executable(),
            '--background-index',
            '--clang-tidy',
            '--enable-config',
            '-j',
            '4',
          },
        },
        cmake = {},
        cssls = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {},
          },
          on_init = function(client)
            local path = client.workspace_folders[1].name

            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
              return
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  '${3rd}/luv/library',
                  -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            })
          end,
        },
        perlls = {},
        perlnavigator = {
          cmd = { 'perlnavigator' },
          settings = {
            perlnavigator = {
              perlPath = 'perl',
              enableWarnings = true,
              perltidyProfile = '',
              perlcriticProfile = '',
              perlcriticEnabled = true,
            },
          },
        },
        pyright = {},
        robotframework_ls = {},
        rust_analyzer = {
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
        texlab = {},
        yamlls = {},
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      for lsp, conf in pairs(servers) do
        conf.on_attach = on_attach
        conf.capabilities = capabilities

        require('lspconfig')[lsp].setup(conf)
      end
    end,
  },
}
