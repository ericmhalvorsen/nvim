return {
  "FeiyouG/commander.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local commander = require "commander"
    commander.setup {
      components = {
        "DESC",
        "KEYS",
        "CAT",
      },
      sort_by = {
        "DESC",
        "KEYS",
        "CAT",
        "CMD",
      },
      separator = "|",
      prompt_title = "Commander",
      auto_replace_desc_with_cmd = true,
      integration = {
        telescope = {
          enable = true,
        },
        lazy = {
          enable = true,
          set_plugin_name_as_cat = true,
        },
      },
    }

    -- ============================================================================
    -- Keymaps are now centralized in lua/eric/keymaps.lua
    -- ============================================================================
    -- Setup commander keymap
    require("eric.keymaps").setup_commander_keymaps()

    -- Add all keymaps to commander for discoverability
    commander.add({
      -- Core Editor
      { desc = "Clear search highlighting", cmd = "<cmd>nohlsearch<CR>", keys = { "n", "<Esc>" }, cat = "editor" },
      { desc = "Open diagnostic quickfix list", cmd = vim.diagnostic.setloclist, keys = { "n", "<leader>q" }, cat = "editor" },
      { desc = "Exit terminal mode", cmd = "<C-\\><C-n>", keys = { "t", "<Esc><Esc>" }, cat = "editor" },

      -- Window Navigation
      { desc = "Move focus to left window", cmd = "<C-w><C-h>", keys = { "n", "<C-h>" }, cat = "windows" },
      { desc = "Move focus to right window", cmd = "<C-w><C-l>", keys = { "n", "<C-l>" }, cat = "windows" },
      { desc = "Move focus to lower window", cmd = "<C-w><C-j>", keys = { "n", "<C-j>" }, cat = "windows" },
      { desc = "Move focus to upper window", cmd = "<C-w><C-k>", keys = { "n", "<C-k>" }, cat = "windows" },

      -- Telescope
      { desc = "Search Help", cmd = "<cmd>Telescope help_tags<CR>", keys = { "n", "<leader>sh" }, cat = "telescope" },
      { desc = "Search Keymaps", cmd = "<cmd>Telescope keymaps<CR>", keys = { "n", "<leader>sk" }, cat = "telescope" },
      { desc = "Search Files", cmd = "<cmd>Telescope find_files<CR>", keys = { "n", "<leader>sp" }, cat = "telescope" },
      { desc = "Search Telescope pickers", cmd = "<cmd>Telescope builtin<CR>", keys = { "n", "<leader>ss" }, cat = "telescope" },
      { desc = "Search current Word", cmd = "<cmd>Telescope grep_string<CR>", keys = { "n", "<leader>sw" }, cat = "telescope" },
      { desc = "Search by Grep", cmd = "<cmd>Telescope live_grep<CR>", keys = { "n", "<leader>sf" }, cat = "telescope" },
      { desc = "Search Diagnostics", cmd = "<cmd>Telescope diagnostics<CR>", keys = { "n", "<leader>sd" }, cat = "telescope" },
      { desc = "Search Resume", cmd = "<cmd>Telescope resume<CR>", keys = { "n", "<leader>sr" }, cat = "telescope" },
      { desc = "Search Recent Files", cmd = "<cmd>Telescope oldfiles<CR>", keys = { "n", "<leader>s." }, cat = "telescope" },
      { desc = "Find existing buffers", cmd = "<cmd>Telescope buffers<CR>", keys = { "n", "<leader><leader>" }, cat = "telescope" },
      { desc = "Fuzzily search in current buffer", keys = { "n", "<leader>/" }, cat = "telescope" },
      { desc = "Search in Open Files", keys = { "n", "<leader>s/" }, cat = "telescope" },
      { desc = "Search Neovim files", keys = { "n", "<leader>sn" }, cat = "telescope" },

      -- Neo-tree
      { desc = "NeoTree reveal", cmd = "<cmd>Neotree reveal<CR>", keys = { "n", "\\" }, cat = "file-tree" },
      { desc = "NeoTree left side", cmd = "<cmd>Neotree left<CR>", keys = { "n", "<leader><C-l>" }, cat = "file-tree" },
      { desc = "NeoTree float", cmd = "<cmd>Neotree float<CR>", keys = { "n", "<leader><C-f>" }, cat = "file-tree" },

      -- Git (Gitsigns)
      { desc = "Jump to next git change", keys = { "n", "]c" }, cat = "git" },
      { desc = "Jump to previous git change", keys = { "n", "[c" }, cat = "git" },
      { desc = "Git stage hunk", keys = { "n", "<leader>hs" }, cat = "git" },
      { desc = "Git reset hunk", keys = { "n", "<leader>hr" }, cat = "git" },
      { desc = "Git Stage buffer", keys = { "n", "<leader>hS" }, cat = "git" },
      { desc = "Git undo stage hunk", keys = { "n", "<leader>hu" }, cat = "git" },
      { desc = "Git Reset buffer", keys = { "n", "<leader>hR" }, cat = "git" },
      { desc = "Git preview hunk", keys = { "n", "<leader>hp" }, cat = "git" },
      { desc = "Git blame line", keys = { "n", "<leader>hb" }, cat = "git" },
      { desc = "Git diff against index", keys = { "n", "<leader>hd" }, cat = "git" },
      { desc = "Git Diff against last commit", keys = { "n", "<leader>hD" }, cat = "git" },
      { desc = "Toggle git show blame line", keys = { "n", "<leader>tb" }, cat = "git" },
      { desc = "Toggle git show Deleted", keys = { "n", "<leader>tD" }, cat = "git" },

      -- Terminal (Floaterm)
      { desc = "Toggle terminal", cmd = "<cmd>FloatermToggle<CR>", keys = { "n", "<leader>tt" }, cat = "terminal" },
      { desc = "New terminal", cmd = "<cmd>FloatermNew<CR>", keys = { "n", "<leader>ta" }, cat = "terminal" },
      { desc = "Cycle terminal instance", cmd = "<cmd>FloatermNext<CR>", keys = { "n", "<leader>tn" }, cat = "terminal" },

      -- Debug (DAP)
      { desc = "Debug: Start/Continue", keys = { "n", "<F5>" }, cat = "debug" },
      { desc = "Debug: Step Into", keys = { "n", "<F1>" }, cat = "debug" },
      { desc = "Debug: Step Over", keys = { "n", "<F2>" }, cat = "debug" },
      { desc = "Debug: Step Out", keys = { "n", "<F3>" }, cat = "debug" },
      { desc = "Debug: Toggle Breakpoint", keys = { "n", "<leader>b" }, cat = "debug" },
      { desc = "Debug: Set Breakpoint", keys = { "n", "<leader>B" }, cat = "debug" },
      { desc = "Debug: Toggle UI", keys = { "n", "<F7>" }, cat = "debug" },

      -- Format
      { desc = "Format buffer", keys = { "n", "<leader>f" }, cat = "format" },

      -- LSP
      { desc = "LSP: Rename", keys = { "n", "grn" }, cat = "lsp" },
      { desc = "LSP: Code Action", keys = { "n", "gra" }, cat = "lsp" },
      { desc = "LSP: References", keys = { "n", "grr" }, cat = "lsp" },
      { desc = "LSP: Implementation", keys = { "n", "gri" }, cat = "lsp" },
      { desc = "LSP: Definition", keys = { "n", "grd" }, cat = "lsp" },
      { desc = "LSP: Declaration", keys = { "n", "grD" }, cat = "lsp" },
      { desc = "LSP: Document Symbols", keys = { "n", "gO" }, cat = "lsp" },
      { desc = "LSP: Workspace Symbols", keys = { "n", "gW" }, cat = "lsp" },
      { desc = "LSP: Type Definition", keys = { "n", "grt" }, cat = "lsp" },
      { desc = "LSP: Toggle Inlay Hints", keys = { "n", "<leader>th" }, cat = "lsp" },
    }, {})

    -- Uncomment below to revert to simple commander setup:
    -- commander.add({ { desc = "Open commander", cmd = commander.show, keys = { "n", "<leader>p" } } }, {})
  end,
}
