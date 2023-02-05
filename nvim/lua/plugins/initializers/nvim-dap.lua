return function()
  local dap = require('dap')
  vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

  vim.keymap.set('n', '<leader>dc', function() dap.continue() end)
  vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
  vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
  vim.keymap.set('n', '<leader>db', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
  vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
end
