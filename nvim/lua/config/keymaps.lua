-- vim-test mappings live in plugins/test.lua (spec keys), so nothing else here beyond LazyVim defaults.

local map = vim.keymap.set

-- Match old muscle memory: save with <Leader>w was conflicting with LazyVim's window prefix —
-- keep Ctrl-s and :w as the savers, no remap needed.
map({ "n", "v" }, "<C-s>", ":w<cr>", { silent = true })
map("n", "<leader>w", ":w<cr>", { desc = "Save buffer", silent = true })

-- Replace all occurrences of the last search (set by * or #), restoring the
-- old <leader>fr flow; <leader>fr itself is taken by LazyVim's Recent picker.
map("n", "<leader>rf", ":%s///g<Left><Left>", { desc = "Replace last search (buffer)", silent = true })
map("v", "<leader>rf", ":s///g<Left><Left>", { desc = "Replace last search (selection)", silent = true })

-- System clipboard only via explicit <leader>y / <leader>p / <leader>P; internal registers stay untouched.
map("v", "<leader>y", '"+y', { desc = "Yank to system clipboard", silent = true })
map("n", "<leader>y", '"+', { desc = "Yank operator to system clipboard", remap = true, silent = true })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard", silent = true })
map("n", "<leader>P", '"+P', { desc = "Paste system clipboard before cursor", silent = true })
