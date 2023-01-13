_G.vim = vim
_G.g = vim.g
_G.cmd = vim.cmd
_G.fn = vim.fn
_G.lsp = vim.lsp

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

function _G.merge(dest, source, strategy)
    return vim.tbl_extend(strategy or 'keep', source or {}, dest)
end

function _G.au(event, filetype, action)
    vim.cmd('au' .. ' ' .. event .. ' ' .. filetype .. ' ' .. action)
end

function _G.map(mode, lhs, rhs, opts)

    local finalRhs = ''
    local callback = nil
    if type(rhs) == 'string' then
        finalRhs = rhs
    else
        callback = rhs
    end

    opts = vim.tbl_extend('keep', opts or {}, {
        noremap = true,
        silent = true,
        expr = false,
        callback = callback
    })

    vim.api.nvim_set_keymap(mode, lhs, finalRhs, opts)
end

function _G.hi(group, options)
    --  vim.cmd("hi " .. group .. " " .. "cterm=" .. (options.cterm or "none") ..
    --  " " .. "ctermfg=" .. (options.ctermfg or "none") .. " " ..
    --  "ctermbg=" .. (options.ctermbg or "none") .. " " .. "gui=" ..
    --  (options.gui or "none") .. " " .. "guifg=" ..
    --  (options.guifg or "none") .. " " .. "guibg=" ..
    --  (options.guibg or "none"))
    local style = options.style and 'gui=' .. options.style or 'gui=NONE'
    local fg = options.fg and 'guifg=' .. options.fg or 'guifg=NONE'
    local bg = options.bg and 'guibg=' .. options.bg or 'guibg=NONE'
    local sp = options.sp and 'guisp=' .. options.sp or ''
    local blend = options.blend and 'blend=' .. options.blend or ''
    local hl =
        'highlight ' .. group .. ' ' .. style .. ' ' .. fg .. ' ' .. bg .. ' ' ..
            sp .. ' ' .. blend
    vim.cmd(hl)
end

function _G.ReloadConfig()
    local hls_status = vim.v.hlsearch
    for name,_ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.fn.stdpath('config') .. '/lua/init.lua')
    if hls_status == 0 then
        vim.opt.hlsearch = false
    end
end
