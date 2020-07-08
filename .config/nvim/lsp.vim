let g:completion_enable_auto_popup = 0
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

set completeopt=menuone,noinsert,noselect

nnoremap gD :lua vim.lsp.buf.declaration()<CR>', opts)
nnoremap gd :lua vim.lsp.buf.definition()<CR>', opts)
nnoremap K :lua vim.lsp.buf.hover()<CR>', opts)
nnoremap gi :lua vim.lsp.buf.implementation()<CR>', opts)
nnoremap <C-k> :lua vim.lsp.buf.signature_help()<CR>', opts)
nnoremap <space>D :lua vim.lsp.buf.type_definition()<CR>', opts)
nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>', opts)
nnoremap gr :lua vim.lsp.buf.references()<CR>', opts)
nnoremap <space>e :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
nnoremap [d :lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
nnoremap ]d :lua vim.lsp.diagnostic.goto_next()<CR>', opts)
nnoremap <space>q :lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

hi LspReferenceRead cterm=bold
hi LspReferenceText cterm=bold
hi LspReferenceWrite cterm=bold
augroup lsp_document_highlight
    autocmd!
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
augroup END

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy' ]
lua require'lspconfig'.ccls.setup { on_attach = require'completion'.on_attach }
lua require'lspconfig'.pyright.setup { on_attach = require'completion'.on_attach }
lua require'lspconfig'.rls.setup { on_attach = require'completion'.on_attach }
