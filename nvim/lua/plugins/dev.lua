return {
  -- Fuzzy finder
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      winopts = {
        preview = {
          vertical = 'up:60%',
          layout = 'vertical',
          scrollbar = false
        }
      },
      fzf_opts = {
        ['--layout'] = 'default'
      },
      grep = {
        rg_opts =
        '--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=512 --glob=!.git/',
      }
    }
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local parser_configs =
          require('nvim-treesitter.parsers').get_parser_configs()
      parser_configs.http = {
          install_info = {
              url = 'https://github.com/NTBBloodbath/tree-sitter-http',
              files = { 'src/parser.c' },
              branch = 'main'
          }
      }
      parser_configs.pug = {
          install_info = {
              url = "https://github.com/zealot128/tree-sitter-pug",
              files = { "src/parser.c", "src/scanner.cc" },
              branch = "master"
          },
          filetype = "pug",
          used_by = { "vue" }
      }
      require 'nvim-treesitter.configs'.setup {
          ignore_install = { 'haskell', 'scala', 'c_sharp', 'kotlin', 'nickel' },
          highlight = {
              enable = true, -- false will disable the whole extension
              indent = { enable = true },
              use_languagetree = true
          },
          context_commentstring = { enable = true, enable_autocmd = true },
          pairs = {
              enable = true,
              disable = {},
              highlight_pair_events = {},                                       -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
              highlight_self = false,                                           -- whether to highlight also the part of the pair under cursor (or only the partner)
              goto_right_end = false,                                           -- whether to go to the end of the right partner or the beginning
              fallback_cmd_normal = 'call matchit#Match_wrapper(\'\',1,\'n\')', -- What command to issue when we can't find a pair (e.g. "normal! %")
              keymaps = { goto_partner = '<leader>%' }                          -- do not work
          }
      }
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
    opts = {
      auto_save = nil,
      disable_on_zoom = false
    },
    config = function()
      vim.api.nvim_set_keymap('', '<c-h>', '<CMD>lua require("Navigator").left()<CR>', {})
      vim.api.nvim_set_keymap('', '<c-j>', '<CMD>lua require("Navigator").down()<CR>', {})
      vim.api.nvim_set_keymap('', '<c-k>', '<CMD>lua require("Navigator").up()<CR>', {})
      vim.api.nvim_set_keymap('', '<c-l>', '<CMD>lua require("Navigator").right()<CR>', {})
    end,
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
}
