-- /git_files Slash Command
-- Lists all git-tracked files in the current repository

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

---@param chat CodeCompanion.Chat
local callback = function(chat)
  -- Run git ls-files to get tracked files securely
  vim.system({ "git", "ls-files" }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
        chat:add_reference({
          role = constants.USER_ROLE,
          content = "Git-tracked files in this repository:\n\n" .. obj.stdout,
        }, "git_files", "<git_files>")
      elseif obj.code == 0 then
        vim.notify("No git-tracked files found", vim.log.levels.INFO, { title = "CodeCompanion" })
      else
        vim.notify("Failed to run git ls-files (not a git repo?)", vim.log.levels.WARN, { title = "CodeCompanion" })
      end
    end)
  end)
end

return {
  description = "List all git-tracked files",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
