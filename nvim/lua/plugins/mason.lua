-- Pin the full local Mason package set: installs anything missing on startup,
-- plus a :MasonInstallAll command for manual re-sync.
local packages = {
	-- LSP servers
	"codelldb",
	"delve",
	"docker-compose-language-service",
	"dockerfile-language-server",
	"elixir-ls",
	"gopls",
	"helm-ls",
	"json-lsp",
	"lua-language-server",
	"marksman",
	"pyright",
	"ruff",
	"tree-sitter-cli",
	"vtsls",
	"yaml-language-server",
	"gofumpt",
	"goimports",
	"prettier",
	"shfmt",
	"stylua",
	-- linters (NOTE: removed erb-lint)
	"golangci-lint",
	"hadolint",
	"markdownlint-cli2",
	"markdown-toc",
	-- DAP
	"js-debug-adapter",
}

return {
	{
		"mason-org/mason.nvim",
		init = function()
			local function install_all()
				local mr = require("mason-registry")
				mr.refresh(function()
					local missing = vim.tbl_filter(function(p)
						return not mr.is_installed(p)
					end, packages)
					if #missing > 0 then
						require("mason.api.command").MasonInstall(missing)
					end
				end)
			end
			vim.schedule(install_all)
			vim.api.nvim_create_user_command("MasonInstallAll", install_all, { desc = "Install pinned mason packages" })
		end,
	},
}
