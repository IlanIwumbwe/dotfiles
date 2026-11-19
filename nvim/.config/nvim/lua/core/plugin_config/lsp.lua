vim.lsp.enable({ 'clangd', 'basedpyright', 'rust_analyzer' })
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

