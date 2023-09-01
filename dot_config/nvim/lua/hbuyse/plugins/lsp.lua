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

local function print_table(node)
  -- to make output beautiful
  local function tab(amt)
    local str = ''
    for i = 1, amt do
      str = str .. '\t'
    end
    return str
  end

  local cache, stack, output = {}, {}, {}
  local depth = 1
  local output_str = '{\n'

  while true do
    local size = 0
    for k, v in pairs(node) do
      size = size + 1
    end

    local cur_index = 1
    for k, v in pairs(node) do
      if (cache[node] == nil) or (cur_index >= cache[node]) then
        if string.find(output_str, '}', output_str:len()) then
          output_str = output_str .. ',\n'
        elseif not (string.find(output_str, '\n', output_str:len())) then
          output_str = output_str .. '\n'
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output, output_str)
        output_str = ''

        local key
        if type(k) == 'number' or type(k) == 'boolean' then
          key = '[' .. tostring(k) .. ']'
        else
          key = "['" .. tostring(k) .. "']"
        end

        if type(v) == 'number' or type(v) == 'boolean' then
          output_str = output_str .. tab(depth) .. key .. ' = ' .. tostring(v)
        elseif type(v) == 'table' then
          output_str = output_str .. tab(depth) .. key .. ' = {\n'
          table.insert(stack, node)
          table.insert(stack, v)
          cache[node] = cur_index + 1
          break
        else
          output_str = output_str .. tab(depth) .. key .. " = '" .. tostring(v) .. "'"
        end

        if cur_index == size then
          output_str = output_str .. '\n' .. tab(depth - 1) .. '}'
        else
          output_str = output_str .. ','
        end
      else
        -- close the table
        if cur_index == size then
          output_str = output_str .. '\n' .. tab(depth - 1) .. '}'
        end
      end

      cur_index = cur_index + 1
    end

    if #stack > 0 then
      node = stack[#stack]
      stack[#stack] = nil
      depth = cache[node] == nil and depth + 1 or depth - 1
    else
      break
    end
  end

  -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
  table.insert(output, output_str)
  output_str = table.concat(output)

  print(output_str)
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

local function lsp_inlay_hints(bufnr)
  local inlay_hints_group = vim.api.nvim_create_augroup('InlayHints', { clear = false })

  -- Initial inlay hint display.
  local mode = vim.api.nvim_get_mode().mode
  vim.lsp.inlay_hint(bufnr, mode == 'n' or mode == 'v')

  vim.api.nvim_create_autocmd('InsertEnter', {
    group = inlay_hints_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.inlay_hint(bufnr, false)
    end,
  })
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = inlay_hints_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.inlay_hint(bufnr, true)
    end,
  })
end

local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  lsp_keymaps(client, bufnr)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    lsp_document_highlight(bufnr)
  end

  if client.server_capabilities.inlayHintProvider and not vim.version.lt(vim.version(), { 0, 10, 0 }) then
    lsp_inlay_hints(bufnr)
    vim.notify('Activated', vim.log.levels.INFO, { title = 'InlayHints' })
  else
    vim.notify('Not activated', vim.log.levels.INFO, { title = 'InlayHints' })
  end
end

return {
  {
    -- Quickstart configs for Nvim LSP
    'neovim/nvim-lspconfig',
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
          source = 'always', -- Or "if_many"
        },
        signs = true,
        underline = true,
      })

      -- Use a loop to conveniently both setup defined servers and map buffer local keybindings when the language server attaches
      local servers = {
        bashls = {},
        clangd = {
          cmd = {
            get_clangd_executable(),
            '--background-index',
            '--clang-tidy',
            '--enable-config',
          },
        },
        cmake = {},
        cssls = {},
        jsonls = {},
        lua_ls = {
          on_init = function(client)
            local path = client.workspace_folders[1].name
            local overrides = nil
            if
              (not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc'))
              or (path == os.getenv('HOME') .. '/.config/nvim')
            then
              overrides = {
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
              }
            end

            -- Update lsp server config
            if overrides then
              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, overrides)
              client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
            end

            return true
          end,
        },
        perlls = {},
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
