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

	map('n', 'gF', function()
		builtin.find_files(merge(horizontalLayout,
			{ hidden = true, no_ignore = true }))
	end)
	-- map('n', 'gc', function() builtin.live_grep(verticalLayout) end)
	-- map('n', 'gC', function()
	-- 	-- builtin.live_grep(merge(verticalLayout, {
	-- 	telescope.extensions.live_grep_args.live_grep_args(merge(verticalLayout, {
	-- 		additional_args = function()
	-- 			return { '--hidden', '--no-ignore' }
	-- 		end
	-- 	}))
	-- end)
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
