return function()
    N = require('Navigator').setup {
            auto_save = nil,
            disable_on_zoom = false
        }
    vim.api.nvim_set_keymap('', '<c-h>', '<CMD>lua require("Navigator").left()<CR>', {})
    vim.api.nvim_set_keymap('', '<c-j>', '<CMD>lua require("Navigator").down()<CR>', {})
    vim.api.nvim_set_keymap('', '<c-k>', '<CMD>lua require("Navigator").up()<CR>', {})
    vim.api.nvim_set_keymap('', '<c-l>', '<CMD>lua require("Navigator").right()<CR>', {})

    return N
end
