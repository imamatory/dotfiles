-- Load all plugin modules and return their plugin specifications
local plugins = {}

-- Load all plugin modules
local plugin_modules = {
  "plugins.core",
  "plugins.lsp",
  "plugins.dev",
  "plugins.nvim-cmp",
}

for _, module in ipairs(plugin_modules) do
  local ok, plugin_module = pcall(require, module)
  if ok and plugin_module.get_plugins then
    local module_plugins = plugin_module.get_plugins()
    if type(module_plugins) == "table" then
      for _, plugin in ipairs(module_plugins) do
        table.insert(plugins, plugin)
      end
    end
  end
end

return plugins