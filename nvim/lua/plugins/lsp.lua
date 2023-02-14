local M = {}

function M.run(use)
    local lsp_servers = {
        'tsserver',
        'ansiblels',
        'bashls',
        'dockerls',
        'elixirls',
        'gopls',
        'grammarly',
        'graphql',
        'omnisharp',
        'pyright',
        'solargraph',
        'sorbet',
        'sqlls',
        'lua_ls',
        'terraformls',
        'tsserver',
        'vimls',
        'yamlls',
        'html',
        'cssls',
        'eslint',
        'jsonls',
        'solargraph',
        'rust_analyzer',
        'stylelint_lsp',
    }
    local dap_servers = {
        'python',
        'codelldb',
        'delve',
    }

    use {
        -- LSP Support
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'mfussenegger/nvim-dap',
        {
            'jayp0521/mason-nvim-dap.nvim',
            requires = { 'williamboman/mason.nvim' },
        },

        {
            'folke/trouble.nvim',
            requires = 'kyazdani42/nvim-web-devicons',
            config = require('plugins.initializers.trouble-nvim')
        },

        -- Autocompletion
        {
            'hrsh7th/nvim-cmp',
            config = require('plugins.initializers.nvim-cmp'),
            requires = {
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
                    requires = {
                        'tzachar/fuzzy.nvim',
                        requires = {
                            'hrsh7th/cmp-buffer',
                            {
                                'nvim-telescope/telescope-fzf-native.nvim',
                                run = 'make'
                            }
                        }
                    }
                }
            }
        },

        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',

        -- Langs
        'simrat39/rust-tools.nvim',
        'leoluz/nvim-dap-go'
    }

    use {
        'jose-elias-alvarez/null-ls.nvim',
        -- 'MunifTanjim/prettier.nvim',
    }

    require('mason').setup()
    require('mason-lspconfig').setup({
        ensure_installed = lsp_servers
    })

    require('mason-nvim-dap').setup({
        ensure_installed = dap_servers
    })


    local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        local bind = vim.keymap.set
        local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
        local event = "BufWritePre" -- or "BufWritePost"
        local async = event == "BufWritePost"

        if client.supports_method("textDocument/formatting") then
            bind("n", "<Leader>l", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format by " .. client.name })

            -- format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd(event, {
                buffer = bufnr,
                group = group,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr, async = async })
                end,
                desc = "[lsp] format on save by " .. client.name,
            })
        end

        if client.supports_method("textDocument/rangeFormatting") then
            bind("x", "<Leader>l", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format by " .. client.name })
        end

        -- bind('n', '<leader>l', vim.lsp.buf.format, { bufnr = vim.api.nvim_get_current_buf() })
        bind('n', 'rn', vim.lsp.buf.rename, opts)
        bind('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        bind('n', 'gd', vim.lsp.buf.definition, opts)
        bind('n', 'K', vim.lsp.buf.hover, opts)
        bind('n', '<leader>i', '<cmd>PyrightOrganizeImports<CR>', opts)
        bind('n', '[g', vim.diagnostic.goto_prev, opts)
        bind('n', ']g', vim.diagnostic.goto_next, opts)
        bind('n', 'gl', vim.lsp.buf.declaration, opts)
        -- bind('n', '<leader>cd', vim.lsp.buf.definition, opts)
        bind('n', 'gm', vim.lsp.buf.implementation, opts)
        bind('n', 'gt', vim.lsp.buf.type_definition, opts)
        bind('n', 'gr', vim.lsp.buf.references, opts)
    end

    local lsp_flags = {
        -- This is the default in Nvim 0.7+
        debounce_text_changes = 150,
    }
    -- require('lspconfig')['pylsp'].setup {
    --   on_attach = on_attach,
    --   flags = lsp_flags,
    --   settings = {
    --     pylsp = {
    --       configurationSources = { 'flake8' },
    --       plugins = {
    --         -- pylint = { enabled = false }, -- , args = {'--rcfile=pylint.ini', '--disable C0301'}
    --         isort = { enabled = true },
    --         -- black = { enabled = true, cache_config = true },
    --         pyls_mypy = {
    --           enabled = true,
    --           live_mode = true,
    --         },
    --         pyls_flake8 = { enabled = true },
    --         -- pydocstyle = { enabled = false },
    --         -- autopep8 = { enabled = false },
    --         -- yapf = { enabled = false },
    --         flake8 = { enabled = true, config = 'setup.cfg' },
    --         -- pycodestyle = { enabled = false },
    --         -- pyflakes = { enabled = false },
    --       }
    --     }
    --   }
    -- }

    require('lspconfig').pyright.setup {
        on_attach = on_attach,
        flags = lsp_flags,
        cmd = { 'poetry', 'run', 'pyright-langserver', '--stdio' }
    }

    require('lspconfig').jsonls.setup {
        on_attach = on_attach,
        flags = lsp_flags,
        init_options = {
            provideFormatter = true,
        }
    }

    require('lspconfig').lua_ls.setup {
        on_attach = on_attach,
        flags = lsp_flags,
    }

    require('lspconfig').tsserver.setup {
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            on_attach(client, bufnr)
        end,
        flags = lsp_flags,
    }
    -- require('prettier').setup({
    --   on_attach = on_attach,
    --   flags = lsp_flags,
    --   bin = 'prettier',
    --   filetypes = {
    --     "css",
    --     "graphql",
    --     "html",
    --     "javascript",
    --     "javascriptreact",
    --     "json",
    --     "markdown",
    --     "scss",
    --     "typescript",
    --     "typescriptreact",
    --     "yaml",
    --   },
    -- })

    require 'lspconfig'.eslint.setup {
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            -- AUTOFIX on save
            -- local group = vim.api.nvim_create_augroup("lsp_eslint_format_on_save", { clear = false })
            -- local event = "BufWritePre"
            -- vim.api.nvim_create_autocmd(event, {
            --   buffer = bufnr,
            --   group = group,
            --   callback = function()
            --     vim.cmd "EslintFixAll"
            --   end,
            --   desc = "[lsp] format on save by " .. client.name,
            -- })

            local opts = { buffer = bufnr }
            local bind = vim.keymap.set
            bind('n', '<leader>l', '<cmd>EslintFixAll<CR>', opts)
        end,
        flags = lsp_flags,
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require 'lspconfig'.cssls.setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
    }

    require 'lspconfig'.stylelint_lsp.setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
        settings = {
            stylelintplus = {
                autoFixOnFormat = true,
                autoFixOnSave = true
            }
        },
        filetypes = {
            'css',
            'less',
            'scss',
            'sugarss',
            'vue',
            'wxss',
        },
    }

    require 'lspconfig'.gopls.setup {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
            },
        }
    }

    require 'lspconfig'.rust_analyzer.setup {
        on_attach = on_attach,
        flags = lsp_flags,
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                },
                completion = {
                    postfix = {
                        enable = false,
                    },
                },
            },
        },
    }
    require 'dap-go'.setup()

    -- define line number hl for lines with Lsp errors
    vim.cmd [[sign define DiagnosticSignWarn text= texthl= numhl=DiagnosticSignWarn linehl=]]
    vim.cmd [[sign define DiagnosticSignError text= texthl= numhl=DiagnosticSignError linehl=]]

    -- set global diagnostic config
    vim.diagnostic.config({
        signs = true,
        underline = true,
        virtual_text = { prefix = '<' },
        float = { scope = 'line', border = 'rounded', focusable = false },
        severity_sort = true
    })

    local rt = require('rust-tools')

    rt.setup({
        server = {
            on_attach = function(_, bufnr)
                -- Hover actions
                -- vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
                -- -- Code action groups
                -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            end,
        },
    })

    local null_ls = require('null-ls')
    null_ls.setup {
        sources = {
            null_ls.builtins.diagnostics.flake8.with({
                command = 'poetry run flake8'
            })
        }
    }

    -- add borders to some floating things
    -- vim.lsp.handlers['textDocument/hover'] = lsp.with(vim.lsp.handlers.hover, { border = 'rounded', focusable = false })
    -- vim.lsp.handlers['textDocument/signatureHelp'] =
    -- lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded', focusable = false })

    -- lsp.use('pyright', {
    --   flags = {
    --     allow_incremental_sync = true,
    --     debounce_text_changes = 200,
    --   },
    --   settings = {
    --     python = {
    --       analysis = {
    --         extraPaths = { 'cc' },
    --         autoSearchPaths = true,
    --         useLibraryCodeForTypes = true,
    --         diagnosticMode = 'workspace',
    --       }
    --     }
    --   }
    -- })

    -- local cmp = require('cmp')
    -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
    -- local sources = lsp.defaults.cmp_sources()
    -- table.insert(sources, { name = 'nvim_lsp_signature_help' })

    -- local cmp_config = lsp.defaults.cmp_config({
    --   sources = sources,
    --   mapping = {
    --     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    --     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    --   },
    -- })

    -- cmp.setup(cmp_config)
end

return M
