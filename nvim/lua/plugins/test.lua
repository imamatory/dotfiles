return {
  {
    "vim-test/vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast" },
    dependencies = { "tpope/vim-dispatch" },
    keys = {
      { "<leader>t", "<cmd>TestNearest<cr>", desc = "Test nearest" },
      { "<leader>T", "<cmd>TestFile<cr>", desc = "Test file" },
    },
    init = function()
      vim.g["test#strategy"] = "dispatch"
      vim.g["test#go#runner"] = "gotest"
    end,
  },
  {
    "tpope/vim-dispatch",
    lazy = true,
  },
}
