-- Helm chart templates: treesitter highlighting (go-template "helm" dialect) + helm-ls
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Detect templates/*.yaml|yml|tpl inside a chart (and subcharts like charts/mysql/templates/...)
    -- as `helm`. Neovim core maps the helm treesitter language to this filetype automatically.
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/templates/.*%.ya?ml"] = "helm",
          [".*/templates/.*%.tpl"] = "helm",
        },
      })
    end,
    -- lazy appends array entries of `opts`, so this adds to core.lua's ensure_installed
    opts = {
      ensure_installed = { "helm" },
    },
  },

  -- helm_ls binary installs via the pinned list in mason.lua; this enables the server
  -- (lspconfig bundle has helm_ls with filetypes = { "helm", "yaml.helm-values" })
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "helm_ls" },
    },
  },
}
