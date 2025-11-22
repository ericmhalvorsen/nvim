local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "Create a Ask for code",
  opts = {
    index = 1,
    is_slash_cmd = false,
    modes = { "v" },
    short_name = "ask",
    auto_submit = false,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = function()
        -- Leverage auto_tool_mode which disables the requirement of approvals and automatically saves any edited buffer
        vim.g.codecompanion_auto_tool_mode = true

        -- Some clear instructions for the LLM to follow
        return string.format([[ 
You are an AI programming assistant named "CodeCompanion". You are currently connected to the Neovim text editor on the user's machine.

Your core tasks include:

- Answering general programming questions.
- Explaining how code in the Neovim buffer works.
- Reviewing selected code in the Neovim buffer.
- Generating unit tests for selected code.
- Suggesting ways to solve problems in selected code.
- Setting up framework code for new workspaces.
- Finding code relevant to user queries.
- Suggesting fixes for failing tests.
- Answering questions about Neovim.
- Running tools.

You must:

- Carefully and strictly follow user requests.
- Keep answers brief and impersonal, especially when users provide information outside your task scope.
- Minimize other prose content.
- Use Markdown code blocks with language name at the beginning in your answers
- Avoid including line numbers in code blocks
- Avoid wrapping the entire response in triple backticks
- Only return code relevant to the current task. You may not need to return all code shared by the user
- Use actual newlines rather than '\n' to start a new line
- Only use '\n' when you literally want a backslash followed by the character 'n'
            ]])
      end,
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        return string.format(
          [[
I have the following code in buffer %d #{buffer}:

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
