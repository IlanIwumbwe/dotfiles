-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic sane settings
vim.g.mapleader = " "          -- spacebar as leader key
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.splitright = true      -- vertical splits open to the right
vim.opt.splitbelow = true      -- horizontal splits open below

require("lazy").setup("plugins")

vim.keymap.set('n', '<leader>n', ':bnext<CR>')
vim.keymap.set('n', '<leader>p', ':bprevious<CR>')
vim.keymap.set('n', '<C-x>', ':bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<Esc>', ':noh<CR><Esc>', { desc = 'No highlight' })
