local fmt = string.format

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "Explain the code in the buffer",
  opts = {
    is_slash_cmd = false,
    modes = { "v" },
    short_name = "explain",
    auto_submit = false,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[
When asked to explain code, please follow these steps:

1. Identify the programming language.
2. Describe the purpose of the code, referencing core concepts in the programming language.
3. Explain each function or important code block, including parameters and return values.
4. Highlight any specific functions or methods used and their purpose.
5. If applicable, provide context on how the code fits into a larger application.

Additionally, you must:

- Use Markdown formatting, and specify the programming language name at the beginning of code blocks.
]],
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

        return fmt(
          [[
#{buffer}

Please explain this code in buffer %d

```%s
%s
```
]],
          context.bufnr,
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
