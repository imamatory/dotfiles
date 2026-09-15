-- Options that deviate from LazyVim defaults (or reproduce old prefs)
local opt = vim.opt

opt.wrap = false
opt.swapfile = false
opt.inccommand = "nosplit"
opt.spell = false
opt.conceallevel = 0
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.undofile = true
