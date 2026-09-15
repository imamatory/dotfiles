-- vim-test mappings live in plugins/test.lua (spec keys), so nothing else here beyond LazyVim defaults.

local map = vim.keymap.set

-- Match old muscle memory: save with <Leader>w was conflicting with LazyVim's window prefix —
-- keep Ctrl-s and :w as the savers, no remap needed.
map({ "n", "v" }, "<C-s>", ":w<cr>", { silent = true })
map("n", "<leader>w", ":w<cr>", { desc = "Save buffer", silent = true })
