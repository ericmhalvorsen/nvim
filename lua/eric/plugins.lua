local plugins = {}

local skip_list = {
  "avante.lua", -- Disabled
  "minuet.lua", -- Disabled
}

local plugins_dir = vim.fn.stdpath "config" .. "/lua/eric/plugins"

local dir_exists = vim.fn.isdirectory(plugins_dir) == 1
if not dir_exists then
  vim.notify("Plugins directory not found: " .. plugins_dir, vim.log.levels.ERROR)
  return plugins
end

local plugin_files = vim.fn.glob(plugins_dir .. "/*.lua", false, true)

local skip_set = {}
for _, file in ipairs(skip_list) do
  skip_set[file] = true
end

for _, filepath in ipairs(plugin_files) do
  local filename = vim.fn.fnamemodify(filepath, ":t")

  if not skip_set[filename] then
    local module_name = filename:gsub("%.lua$", "")

    local ok, plugin = pcall(require, "eric.plugins." .. module_name)
    if ok then
      if type(plugin) == "table" then
        table.insert(plugins, plugin)
      end
    else
      vim.notify(string.format("Failed to load plugin: %s\nError: %s", module_name, plugin), vim.log.levels.WARN)
    end
  end
end

return plugins
