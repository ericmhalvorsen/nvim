-- Explain Code Prompt

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "Explain how code works",
  opts = {
    is_slash_cmd = false,
    modes = { "v" },
    short_name = "explain",
    auto_submit = true,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[When asked to explain code, please:

1. **Overview**: Provide a high-level summary of what the code does
2. **Step-by-Step**: Break down the logic flow in detail
3. **Key Concepts**: Explain important programming concepts used
4. **Purpose**: Describe how this fits into the broader application
5. **Notable Details**: Point out any clever techniques or gotchas

Keep explanations clear and concise. Use examples when helpful.]],
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        return string.format(
          [[Please explain how this code works:

```%s
%s
```]],
          context.filetype,
          code
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
