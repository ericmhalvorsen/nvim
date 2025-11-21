return {
  "gbprod/yanky.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
  },
  event = "VeryLazy",
  keys = {
    -- Yank history picker with Telescope
    { "<leader>y", "<cmd>Telescope yank_history<CR>", desc = "Open yank history", mode = { "n", "x" } },

    -- Enhanced paste operations
    { "p", "<Plug>(YankyPutAfter)", desc = "Put after cursor", mode = { "n", "x" } },
    { "P", "<Plug>(YankyPutBefore)", desc = "Put before cursor", mode = { "n", "x" } },
    { "gp", "<Plug>(YankyGPutAfter)", desc = "Put after and leave cursor after", mode = { "n", "x" } },
    { "gP", "<Plug>(YankyGPutBefore)", desc = "Put before and leave cursor after", mode = { "n", "x" } },

    -- Cycle through yank history
    { "<c-p>", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
    { "<c-n>", "<Plug>(YankyPreviousEntry)", desc = "Cycle backward through yank history" },

    -- Put with indentation
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },

    -- Put with shift right/left
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and shift right" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and shift left" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and shift right" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and shift left" },

    -- Put with filter (useful for formatting)
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after with filter" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before with filter" },
  },
  opts = {
    ring = {
      -- Number of yank history entries to keep
      history_length = 100,

      -- Storage method: "shada" (persistent), "sqlite", or "memory" (session only)
      storage = "shada",

      -- Sync with numbered registers (1-9)
      sync_with_numbered_registers = true,

      -- When to cancel yank ring cycling ("update" | "move")
      cancel_event = "update",

      -- Registers to ignore (black hole register by default)
      ignore_registers = { "_" },

      -- Update default register while cycling
      update_register_on_cycle = false,
    },

    -- Integrate system clipboard with yank ring
    system_clipboard = {
      -- Add external clipboard yanks to history
      sync_with_ring = true,
    },

    -- Highlight yanked and pasted text
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 300, -- Highlight duration in ms
    },

    -- Preserve cursor position
    preserve_cursor_position = {
      enabled = true,
    },

    -- Text object for yanked content (disabled by default)
    textobj = {
      enabled = false,
    },

    -- Telescope picker configuration
    picker = {
      select = {
        action = nil, -- Use default action
      },
      telescope = {
        use_default_mappings = true, -- Use telescope default mappings in picker
        mappings = nil, -- Custom mappings for picker (nil = use defaults)
      },
    },
  },
  config = function(_, opts)
    require("yanky").setup(opts)

    -- Register the yank_history picker with Telescope
    require("telescope").load_extension "yank_history"
  end,
}
