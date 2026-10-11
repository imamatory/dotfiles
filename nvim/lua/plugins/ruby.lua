-- Ruby/ERB: remove erb-formatter and erb-lint entirely.
-- The LazyVim lang.ruby extra pins both in Mason and formats `eruby` via
-- erb_format; undo that here (see lazyvim.plugins.extras.lang.ruby).
local erb_packages = { "erb-formatter", "erb-lint" }
local function filter_erb(packages)
  return vim.tbl_filter(function(pkg) return not vim.tbl_contains(erb_packages, pkg) end, packages)
end

return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed then
        opts.ensure_installed = filter_erb(opts.ensure_installed)
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.eruby = nil
    end,
  },
}
