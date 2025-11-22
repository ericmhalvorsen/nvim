-- Task Workflow Prompt
-- Enables step-by-step task completion with diagnostic checks

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

local completion_indicator = "[TASK COMPLETE]"

return {
  strategy = "chat",
  description = "Create a chat for completing specific tasks step by step",
  opts = {
    index = 5,
    short_name = "task",
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = function(context)
        -- Leverage auto_tool_mode which disables the requirement of approvals
        -- and automatically saves any edited buffer
        vim.g.codecompanion_auto_tool_mode = true

        return string.format(
          [[You are a helpful assistant specializing in completing tasks in %s.
Break down complex tasks into manageable steps, and work through them methodically.
Think step by step and be thorough in your approach. Focus on practical, actionable solutions.

When approaching a task:
1. First analyze the requirements and constraints
2. Outline a clear plan before implementation
3. Explain your reasoning at key decision points
4. Provide status updates as you progress
5. Test your solution thoroughly when appropriate

If you encounter obstacles or need clarification:
- Clearly state what information you need
- Explain why this information is necessary
- Suggest possible alternatives if available

DIAGNOSTIC CHECK PROCEDURE:

Before marking any task as complete, you MUST perform these diagnostic checks:

1. Check for syntax errors in any code you've written or modified
2. Verify that variable names are consistent throughout the code
3. Ensure proper formatting and indentation
4. Confirm that all functions and methods referenced actually exist
5. Review logic for potential edge cases or bugs
6. Verify that any dependencies or imports are properly handled
7. Check for performance issues in critical sections
8. Ensure error handling is implemented where necessary

COMPLETION PROTOCOL:

Only when ALL diagnostic checks pass, indicate completion by including
`%s` marker on its own line at the end of your message. If ANY diagnostics fail:

- Clearly indicate what specific issues were found
- Provide suggested fixes for each issue
- DO NOT mark the task as complete until these are resolved

IMPORTANT: ONLY use the marker when the ENTIRE task has been successfully completed
AND all diagnostic checks have passed. NEVER include this marker in intermediate
responses or when only part of the task has been done or when diagnostics have
detected issues. If you need more information or the task is still ongoing,
DO NOT include the completion marker.]],
          context.filetype,
          completion_indicator
        )
      end,
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = "I need you to complete the following task: ",
      opts = {
        auto_submit = false,
      },
    },
  },
}
