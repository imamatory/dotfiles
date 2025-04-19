-- local fuzzyfinder = {
--   { 'junegunn/fzf.vim' },
--   {
--     'nvim-telescope/telescope.nvim',
--     branch = '0.1.x',
--     requires = { { 'nvim-lua/plenary.nvim' } },
--     config = require('plugins.initializers.telescope-nvim')
--   },
-- }

local fuzzyfinder = {
  'ibhagwan/fzf-lua',
  requires = { 'nvim-tree/nvim-web-devicons' },
  config = require('plugins.initializers.fzf-lua'),
}

local treesitter = {
  'nvim-treesitter/nvim-treesitter',
  config = require('plugins.initializers.nvim-treesitter'),
  run = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
}

return {
  require("plugins.core"),
  require("plugins.dev"),
  require("plugins.lsp"),
}
