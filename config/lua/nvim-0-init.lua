vim.g.mapleader = " "
vim.o.tabstop=2
vim.o.softtabstop=2
vim.o.shiftwidth=2
vim.o.expandtab = true
vim.o.smartindent=true
vim.o.number=true
vim.cmd('colorscheme 256_noir')
vim.o.wrap=true
vim.o.swapfile=false
vim.o.history=500
vim.o.cursorline=true
vim.o.scrolloff=20
vim.o.filetype = "on"

-- Ensure 'nvim-lspconfig' is installed
require'lspconfig'.rust_analyzer.setup{}

