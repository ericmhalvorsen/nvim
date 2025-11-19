return {
  "voldikss/vim-floaterm",
  config = function()
    -- ============================================================================
    -- Keymaps are now centralized in lua/eric/keymaps.lua
    -- ============================================================================
    require("eric.keymaps").setup_floaterm_keymaps()

    -- Uncomment below to revert to inline keymaps:
    -- vim.keymap.set("n", "<leader>tt", vim.cmd.FloatermToggle, { desc = "Hide / Show terminal" })
    -- vim.keymap.set("n", "<leader>ta", vim.cmd.FloatermNew, { desc = "New terminal" })
    -- vim.keymap.set("n", "<leader>tn", vim.cmd.FloatermNext, { desc = "Cycle terminal instance" })
  end,
}
