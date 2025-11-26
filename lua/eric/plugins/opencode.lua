-- OpenCode.nvim - Claude Code AI Assistant Integration
-- Provides editor-aware research, reviews, and requests with Claude Code
-- Docs: https://github.com/NickvanDyke/opencode.nvim

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim", -- For improved input and select UI
  },
  config = function()
    -- Enable autoread so buffers reload when opencode makes edits
    vim.o.autoread = true

    -- Configure opencode
    vim.g.opencode_opts = {
      -- Provider configuration (uses snacks.terminal by default)
      provider = "snacks.terminal",

      -- Custom prompts in addition to built-in ones
      -- Built-in prompts: diagnostics, diff, document, explain, fix, optimize, review, test
      prompts = {
        -- You can add custom prompts here
        -- ["custom"] = "Your custom prompt here with @this, @buffer, etc.",
      },

      -- Context placeholder configuration (optional)
      -- Available placeholders:
      -- @this        - Visual selection or cursor position
      -- @buffer      - Current buffer content
      -- @buffers     - All open buffers
      -- @visible     - Visible text on screen
      -- @diagnostics - Current buffer diagnostics
      -- @quickfix    - Quickfix list items
      -- @diff        - Git diff output
      -- @grapple     - grapple.nvim tags (if installed)
    }

    -- Set up autocmds for opencode events if needed
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "OpencodeEvent",
    --   callback = function(ev)
    --     -- Handle opencode Server-Sent-Events
    --     -- ev.data contains the event data
    --   end,
    -- })
  end,
}
