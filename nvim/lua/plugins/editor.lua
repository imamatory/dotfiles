return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          layout = {
            box = "vertical",
            width = 0.8,
            height = 0.8,
            { win = "preview", title = "{preview}", height = 0.6, border = true },
            {
              box = "vertical",
              border = true,
              title = "{title} {live} {flags}",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
          },
        },
        sources = {
          buffers = {
            -- stable MRU sort: snacks sorts by `lastused` (second precision), so
            -- buffers touched within the same second land in random order
            -- (table.sort is not stable). Tie-break deterministically.
            finder = function(opts, ctx)
              opts = vim.tbl_extend("force", opts, { sort_lastused = false })
              local items = require("snacks.picker.source.buffers").buffers(opts, ctx)
              for i, item in ipairs(items) do
                item.snap = i
              end
              local current_buf = vim.api.nvim_get_current_buf()
              table.sort(items, function(a, b)
                local au, bu = a.info.lastused, b.info.lastused
                if au ~= bu then
                  return au > bu
                end
                if (a.buf == current_buf) ~= (b.buf == current_buf) then
                  return a.buf == current_buf
                end
                return a.snap < b.snap
              end)
              for _, item in ipairs(items) do
                item.snap = nil
              end
              return items
            end,
          },
          files = {
            hidden = true,
            ignored = false,
          },
          smart = {
            hidden = true,
            ignored = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
            layout = {
              preview = "main",
              layout = {
                backdrop = false,
                width = 40,
                min_width = 40,
                height = 0,
                position = "left",
                border = "none",
                box = "vertical",
                {
                  win = "input",
                  height = 1,
                  border = true,
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", height = 0.4, border = "top" },
              },
            },
          },
        },
      },
    },
  },
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
