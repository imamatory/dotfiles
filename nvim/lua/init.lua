-- https://github.com/nanotee/nvim-lua-guide#tips-2
function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

require('plugins')

vim.cmd("au BufWritePost **/nvim/lua/plugins/init.lua lua reload()")
vim.cmd("au BufWritePost **/nvim/lua/plugins/init.lua PackerCompile")
