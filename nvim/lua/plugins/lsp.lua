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
  'helm_ls',
}
local dap_servers = {
  'python',
  'codelldb',
  'delve',
}

local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr }
  local bind = vim.keymap.set

  bind('n', 'rn', vim.lsp.buf.rename, opts)
  bind('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  bind('n', 'gd', vim.lsp.buf.definition, opts)
  bind('n', 'K', vim.lsp.buf.hover, opts)
  bind('n', '[g', vim.diagnostic.goto_prev, opts)
  bind('n', ']g', vim.diagnostic.goto_next, opts)
  bind('n', 'gl', vim.lsp.buf.declaration, opts)
  bind('n', 'gm', vim.lsp.buf.implementation, opts)
  bind('n', 'gt', vim.lsp.buf.type_definition, opts)
  bind('n', 'gr', vim.lsp.buf.references, opts)
end

local function detect_python_path(root_dir)
  if not root_dir then return end

  -- Try .venv in project root (uv / python -m venv default)
  local dot_venv = root_dir .. '/.venv/bin/python'
  if vim.fn.executable(dot_venv) == 1 then
    return dot_venv
  end

  -- Try poetry
  local poetry_env = vim.fn.system('cd ' .. vim.fn.shellescape(root_dir) .. ' && poetry env info -p 2>/dev/null')
  if vim.v.shell_error == 0 and poetry_env ~= '' then
    local poetry_python = vim.fn.trim(poetry_env) .. '/bin/python'
    if vim.fn.executable(poetry_python) == 1 then
      return poetry_python
    end
  end

  return nil
end

return {
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lsp_flags = {
        debounce_text_changes = 150,
      }

      -- Set up LSP servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Python
      vim.lsp.config('pyright', {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)

          vim.keymap.set('n', '<leader>i', function()
            local params = {
              command = 'pyright.organizeimports',
              arguments = { vim.uri_from_bufnr(bufnr) },
            }
            client.request('workspace/executeCommand', params, nil, bufnr)
          end, { buffer = bufnr, desc = 'Pyright Organize Imports' })

          local python_path = detect_python_path(client.config.root_dir)
          if python_path then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, {
              python = { pythonPath = python_path },
            })
            client:notify('workspace/didChangeConfiguration', { settings = nil })
          end
        end,
        flags = lsp_flags,
        cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/pyright-langserver'), '--stdio' },
        root_markers = {
          'pyrightconfig.json',
          'pyproject.toml',
          'setup.py',
          'setup.cfg',
          'requirements.txt',
          'Pipfile',
          '.git',
        },
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'openFilesOnly',
            },
          },
        },
      })
      vim.lsp.enable('pyright')

      -- JSON
      vim.lsp.config('jsonls', {
        on_attach = on_attach,
        flags = lsp_flags,
        init_options = {
          provideFormatter = true,
        }
      })
      vim.lsp.enable('jsonls')

      -- Lua
      vim.lsp.config('lua_ls', {
        on_attach = on_attach,
        flags = lsp_flags,
      })
      vim.lsp.enable('lua_ls')

      -- CSS
      vim.lsp.config('cssls', {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
      })
      vim.lsp.enable('cssls')

      -- Go
      vim.lsp.config('gopls', {
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
      })
      vim.lsp.enable('gopls')

      -- Rust
      vim.lsp.config('rust_analyzer', {
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
      })
      vim.lsp.enable('rust_analyzer')

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
  'leoluz/nvim-dap-go',
}
