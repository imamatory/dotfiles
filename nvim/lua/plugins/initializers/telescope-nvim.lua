return function()
	local telescope = require('telescope')
	telescope.setup {
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = 'smart_case' -- or "ignore_case" or "respect_case"
			}
		},
		pickers = {
			buffers = {
				sort_lastused = true,
				sort_mru = true,
			}
		}
	}
	telescope.load_extension('fzf')

	local builtin = require 'telescope.builtin'
	local horizontalLayout = {
		layout_strategy = 'horizontal',
		layout_config = {
			width = 0.9,
			height = 0.9,
			mirror = false,
			preview_width = 0.4
		}
	}
	local verticalLayout = {
		layout_strategy = 'vertical',
		layout_config = { width = 0.9, height = 0.9 }
	}

	function vim.getVisualSelection()
		vim.cmd('noau normal! "vy"')
		local text = vim.fn.getreg('v')
		vim.fn.setreg('v', {})

		text = string.gsub(text, "\n", "")
		if #text > 0 then
			return text
		else
			return ''
		end
	end

	local tb = require('telescope.builtin')
	local opts = { noremap = true, silent = true }

	-- map('n', '<space>g', ':Telescope current_buffer_fuzzy_find<cr>', opts)
	-- map('v', '<space>g', function()
	-- 	local text = vim.getVisualSelection()
	-- 	tb.current_buffer_fuzzy_find({ default_text = text })
	-- end, opts)

	map('n', '<space>/', ':Telescope live_grep<cr>', opts)
	map('v', '<space>/', function()
		local text = vim.getVisualSelection()
		tb.live_grep({ default_text = text })
	end, opts)

	map('n', 'go', function() builtin.grep_string(verticalLayout) end)
	map('n', 'gO', function()
		builtin.grep_string(merge(verticalLayout, {
			additional_args = function()
				return { '--hidden', '--no-ignore' }
			end
		}))
	end)
	map('n', 'gb', function()
		builtin.buffers(merge(horizontalLayout, {}))
	end)
	map('n', 'gh', function()
		builtin.oldfiles(merge(horizontalLayout, { cwd_only = true }))
	end)
	hi('TelescopeNormal', { guibg = 'none' })
end
