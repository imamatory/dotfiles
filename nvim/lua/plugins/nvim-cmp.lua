-- Autocompletion
return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'onsails/lspkind-nvim',
        'octaltree/cmp-look',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-emoji',
        'hrsh7th/cmp-cmdline',
        {
            'tzachar/cmp-fuzzy-buffer',
            dependencies = {
                'tzachar/fuzzy.nvim',
                'hrsh7th/cmp-buffer',
                { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
            }
        }
    },
    config = function()
        local cmp = require 'cmp'

        cmp.setup({
            completion = { completeopt = 'menu,menuone,noinsert' },
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            window = {
                completion = {
                    border = {
                        '╭',
                        '─',
                        '╮',
                        '│',
                        '╯',
                        '─',
                        '╰',
                        '│'
                    },
                    winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
                    scrollbar = '║'
                },
                documentation = {
                    border = {
                        '─',
                        '─',
                        '╮',
                        '│',
                        '╯',
                        '─',
                        '─',
                        '→'
                    }
                }
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs( -4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = {
                { name = 'nvim_lsp', keyword_length = 1, max_item_count = 20 },
                { name = 'buffer',   keyword_length = 2, max_item_count = 10 },
                { name = 'path',     priority = 1 }
            },
        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
            }, {
                { name = 'buffer' },
            })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            })
        })
    end
}