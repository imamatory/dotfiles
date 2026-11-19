-- Options that deviate from LazyVim defaults (or reproduce old prefs)
local opt = vim.opt

vim.g.autoformat = false

-- Project root = git root. LazyVim's default puts "lsp" first, which picks a
-- sub-package dir in monorepos, and "lua" matches any dir that has a lua/ folder.
vim.g.root_spec = { { ".git" }, "cwd" }

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
