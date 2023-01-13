local M = {}

function M.run(use)
  local servers = {
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
    'sumneko_lua',
    'stylelint_lsp',
    'terraformls',
    'vimls',
    'yamlls',
    'html',
    'cssls',
    'eslint',
    'jsonls',
    'solargraph',
    'sumneko_lua',
  }

  use {
    -- LSP Support
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
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
  }

  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = servers
  })


  local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }
    local bind = vim.keymap.set

    bind('n', '<leader>l', vim.lsp.buf.format, opts)
    bind('n', 'rn', vim.lsp.buf.rename, opts)
    bind('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    bind('n', 'gd', vim.lsp.buf.definition, opts)
    bind('n', 'K', vim.lsp.buf.hover, opts)
    bind('n', '<leader>i', '<cmd>PyrightOrganizeImports<CR>', opts)
    bind('n', '[g', vim.diagnostic.goto_prev, opts)
    bind('n', ']g', vim.diagnostic.goto_next, opts)
  end

  local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  }
  require('lspconfig')['pylsp'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
      pylsp = {
        configurationSources = { 'flake8' },
        plugins = {
          -- pylint = { enabled = false }, -- , args = {'--rcfile=pylint.ini', '--disable C0301'}
          isort = { enabled = true },
          -- black = { enabled = true, cache_config = true },
          pyls_mypy = {
            enabled = true,
            live_mode = true,
          },
          pyls_flake8 = { enabled = true },
          -- pydocstyle = { enabled = false },
          -- autopep8 = { enabled = false },
          -- yapf = { enabled = false },
          flake8 = { enabled = true, config = 'setup.cfg' },
          -- pycodestyle = { enabled = false },
          -- pyflakes = { enabled = false },
        }
      }
    }
  }

  require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
  }

  require('lspconfig')['jsonls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    init_options = {
      provideFormatter = true,
    }
  }
  require'lspconfig'.sumneko_lua.setup{}

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
