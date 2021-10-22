local has_lsp, lspconfig = pcall(require, 'lspconfig')
local has_telescope, _ = pcall(require, 'telescope')

-- If lspconfig is not present, return
if not has_lsp then
  return
end

-- Add border
vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#4F4945]]
vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=#EBDBB2 guibg=#4F4945]]
local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│'}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- completeopt (:help completopt)
  -- menuone   Use the popup menu also when there is only one match.
  --           Useful when there is additional information about the
  --           match, e.g., what file it comes from.
  -- noinsert  Do not insert any text for a match until the user selects
  --           a match from the menu. Only works in combination with
  --           "menu" or "menuone". No effect if "longest" is present.
  -- noselect  Do not select a match in the menu, force the user to
  --           select one from the menu. Only works in combination with
  --           "menu" or "menuone".
  -- buf_set_option('completeopt', 'menuone,noinsert,noselect')

  local opts = { noremap=true, silent=true }

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Diagnostics keymaps
  buf_set_keymap('n', '<leader>dn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>dp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>ds', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

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
    buf_set_keymap('n', '<leader>ft', '<cmd>lua require"telescope.builtin".lsp_document_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<leader>fc', '<cmd>lua require"telescope.builtin".lsp_code_actions()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
  })

  -- Not working with Neovim 0.5
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

end

local function prepare_sumneko_lua_language_server()
  local system_name
  if vim.fn.has("mac") == 1 then
    system_name = "macOS"
  elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
  elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
  else
    return {}
  end

  -- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
  local sumneko_root_path = '/opt/lua-language-server'
  local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  return {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
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
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        }
      }
    },
    on_attach = on_attach
  }
end

-- Use a loop to conveniently both setup defined servers and map buffer local keybindings when the language server attaches
local servers = {
  clangd = {
    cmd = { 'clangd-12', '--background-index', '--clang-tidy', '--enable-config' },
    on_attach = on_attach
  },
  pyright = {
    on_attach = on_attach
  },
  bashls = {
    on_attach = on_attach
  },
  sumneko_lua = prepare_sumneko_lua_language_server(),
  perlls = {
    on_attach = on_attach
  },
  texlab = {
    on_attach = on_attach
  }
}

for lsp, conf in pairs(servers) do
  lspconfig[lsp].setup(conf)
end
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
