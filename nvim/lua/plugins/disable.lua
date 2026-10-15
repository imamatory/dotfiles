return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  -- kill all animations: no smooth scrolling, no animated windows/menus,
  -- no indent guides animation, no fancy UI flavors
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      animate = { enabled = false },
      indent = {
        animate = { enabled = false },
        scope = { enabled = false },
      },
      dim = { animate = { enabled = false } },
      words = { enabled = false },
      notifier = {
        timeout = 2000,
        style = "minimal",
      },
      styles = {
        notification = { border = "single" },
        scratch = { border = "single" },
        lazygit = { border = "single" },
        help = { border = "single" },
        picker = { border = "single" },
      },
    },
    optional = true,
  },
  {
    "folke/noice.nvim",
    opts = {
      -- hide LSP progress popups ("✔ pyright ..." bottom-right) from pyright/ruff
      lsp = {
        progress = { enabled = false },
      },
      views = {
        cmdline_popup = { border = "single" },
        popupmenu = { border = "single" },
        mini = { win_options = { winblend = 0 } },
      },
      presets = {
        lsp_doc_border = true,
      },
    },
    optional = true,
  },
  {
    "folke/flash.nvim",
    enabled = false,
  },
}
