local keymap = vim.keymap.set

keymap("n", "<Leader>r", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>")
keymap("v", "<Leader>pr", "<cmd>lua require('spectre').open_visual()<CR>")

-- keymap("n", "<Leader>b", "<cmd>lua require('telescope.builtin').buffers()<CR>")
keymap("n", "<Leader>h", "<cmd>lua require('telescope.builtin').oldfiles()<CR>")
keymap("n", "<Leader>o", "<cmd>lua require('telescope.builtin').git_files()<CR>")
keymap("n", "<Leader>fo", "<cmd>lua require('telescope.builtin').find_files()<CR>")
keymap("n", "<Leader>ft", "<cmd>lua require('telescope.builtin').filetypes()<CR>")

keymap("n", "<Leader>/", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
keymap("v", "<Leader>/", "<cmd>lua require('telescope.builtin').grep_string()<CR>")
keymap("n", "<Leader>k", "<cmd>lua require('telescope.builtin').grep_string()<CR>")
