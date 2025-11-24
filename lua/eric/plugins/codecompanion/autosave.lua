-- CodeCompanion AutoSave
-- Automatically saves CodeCompanion chat buffers to disk for history/backup

local M = {}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local codecompanion_group = augroup("CodeCompanionAutoSave", { clear = true })

-- Configuration options
M.config = {
  -- Enable/disable autosave
  enabled = true,

  -- Events that trigger autosave
  triggers = {
    "BufLeave", -- When leaving the buffer
    "FocusLost", -- When Neovim loses focus
    -- Uncomment for more aggressive saving:
    -- "InsertLeave", -- After exiting insert mode
    -- "TextChanged", -- After any text change
  },

  save_dir = "~/.local/share/nvim/codecompanion/",
  notify_on_save = false,
  notify_level = vim.log.levels.DEBUG,
}

local function save_codecompanion_buffer(bufnr)
  local save_dir = vim.fn.expand(M.config.save_dir)

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  if vim.fn.isdirectory(save_dir) == 0 then
    local success = vim.fn.mkdir(save_dir, "p")
    if success ~= 1 then
      vim.notify("Failed to create directory: " .. save_dir, vim.log.levels.ERROR, { title = "CodeCompanion AutoSave" })
      return
    end
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)

  local id = bufname:match "%[CodeCompanion%] (%d+)"
  local date = os.date "+%Y-%m-%dT%H:%M:%S"
  local save_path

  if id then
    save_path = save_dir .. date .. "_codecompanion_" .. id .. ".md"
  else
    save_path = save_dir .. date .. "_codecompanion_" .. os.date "%H%M%S" .. ".md"
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local file = io.open(save_path, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()

    if M.config.notify_on_save then
      vim.notify("Saved: " .. vim.fn.fnamemodify(save_path, ":t"), M.config.notify_level, { title = "CodeCompanion AutoSave" })
    end
  else
    vim.notify("Save failed: " .. vim.fn.fnamemodify(save_path, ":~:."), vim.log.levels.ERROR, { title = "CodeCompanion AutoSave" })
  end
end

function M.setup(opts)
  if opts then
    M.config = vim.tbl_deep_extend("force", M.config, opts)
  end

  if not M.config.enabled then
    return
  end

  autocmd(M.config.triggers, {
    group = codecompanion_group,
    callback = function(args)
      local bufnr = args.buf
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      if bufname:match "%[CodeCompanion%]" then
        save_codecompanion_buffer(bufnr)
      end
    end,
  })
end

function M.save_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  save_codecompanion_buffer(bufnr)
end

vim.api.nvim_create_user_command("CodeCompanionSave", function()
  M.save_buffer()
end, {
  desc = "Manually save current CodeCompanion buffer",
})

return M
