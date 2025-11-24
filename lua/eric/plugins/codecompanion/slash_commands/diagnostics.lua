-- /diagnostics Slash Command
-- Shows LSP diagnostics for the current line in the chat

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

---@param chat CodeCompanion.Chat
local callback = function(chat)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor_pos[1] - 1 -- Convert to 0-indexed
  local diagnostics = vim.diagnostic.get(0) -- Get diagnostics for current buffer

  local line_diagnostics = {}
  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.lnum == line_num then
      local severity_name = vim.diagnostic.severity[diagnostic.severity] or "UNKNOWN"
      table.insert(
        line_diagnostics,
        string.format("Line %d [%s]: %s", diagnostic.lnum + 1, severity_name, diagnostic.message)
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
      string.format("No diagnostics on line %d", line_num + 1),
      vim.log.levels.INFO,
      { title = "CodeCompanion" }
    )
  end
end

return {
  description = "Show LSP diagnostics for current line",
  callback = callback,
  opts = {
    contains_code = true,
  },
}
