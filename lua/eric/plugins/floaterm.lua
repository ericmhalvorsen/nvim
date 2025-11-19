return {
  "voldikss/vim-floaterm",
  -- ============================================================================
  -- Keymaps are now centralized in lua/eric/keymaps.lua
  -- ============================================================================
  -- Keymaps are registered by commander.nvim (see lua/eric/plugins/commander.lua)
  --
  -- Uncomment below to revert to inline keymaps:
  -- config = function()
  --   vim.keymap.set("n", "<leader>tt", vim.cmd.FloatermToggle, { desc = "Hide / Show terminal" })
  --   vim.keymap.set("n", "<leader>ta", vim.cmd.FloatermNew, { desc = "New terminal" })
  --   vim.keymap.set("n", "<leader>tn", vim.cmd.FloatermNext, { desc = "Cycle terminal instance" })
  -- end,
}
