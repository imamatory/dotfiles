local keymap = vim.keymap.set

keymap("n", "<Leader>r", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>")
keymap("v", "<Leader>pr", "<cmd>lua require('spectre').open_visual()<CR>")
