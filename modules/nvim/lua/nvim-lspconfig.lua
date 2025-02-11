
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({})
lspconfig.nil_ls.setup({})
lspconfig.cssls.setup({
    capabilities = require('cmp_nvim_lsp').default_capabilities()
})
