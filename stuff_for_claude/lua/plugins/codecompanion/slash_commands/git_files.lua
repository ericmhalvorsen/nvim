local constants = require("plugins.codecompanion.slash_commands.constants")

---@class CodeCompanion.Chat
---@field add_reference fun(self: CodeCompanion.Chat, opts: table, type: string, tag: string): nil
---@param chat CodeCompanion.Chat
local callback = function(chat)
  local handle = io.popen("git ls-files")
  if handle ~= nil then
    local result = handle:read("*a")
    handle:close()
    chat:add_reference({
      role = constants.USER_ROLE,
      content = result,
    }, "git", "<git_files>")
  else
    return vim.notify("No git files available", vim.log.levels.INFO, { title = "CodeCompanion" })
  end
end

return {
  description = "List git files",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
