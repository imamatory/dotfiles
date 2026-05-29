require('globals')
require('config.lazy')
require('mappings')

-- Disable Neovim built-in rust.vim PreWrite autocmd
-- It causes E5677 EPIPE on large Rust files (Neovim 0.12.2 bug)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.api.nvim_create_augroup("rust.vim.PreWrite", { clear = true })
  end,
})
