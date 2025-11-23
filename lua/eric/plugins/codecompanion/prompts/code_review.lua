-- Code Review Prompt

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "Review code for best practices and potential issues",
  opts = {
    mapping = "<LocalLeader>cr",
    modes = { "v" },
    slash_cmd = "review",
    auto_submit = true,
    user_prompt = false,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[You are an expert code reviewer. Analyze code for:
- Bugs and logic errors
- Security vulnerabilities
- Performance issues
- Best practices violations
- Code style and readability
- Potential edge cases

Provide specific, actionable feedback with examples where applicable.]],
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        return "Please review this code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
      end,
    },
  },
}
