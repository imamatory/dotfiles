local model_name = "claude-opus-4-6"

return {
    -- Avante: AI-powered coding assistant (cursor-style) with Claude support
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false, -- always build from latest commit
        build = "make",
        opts = {
            provider = "claude",
            providers = {
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = model_name,
                    timeout = 30000,
                    extra_request_body = {
                        temperature = 0,
                        max_tokens = 10000,
                    },
                },
            },
            -- Behaviour
            behaviour = {
                auto_suggestions = false,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
            },
            -- Mappings (all prefixed with <leader>a)
            mappings = {
                diff = {
                    ours = "co",
                    theirs = "ct",
                    all_theirs = "ca",
                    both = "cb",
                    cursor = "cc",
                    next = "]x",
                    prev = "[x",
                },
                suggestion = {
                    accept = "<M-l>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
                jump = {
                    next = "]]",
                    prev = "[[",
                },
                submit = {
                    normal = "<CR>",
                    insert = "<C-s>",
                },
                sidebar = {
                    apply_all = "A",
                    apply_cursor = "a",
                    switch_windows = "<Tab>",
                    reverse_switch_windows = "<S-Tab>",
                },
            },
            hints = { enabled = true },
            windows = {
                position = "right",
                wrap = true,
                width = 40,
                sidebar_header = {
                    enabled = true,
                    align = "center",
                    rounded = true,
                },
            },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
            -- Paste images into avante chat
            {
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = { insert_mode = true },
                        use_absolute_path = true,
                    },
                },
            },
            -- Markdown rendering inside avante panels
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },

    -- CodeCompanion: chat & inline AI assistant, multi-provider incl. Claude
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
        },
        -- Switch from opts= to config= so we can attach the autocmd fix
        config = function(_, opts)
            require("codecompanion").setup(opts)

            -- nvim 0.12 broke treesitter language-injection for the chat buffer:
            -- diagnostic.set() triggers a redraw → highlighter → languagetree.parse()
            -- which calls .range() on a nil injected node.
            -- Stopping treesitter on codecompanion buffers avoids the crash.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "codecompanion",
                callback = function(ev)
                    vim.treesitter.stop(ev.buf)
                end,
            })
        end,
        opts = {
            strategies = {
                chat = {
                    adapter = "anthropic",
                },
                inline = {
                    adapter = "anthropic",
                },
                agent = {
                    adapter = "anthropic",
                },
            },
            adapters = {
                anthropic = function()
                    return require("codecompanion.adapters").extend("anthropic", {
                        schema = {
                            model = {
                                default = model_name,
                            },
                        },
                    })
                end,
            },
            display = {
                chat = {
                    show_settings = true,
                },
            },
        },
        keys = {
            { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "CodeCompanion Chat toggle",   mode = { "n", "v" } },
            { "<leader>an", "<cmd>CodeCompanionChat<CR>",        desc = "CodeCompanion new chat",      mode = { "n", "v" } },
            { "<leader>ai", "<cmd>CodeCompanion<CR>",            desc = "CodeCompanion inline assist", mode = { "n", "v" } },
            { "<leader>aa", "<cmd>CodeCompanionActions<CR>",     desc = "CodeCompanion action picker", mode = { "n", "v" } },
        },
    },
}
