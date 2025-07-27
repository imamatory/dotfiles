local lsp_servers = {
  'ts_ls',
  'ansiblels',
  'bashls',
  'dockerls',
  'elixirls',
  'gopls',
  'pyright',
  'sqlls',
  'lua_ls',
  'terraformls',
  'vimls',
  'yamlls',
  'html',
  'cssls',
  'eslint',
  'jsonls',
  'solargraph',
  'rust_analyzer',
  'stylelint_lsp',
  'helm_ls',
}
local dap_servers = {
  'python',
  'codelldb',
  'delve',
}

return {
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        local bind = vim.keymap.set
        local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
        local event = "BufWritePre"
        local async = event == "BufWritePost"

        if client.supports_method("textDocument/formatting") then
          bind("n", "<Leader>l", function()
            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
          end, { buffer = bufnr, desc = "[lsp] format by " .. client.name })

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

        bind('n', 'rn', vim.lsp.buf.rename, opts)
        bind('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        bind('n', 'gd', vim.lsp.buf.definition, opts)
        bind('n', 'K', vim.lsp.buf.hover, opts)
        bind('n', '<leader>i', '<cmd>PyrightOrganizeImports<CR>', opts)
        bind('n', '[g', vim.diagnostic.goto_prev, opts)
        bind('n', ']g', vim.diagnostic.goto_next, opts)
        bind('n', 'gl', vim.lsp.buf.declaration, opts)
        bind('n', 'gm', vim.lsp.buf.implementation, opts)
        bind('n', 'gt', vim.lsp.buf.type_definition, opts)
        bind('n', 'gr', vim.lsp.buf.references, opts)
      end

      local lsp_flags = {
        debounce_text_changes = 150,
      }

      -- Set up LSP servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Python
      require('lspconfig').pyright.setup {
        on_attach = on_attach,
        flags = lsp_flags,
        cmd = { 'poetry', 'run', 'pyright-langserver', '--stdio' }
      }

      -- JSON
      require('lspconfig').jsonls.setup {
        on_attach = on_attach,
        flags = lsp_flags,
        init_options = {
          provideFormatter = true,
        }
      }

      -- Lua
      require('lspconfig').lua_ls.setup {
        on_attach = on_attach,
        flags = lsp_flags,
      }

      -- CSS
      require('lspconfig').cssls.setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
      }

      -- Stylelint
      require('lspconfig').stylelint_lsp.setup {
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

      -- Go
      require('lspconfig').gopls.setup {
        on_attach = on_attach,
        flags = lsp_flags,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        }
      }

      -- Rust
      require('lspconfig').rust_analyzer.setup {
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

      -- Configure diagnostics
      vim.diagnostic.config({
        signs = true,
        underline = true,
        virtual_text = { prefix = '<' },
        float = { scope = 'line', border = 'rounded', focusable = false },
        severity_sort = true
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = lsp_servers,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require('dap')
      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

      vim.keymap.set('n', '<leader>dc', function() dap.continue() end)
      vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
      vim.keymap.set('n', '<leader>dl', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    end,
  },
  {
    "jayp0521/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = dap_servers,
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        auto_close = true,
        lsp_diagnostic_signs = true,
        mode = "document_diagnostics"
      })
    end,
  },

  -- Language-specific tools
  'simrat39/rust-tools.nvim',
  'leoluz/nvim-dap-go',
  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'MunifTanjim/prettier.nvim' },
    config = function()
      require("prettier").setup({
        bin = 'prettier',
        filetypes = {
          "css",
          "graphql",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "markdown",
          "scss",
          "typescript",
          "typescriptreact",
          "yaml",
        },
      })
    end,
  },
}
