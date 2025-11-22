-- /git_files Slash Command
-- Lists all git-tracked files in the current repository

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

---@param chat CodeCompanion.Chat
local callback = function(chat)
  -- Run git ls-files to get tracked files
  local handle = io.popen "git ls-files"

  if handle then
    local result = handle:read "*a"
    handle:close()

    if result and result ~= "" then
      chat:add_reference({
        role = constants.USER_ROLE,
        content = "Git-tracked files in this repository:\n\n" .. result,
      }, "git_files", "<git_files>")
    else
      vim.notify("No git-tracked files found", vim.log.levels.INFO, { title = "CodeCompanion" })
    end
  else
    vim.notify("Failed to run git ls-files (not a git repo?)", vim.log.levels.WARN, { title = "CodeCompanion" })
  end
end

return {
  description = "List all git-tracked files",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
