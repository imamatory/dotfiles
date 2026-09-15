return {
  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>ssr", function() require("spectre").open() end, desc = "Spectre search/replace" },
      {
        "<leader>ssw",
        function() require("spectre").open_visual({ select_word = true }) end,
        desc = "Spectre search current word",
      },
    },
  },
  {
    "numtostr/Navigator.nvim",
    keys = {
      { "<C-h>", "<cmd>NavigatorLeft<cr>" },
      { "<C-j>", "<cmd>NavigatorDown<cr>" },
      { "<C-k>", "<cmd>NavigatorUp<cr>" },
      { "<C-l>", "<cmd>NavigatorRight<cr>" },
    },
    opts = {},
  },
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" } },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gvdiffsplit" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
    },
  },
}
