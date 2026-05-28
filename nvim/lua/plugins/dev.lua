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
    dependencies = {
      -- Context-aware commentstring (standalone setup, not via treesitter module)
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          vim.g.skip_ts_context_commentstring_module = true
          require('ts_context_commentstring').setup {}
        end,
      },
      -- Required for pairs module
      "theHamsta/nvim-treesitter-pairs",
      -- Textobjects: function/class/parameter motions and selections
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
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
        ensure_installed = {
          -- Web
          'html', 'css', 'scss', 'javascript', 'typescript', 'tsx',
          -- Data / config
          'json', 'yaml', 'toml',
          -- Scripting / systems
          'lua', 'python', 'bash', 'rust', 'go',
          -- Backend / infra
          'elixir', 'ruby', 'sql', 'terraform', 'dockerfile',
          -- Vim / docs
          'vim', 'vimdoc', 'markdown', 'markdown_inline',
          -- Build / misc
          'make', 'regex',
        },
        ignore_install = { 'haskell', 'scala', 'c_sharp', 'kotlin', 'nickel' },

        highlight = {
          enable = true,
          disable = function(lang, buf)
            -- Disable for codecompanion chat buffers (avoids nvim 0.12 crash)
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name:match("codecompanion") then
              return true
            end
          end,
        },

        indent = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection    = '<CR>',
            node_incremental  = '<CR>',
            node_decremental  = '<BS>',
            scope_incremental = '<TAB>',
          },
        },

        pairs = {
          enable = true,
          disable = {},
          highlight_pair_events = {},
          highlight_self = false,
          goto_right_end = false,
          fallback_cmd_normal = 'call matchit#Match_wrapper(\'\',1,\'n\')',
          keymaps = { goto_partner = '<leader>%' }
        },

        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start     = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
            goto_next_end       = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
            goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
            goto_previous_end   = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
          },
          swap = {
            enable = true,
            swap_next     = { ['<leader>sp'] = '@parameter.inner' },
            swap_previous = { ['<leader>sP'] = '@parameter.inner' },
          },
        },
      }
    end,
  },

  -- Sticky context header: shows current function/class at top of window
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      max_lines = 3,
      trim_scope = 'outer',
      mode = 'cursor',
    },
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
      require('Navigator').setup()
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
