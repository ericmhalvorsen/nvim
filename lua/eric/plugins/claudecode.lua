-- Claude Code Integration
-- Official Claude Code plugin for Neovim
-- Uses your claude-wrapper executable for seamless integration

return {
  "coder/claudecode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  opts = {
    -- Use your claude-wrapper executable
    claude_executable = "claude-wrapper",

    -- Optional: Additional configuration
    -- auto_open = false,  -- Don't auto-open on start
    -- position = "right", -- Position of the panel
  },
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
  },
}
