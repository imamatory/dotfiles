local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  -- Core plugins
  { "tpope/vim-sensible" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "nathanaelkane/vim-indent-guides" },
  { "scrooloose/nerdtree" },
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "xolox/vim-misc" },
  { "terryma/vim-multiple-cursors" },
  { "tpope/vim-commentary" },
  { "tpope/vim-abolish" },
  { "tpope/vim-fugitive" },
  { "michaeljsmith/vim-indent-object" },
  { "Chiel92/vim-autoformat" },
  { "imamatory/leader-clipboard" },
  { "digitaltoad/vim-pug" },
  { "elzr/vim-json" },
  { "AndrewRadev/splitjoin.vim" },
  { "ap/vim-css-color" },
  { "hhsnopek/vim-sugarss" },
  { "slashmili/alchemist.vim" },
  { "ekalinin/Dockerfile.vim" },
  { "editorconfig/editorconfig-vim" },
  { "dyng/ctrlsf.vim" },
  { "junegunn/vim-easy-align" },
  { "vtm9/vim-dispatch" },
  { "janko-m/vim-test" },
  { "airblade/vim-rooter" },
  { "jszakmeister/vim-togglecursor" },
  { "vtm9/vim-pry" },
  { "sheerun/vim-polyglot" },

  -- Fuzzy finder
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.initializers.fzf-lua")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("plugins.initializers.nvim-treesitter")
    end,
  },

  -- Spectre
  {
    "windwp/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("spectre").setup({
        replace_engine = {
          ["sed"] = {
            cmd = "sed",
            args = {
              "-i",
              "",
              "-E",
            },
          },
        },
      })
    end,
  },

  -- Navigator
  {
    "numToStr/Navigator.nvim",
    config = function()
      require("plugins.initializers.navigator-nvim")
    end,
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    config = function()
      require("plugins.initializers.copilot-vim")
    end,
  },

  -- ChatGPT
  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("chatgpt").setup()
    end,
  },
}

-- Load LSP configurations
local lsp_plugins = require("plugins.lsp").get_plugins()
for _, plugin in ipairs(lsp_plugins) do
  table.insert(plugins, plugin)
end

-- Initialize lazy.nvim
require("lazy").setup(plugins, {
  change_detection = {
    notify = false,
  },
  install = {
    colorscheme = { "catppuccin" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}) 