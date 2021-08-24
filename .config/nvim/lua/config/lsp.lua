local has_lsp, lspconfig = pcall(require, 'lspconfig')
local has_completion, completion = pcall(require, 'completion')
local has_snippets, snippets = pcall(require, 'snippets')

-- If lspconfig is not present, return
if not has_lsp then
  return
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  buf_set_option('completeopt', 'menuone,noinsert,noselect')

  local opts = { noremap=true, silent=true }

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  -- Attach the completion if the plugin completion-nvim has been found
  if has_completion then
    completion.attach(client, bufnr)
  end

  if has_snippets then
    -- <c-k> will either expand the current snippet at the word or try to jump to
    -- the next position for the snippet.
    buf_set_keymap("i", "<c-k>", "<cmd>lua return require'snippets'.expand_or_advance(1)<CR>", opts)

    -- <c-j> will jump backwards to the previous field.V
    -- If you jump before the first field, it will cancel the snippet.
    buf_set_keymap("i", "<c-j>", "<cmd>lua return require'snippets'.advance_snippet(-1)<CR>", opts)
  end
end


local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- If PopUpMenuVISIBLE, we can use the Enter key to validate instead of <C-y>
function _G.smart_enter()
  return vim.fn.pumvisible() == 1 and t('<C-y>') or t('<CR>')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Load completion config if the plugin completion-nvim has been found
if has_completion then
  vim.api.nvim_set_var('completion_enable_auto_popup', 0)
  vim.api.nvim_set_var('completion_matching_strategy_list', {'exact', 'substring', 'fuzzy', 'all'})
  vim.api.nvim_set_keymap('i', '<CR>', 'v:lua.smart_enter()', {expr = true, noremap = true})
end

-- Load snippet only if snippets.nvim has been found
if has_snippets then
  vim.api.nvim_set_var('completion_enable_snippet', 'snippets.nvim')
  vim.api.nvim_set_var('completion_confirm_key', '<CR>')
  capabilities.textDocument.completion.completionItem.snippetSupport = true;
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
    }
  }
end

-- Use a loop to conveniently both setup defined servers and map buffer local keybindings when the language server attaches
local servers = {
  ccls = {
    init_options = {
      compilationDatabaseDirectory = "build"
    },
    on_attach = on_attach,
    capabilities = capabilities
  },
  pyright = {
    on_attach = on_attach
  },
  bashls = {
    on_attach = on_attach
  },
  sumneko_lua = prepare_sumneko_lua_language_server(),
}

for lsp, conf in pairs(servers) do
  if conf['cmd'] ~= nil then
    lspconfig[lsp].setup(conf)
  else
    lspconfig[lsp].setup { conf }
  end
end
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
