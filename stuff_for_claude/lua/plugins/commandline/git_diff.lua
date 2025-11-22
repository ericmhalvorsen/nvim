local M = {}

local function run_in_terminal(cmd, title)
  local term_cmd = "terminal " .. cmd
  vim.cmd("botright split")
  vim.cmd("resize 35")
  vim.cmd(term_cmd)
  vim.cmd("setlocal nonumber norelativenumber")
  if title then
    vim.cmd("file " .. title)
  end
end

function M.git_diff()
  local cmds = { "git", "diff" }
  local cmd = table.concat(cmds, " ")
  run_in_terminal(cmd, "GitDiff")
end

function M.setup()
  vim.api.nvim_create_user_command("GitDiff", function()
    M.git_diff()
  end, {
    desc = "Open git diff in terminal",
  })
end

return M
