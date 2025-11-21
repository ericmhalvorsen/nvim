-- Auto-load all plugin files from lua/eric/plugins/
-- This eliminates the need to manually require each plugin file

local plugins = {}

-- Files to skip (useful for disabling plugins temporarily)
local skip_list = {
  -- "avante.lua",     -- Uncomment to disable avante
  -- "minuet.lua",     -- Uncomment to disable minuet
  -- "ecolog.lua",     -- Uncomment if ecolog causes issues
}

-- Get the plugins directory path
local plugins_dir = vim.fn.stdpath "config" .. "/lua/eric/plugins"

-- Check if directory exists
local dir_exists = vim.fn.isdirectory(plugins_dir) == 1
if not dir_exists then
  vim.notify("Plugins directory not found: " .. plugins_dir, vim.log.levels.ERROR)
  return plugins
end

-- Get all .lua files in the plugins directory
local plugin_files = vim.fn.glob(plugins_dir .. "/*.lua", false, true)

-- Convert skip_list to a set for O(1) lookup
local skip_set = {}
for _, file in ipairs(skip_list) do
  skip_set[file] = true
end

-- Load each plugin file that's not in the skip list
for _, filepath in ipairs(plugin_files) do
  -- Extract just the filename from the full path
  local filename = vim.fn.fnamemodify(filepath, ":t")

  -- Skip if in skip list
  if not skip_set[filename] then
    -- Remove .lua extension to get the module name
    local module_name = filename:gsub("%.lua$", "")

    -- Require the plugin module
    local ok, plugin = pcall(require, "eric.plugins." .. module_name)
    if ok then
      -- If plugin returns a table, add it to our plugins list
      if type(plugin) == "table" then
        table.insert(plugins, plugin)
      end
    else
      vim.notify(
        string.format("Failed to load plugin: %s\nError: %s", module_name, plugin),
        vim.log.levels.WARN
      )
    end
  end
end

return plugins
