local title = "CodeCompanion AutoSave"
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local codecompanion_group = augroup("CodeCompanionAutoSave", { clear = true })

-- Configuration options
local config = {
  auto_save = true,
  triggers = {
    "BufLeave",
    "FocusLost",
    -- "InsertLeave",
    -- "TextChanged",
  },
  save_dir = "~/.local/share/nvim/codecompanion/",
}

local function save_codecompanion_buffer(bufnr)
  local save_dir = vim.fn.expand(config.save_dir)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  -- Ensure directory exists
  if vim.fn.isdirectory(save_dir) == 0 then
    local success = vim.fn.mkdir(save_dir, "p")
    if success ~= 1 then
      vim.notify("Failed to create directory: " .. save_dir, vim.log.levels.ERROR, { title = title })
      return
    end
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- Extract the unique ID from the buffer name
  local id = bufname:match("%[CodeCompanion%] (%d+)")
  local date = os.date("+%Y-%m-%dT%H:%M:%S")
  local save_path

  if id then
    -- Use date plus ID to ensure uniqueness
    save_path = save_dir .. date .. "_codecompanion_" .. id .. ".md"
  else
    -- Fallback with timestamp to ensure uniqueness if no ID
    save_path = save_dir .. date .. "_codecompanion_" .. os.date("%H%M%S") .. ".md"
  end

  -- Write buffer content to file
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local file = io.open(save_path, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()

    vim.notify("Saved: " .. vim.fn.fnamemodify(save_path, ":t"), vim.log.levels.DEBUG, { title = title })
    -- vim.notify("Saved to: " .. vim.fn.fnamemodify(save_path, ":~:."), vim.log.levels.DEBUG, { title = title })
  else
    vim.notify("Save failed: " .. vim.fn.fnamemodify(save_path, ":~:."), vim.log.levels.ERROR, { title = title })
  end
end

-- Only setup autocmds if auto_save is enabled
if config.auto_save then
  autocmd(config.triggers, {
    group = codecompanion_group,
    callback = function(args)
      local bufnr = args.buf
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      if bufname:match("%[CodeCompanion%]") then
        save_codecompanion_buffer(bufnr)
      end
    end,
  })
end

-- Expose a function to manually save a CodeCompanion buffer
local M = {}

M.save_buffer = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  save_codecompanion_buffer(bufnr)
end

return M
