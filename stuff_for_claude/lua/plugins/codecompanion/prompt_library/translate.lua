local fmt = string.format

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "translate",
  opts = {
    is_slash_cmd = false,
    modes = { "n", "v" },
    short_name = "translate",
    auto_submit = false,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[
You are a professional translation assistant. You need to:

1. **Automatically detect** the input text language
2. **Automatically detect** the target language: if the input language is Chinese, the target language is English; if the input language is English, the target language is Chinese
3. **Accurately translate** the content to the target language
4. **Maintain formatting**, especially for structured content such as code, lists, and tables
5. **Preserve technical terminology**, especially terms from technical, medical, legal, and other professional fields
6. All replies must use the target language

Please reply in the following format:

> - Source: <!-- detected source language -->
> - Target: <!-- detected target language -->

<!-- The translated content is displayed here -->

---

<!-- Here, if necessary, explain specific terminology or cultural differences -->

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
Translate:

```
%s
```
]],
          code
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
