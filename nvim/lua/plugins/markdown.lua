-- Markdown: rumdl LSP (diagnostics, <leader>cf formats). The lang.markdown extra
-- stays off: it brings render-markdown, markdown-preview and markdownlint-cli2.
-- Projects pin rumdl in their mise.toml next to .rumdl.toml, so start the
-- server only there; elsewhere only the inactive mise shim is on PATH.
return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				rumdl = {
					mason = false,
					root_markers = { ".rumdl.toml", "rumdl.toml" },
					workspace_required = true,
				},
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = false,
	},
}
