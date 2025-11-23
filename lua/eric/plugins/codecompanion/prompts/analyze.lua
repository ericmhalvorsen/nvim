-- Analyze LSP Diagnostics Prompt

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "Analyze code and diagnostic information",
  opts = {
    is_slash_cmd = false,
    modes = { "v" },
    short_name = "analyze",
    auto_submit = true,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[When analyzing diagnostic information:

1. **Identify the problem**: Carefully read the code and identify issues
2. **Root cause**: Explain why the error/warning is occurring
3. **Plan the fix**: Describe your plan using pseudocode
4. **Provide solution**: Write the corrected code
5. **Explain changes**: Briefly explain the changes and reasoning

Ensure fixed code:
- Includes necessary imports
- Handles potential errors
- Follows best practices for readability and maintainability
- Is properly formatted

Use Markdown formatting with language name in code blocks.]],
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

        return string.format(
          [[Please analyze the code and diagnostic information:

**Code (buffer %d):**

```%s
%s
```

**Diagnostics:**

```
%s
```]],
          context.bufnr,
          context.filetype,
          code,
          table.concat(diagnostic_messages, "\n")
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
