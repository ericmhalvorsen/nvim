local M = {}

local function remove_trailing_whitespace()
  -- Save current cursor position
  local view = vim.fn.winsaveview()

  -- Remove trailing whitespace from all lines
  vim.cmd([[%s/\s\+$//e]])

  -- Restore cursor position
  vim.fn.winrestview(view)

  print("Trailing whitespace removed")
end

function M.setup()
  vim.api.nvim_create_user_command("RemoveTrailingSpace", function()
    remove_trailing_whitespace()
  end, {
    desc = "Remove trailing whitespace from all lines in current buffer",
  })
end

return M

