require('globals')

require('config.lazy')
vim.cmd('au BufWritePost **/nvim/lua/**.lua lua ReloadConfig()')

require('plugins')
require('mappings')
