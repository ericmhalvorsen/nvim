local M = {}

local function run_in_terminal(cmd, title)
  local term_cmd = "terminal " .. cmd
  vim.cmd("botright split")
  vim.cmd("resize 15")
  vim.cmd(term_cmd)
  vim.cmd("setlocal nonumber norelativenumber")
  if title then
    vim.cmd("file " .. title)
  end
end

function M.tidy()
  local cmd = "go mod tidy"
  run_in_terminal(cmd, "GoMod")
end

function M.setup()
  vim.api.nvim_create_user_command("GoModTidy", function()
    M.tidy()
  end, {
    desc = "Run go mod tidy to clean up module dependencies",
  })
end

return M
