-- Python: make pyright/ruff/etc. pick up the project's uv (.venv) automatically.
-- Uv creates .venv at the project root by default, propagating
-- `VIRTUAL_ENV` so all LSPs, formatters, and linters resolve it.
local function detect_venv(root_dir)
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV
  end
  if root_dir then
    local venv = vim.fs.joinpath(root_dir, ".venv")
    if vim.uv.fs_stat(venv) then
      return venv
    end
  end
  -- fallback: walk up from cwd
  local cwd_venv = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
  if cwd_venv ~= "" then
    return vim.uv.fs_realpath(cwd_venv)
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(initialization_params, conf)
            local venv = detect_venv(conf.root_dir)
            if venv then
              local python_path = vim.fs.joinpath(venv, "bin", "python")
              initialization_params.initializationOptions = initialization_params.initializationOptions or {}
              initialization_params.initializationOptions.python = { pythonPath = python_path }
              initialization_params.settings = initialization_params.settings or {}
              initialization_params.settings.python = { pythonPath = python_path, venvPath = venv }
            end
          end,
        },
        ruff = {
          init_options = {
            settings = {
              -- ruff resolves the venv on its own via project pyproject.toml / .venv
              logLevel = "error",
            },
          },
        },
      },
    },
  },
  -- Auto-load cached uv venv for the project on first python buffer
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      options = {
        notify_user_on_venv_activation = true,
        override_notify = false,
      },
    },
  },
}
