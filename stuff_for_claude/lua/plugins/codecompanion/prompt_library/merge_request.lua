local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "workflow",
  description = "Create or update a merge request with auto-generated description",
  opts = {
    index = 6,
    short_name = "mr",
  },
  prompts = {
    {
      -- Initial system setup
      {
        role = constants.SYSTEM_ROLE,
        content = [[
You are a helpful assistant specializing in creating meaningful merge request based on commit history.
Your task is to organize commits and generate a structured MR description, then create or update a merge request using `glab`.
]],
        opts = { visible = false },
      },
      {
        role = constants.USER_ROLE,
        content = function()
          -- Leverage auto_tool_mode which disables the requirement of approvals and automatically saves any edited buffer
          vim.g.codecompanion_auto_tool_mode = true

          -- Get target branch
          local target_branch =
            vim.fn.input("Enter target branch name: ", "", "customlist,v:lua.vim.fn.get_git_branches")

          -- Get current branch
          local handle = io.popen("git branch --show-current 2>/dev/null")
          if not handle then
            return "Error getting current branch"
          end
          local current_branch = handle:read("*a"):gsub("%s+$", "") -- Trim whitespace
          handle:close()

          -- Get commit diff
          local get_commit_diff_cmd =
            string.format("git -c pager.log=false log origin/%s..origin/%s", target_branch, current_branch)
          handle = io.popen(get_commit_diff_cmd)
          if not handle then
            return "Error getting commit diff"
          end
          local commit_diffs = handle:read("*a")
          handle:close()

          -- Check if MR exists
          local check_cmd = string.format(
            "glab mr list --source-branch %s --target-branch %s 2>/dev/null",
            current_branch,
            target_branch
          )
          handle = io.popen(check_cmd)
          if not handle then
            return "Error checking existing MRs"
          end
          local mr_result = handle:read("*a")
          handle:close()

          -- Extract MR ID if exists
          local mr_id = nil
          if mr_result then
            if mr_result:match("!([0-9]+)") then
              mr_id = mr_result:match("!([0-9]+)")
            end
          end

          local mr_task = ""
          if mr_id then
            mr_task = string.format("update merge request !%s", mr_id)
          else
            mr_task = "create merge request"
          end

          return string.format(
            [[
@full_stack_dev

I'm generating a merge request from branch %s to %s. Please follow the following steps:

Step1: Analyze commits to generate description

1. Group commits by type (Feature, Fix, Chore, etc.)
2. Summarize commit content concisely (don't just repeat commit messages)
3. Format the description according to the specified template

Please analyze these commits:

```
> %s
%s
```

Please format the description as:

```
### <Type>

- <commit_id> - <Summarized commit content>
```

Generate the description to tmp file `/tmp/<tmpfile>`.

Step2: Create/Update merge request

Use `glab mr create --source-branch <branch> --target-branch <branch> --title "<title>" --description "$(cat <tmpfile>)"` to create.
Use `glab mr update [id] --title "<title>" --description "$(cat <tmpfile>)"` to update.

Please use cmd tools to %s.

]],
            current_branch,
            target_branch,
            get_commit_diff_cmd,
            commit_diffs,
            mr_task
          )
        end,
        opts = { auto_submit = false },
      },
    },
  },
}
