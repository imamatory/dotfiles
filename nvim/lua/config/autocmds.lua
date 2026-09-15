-- Spell: never enable, including on text/markdown filetypes where LazyVim turns it on
vim.opt.spell = false
vim.api.nvim_clear_autocmds({ group = "lazyvim_wrap_spell" })
