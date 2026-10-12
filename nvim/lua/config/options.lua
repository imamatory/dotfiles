-- Options that deviate from LazyVim defaults (or reproduce old prefs)
local opt = vim.opt

vim.g.autoformat = false

opt.wrap = false
opt.swapfile = false
opt.inccommand = "nosplit"
opt.spell = false
opt.conceallevel = 0
opt.relativenumber = false
-- Registers stay internal; <leader>y/<leader>p/<leader>P are the only bridge to the system clipboard
opt.clipboard = ""
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.undofile = true
