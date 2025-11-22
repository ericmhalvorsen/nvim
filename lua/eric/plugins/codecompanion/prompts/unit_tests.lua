-- Unit Tests Prompt

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "chat",
  description = "Generate unit tests for code",
  opts = {
    is_slash_cmd = false,
    modes = { "v" },
    short_name = "tests",
    auto_submit = true,
    user_prompt = false,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[When generating unit tests:

1. **Analyze the code**: Understand what the code does
2. **Identify test cases**: List normal cases, edge cases, and error scenarios
3. **Write tests**: Create comprehensive unit tests with:
   - Clear test names describing what is being tested
   - Proper setup and teardown
   - Assertions for expected behavior
   - Coverage of edge cases and error conditions
4. **Include examples**: Show how to run the tests

Use appropriate testing framework for the language (Jest, pytest, JUnit, etc.).
Follow testing best practices and naming conventions.]],
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = function(context)
        local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
        return string.format(
          [[Please generate comprehensive unit tests for this code:

```%s
%s
```

Include:
- Normal/happy path cases
- Edge cases
- Error handling scenarios
- Setup and teardown if needed]],
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
