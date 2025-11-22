local constants = require("plugins.codecompanion.slash_commands.constants")

---@param chat CodeCompanion.Chat
local callback = function(chat)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor_pos[1] - 1
  local diagnostics = vim.diagnostic.get(0)

  local line_diagnostics = {}
  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.lnum == line_num then
      table.insert(
        line_diagnostics,
        string.format("Line %d: %s: %s", diagnostic.lnum + 1, diagnostic.severity, diagnostic.message)
      )
    end
  end

  if #line_diagnostics > 0 then
    chat:add_reference({
      role = constants.USER_ROLE,
      content = table.concat(line_diagnostics, "\n"),
    }, "diagnostics", "<diagnostics>")
  else
    return vim.notify(
      string.format("No diagnostics available for line %d", line_num),
      vim.log.levels.INFO,
      { title = "CodeCompanion" }
    )
  end
end

return {
  description = "Show diagnostics messages",
  callback = callback,
  opts = {
    contains_code = true,
  },
}
