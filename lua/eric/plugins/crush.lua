-- Crush - Terminal-based AI coding agent by Charm
-- https://github.com/charmbracelet/crush
-- Install: brew install charmbracelet/tap/crush
-- Configure models in ~/.config/crush/config.json
return {
  "gitsang/crush.nvim",
  cmd = { "Crush" },
  opts = {
    width = 60, -- Width of the vertical split
    crush_cmd = "crush --yolo", -- Command to run in the terminal
  },
  keys = {
    { "<leader>C", "<cmd>Crush<cr>", desc = "Toggle Crush" },
  },
}
