return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				markdown = {},
				["markdown.mdx"] = {},
				yaml = {},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"pug",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"yaml",
			},
		},
	},
}
