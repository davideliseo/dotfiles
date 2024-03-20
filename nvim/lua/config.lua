vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.cursorline = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.mouse = nil
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.wrap = false

vim.o.timeout = true
vim.o.timeoutlen = 500

vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', { silent = true }) -- disable space key (used for leader)
vim.keymap.set('n', '<Esc>', ':nohl<Cr>', { silent = true }) -- press escape to nohl
vim.keymap.set('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>', { noremap = true }) -- replace visual selection
