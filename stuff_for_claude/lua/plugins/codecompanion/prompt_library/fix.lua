local fmt = string.format

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "Fix code",
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
      content = [[
When asked to fix code, please follow these steps:

1. **Identify the problem**: Carefully read the provided code to find any potential issues or areas for improvement.
2. **Plan the fix**: Describe your plan for fixing the code in pseudocode, detailing each step.
3. **Implement the fix**: Write the corrected code in a separate code block.
4. **Explain the fix**: Briefly explain the changes made and the reasoning behind them.

Ensure that the fixed code:

- Includes necessary imports.
- Can handle potential errors.
- Follows best practices for readability and maintainability.
- Is properly formatted.

Additionally, you must:

- Use Markdown format and specify the programming language name at the beginning of code blocks.
]],
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

        return fmt(
          [[
@editor #{buffer}

Please fix the code in buffer %d and explain the fix method:

```%s
%s
```

Diagnostic：

```
%s
```
]],
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
