local util = require("lspconfig.util")

local root_files = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    -- customize
    "manage.py",
}

local ignore_diagnostic_message = {
    '"self" is not accessed',
    '"args" is not accessed',
    '"kwargs" is not accessed',
}

local filter_publish_diagnostics = function(a, params, client_info, extra_message, config)
    ---@diagnostic disable-next-line: unused-local
    local client = vim.lsp.get_client_by_id(client_info.client_id)

    if extra_message.ignore_diagnostic_message then
        local new_index = 1

        for _, diagnostic in ipairs(params.diagnostics) do
            if not vim.tbl_contains(extra_message.ignore_diagnostic_message, diagnostic.message) then
                params.diagnostics[new_index] = diagnostic
                new_index = new_index + 1
            end
        end

        for i = new_index, #params.diagnostics do
            params.diagnostics[i] = nil
        end
    end
end

return {
    filetypes = { "python" },
    single_file_support = true,
    cmd = { "pyright-langserver", "--stdio" },
    ---@diagnostic disable-next-line: deprecated
    root_dir = util.root_pattern(unpack(root_files)),
    handlers = {
        -- If you want to disable pyright's diagnostic prompt, open the code below
        -- ["textDocument/publishDiagnostics"] = function(...) end,
        -- If you want to disable pyright from diagnosing unused parameters, open the function below
        ["textDocument/publishDiagnostics"] = vim.lsp.with(filter_publish_diagnostics, {
            ignore_diagnostic_message = ignore_diagnostic_message,
        }),
    },
  }
