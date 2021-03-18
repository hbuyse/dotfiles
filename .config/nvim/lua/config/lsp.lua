local has_lsp, lspconfig = pcall(require, 'lspconfig')
local has_completion, completion = pcall(require, 'completion')

-- If lspconfig is not present, return
if not has_lsp then
  return
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  buf_set_option('completeopt', 'menuone,noinsert,noselect')

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

  completion.attach(client, bufnr)
end

vim.api.nvim_set_var('completion_enable_auto_popup', 0)
vim.api.nvim_set_var('completion_matching_strategy_list', {'exact', 'substring', 'fuzzy'})

-- Use a loop to conveniently both setup defined servers and map buffer local keybindings when the language server attaches
local servers = {
  ccls = {
    init_options = {
      compilationDatabaseDirectory = "build"
    },
    on_attach = on_attach
  },
  pyright = {
    on_attach = completion.on_attach
  },
  bashls = {
    on_attach = completion.on_attach
  }
}
for lsp, conf in pairs(servers) do
  lspconfig[lsp].setup { lspconf }
end
-- vim: set ts=2 sw=2 tw=0 et ft=lua :
