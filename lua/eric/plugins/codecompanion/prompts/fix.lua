-- Fix Code Prompt

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "Fix code issues and errors",
  opts = {
    is_slash_cmd = false,
    modes = { "v" },
    short_name = "fix",
    auto_submit = false,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[When fixing code, follow these steps:

1. **Identify the problem**: Find issues or areas for improvement
2. **Plan the fix**: Describe your fix plan in pseudocode, step-by-step
3. **Implement the fix**: Write the corrected code in a code block
4. **Explain the fix**: Briefly explain changes and reasoning

Ensure fixed code:
- Includes necessary imports
- Can handle potential errors
- Follows best practices for readability and maintainability
- Is properly formatted

Use Markdown format with programming language name in code blocks.]],
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        local diagnostics = vim.diagnostic.get(context.bufnr, { lnum = context.start_line - 1 })

        local diagnostic_messages = {}
        for _, diagnostic in ipairs(diagnostics) do
          table.insert(diagnostic_messages, diagnostic.message)
        end

        local diagnostic_text = #diagnostic_messages > 0 and string.format(
          [[

**Diagnostics:**

```
%s
```]],
          table.concat(diagnostic_messages, "\n")
        ) or ""

        return string.format(
          [[@editor #{buffer}

Please fix the code in buffer %d and explain the fix method:

```%s
%s
```%s]],
          context.bufnr,
          context.filetype,
          code,
          diagnostic_text
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
