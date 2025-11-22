-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

local function keymap(modes, key, command, opts)
  for _, mode in ipairs(modes) do
    map(mode, key, command, opts)
  end
end

-- Movement
keymap({ "n", "x", "o" }, ";", "$", { desc = "Go to End of Line", remap = true })

-- Pum
if vim.o.wildoptions:match("pum") then
  vim.api.nvim_set_keymap("c", "<Up>", [[pumvisible() ? '<Left>' : '<Up>']], { expr = true })
  vim.api.nvim_set_keymap("c", "<Down>", [[pumvisible() ? '<Right>' : '<Down>']], { expr = true })
end

-- Diagnostics
keymap({ "n" }, "K", vim.diagnostic.open_float, { desc = "Line Diagnostics", remap = true })

-- Disabled
vim.keymap.del({ "n", "i", "v" }, "<A-j>")
vim.keymap.del({ "n", "i", "v" }, "<A-k>")
