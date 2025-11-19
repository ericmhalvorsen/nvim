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
    local keymaps = require "eric.keymaps"

    -- Setup commander keymap (<leader>p to open commander)
    vim.keymap.set("n", "<leader>p", commander.show, { desc = "Open commander" })

    -- Collect all keymaps from keymaps.lua
    local all_keymaps = {}

    -- Add core keymaps (editor + windows)
    vim.list_extend(all_keymaps, keymaps.core_keymaps)

    -- Add telescope keymaps
    vim.list_extend(all_keymaps, keymaps.get_telescope_keymaps())

    -- Add floaterm keymaps
    vim.list_extend(all_keymaps, keymaps.floaterm_keymaps)

    -- Note: Keymaps from plugin 'keys' fields (neo-tree, debug, conform) are
    -- automatically picked up by lazy.nvim integration

    -- Note: Buffer-local keymaps (gitsigns, LSP) are set on buffer attach
    -- and can't be globally registered, but we can still show them in commander
    -- for reference/discovery (with set = false to prevent registration)

    commander.add({
      -- Git (Gitsigns) - buffer-local, shown for reference only
      {
        desc = "Jump to next git change",
        cmd = function()
          require("gitsigns").nav_hunk "next"
        end,
        keys = { "n", "]c" },
        cat = "git",
      },
      {
        desc = "Jump to previous git change",
        cmd = function()
          require("gitsigns").nav_hunk "prev"
        end,
        keys = { "n", "[c" },
        cat = "git",
      },
      { desc = "Git stage hunk", cmd = "<cmd>Gitsigns stage_hunk<CR>", keys = { "n", "<leader>hs" }, cat = "git" },
      { desc = "Git reset hunk", cmd = "<cmd>Gitsigns reset_hunk<CR>", keys = { "n", "<leader>hr" }, cat = "git" },
      { desc = "Git Stage buffer", cmd = "<cmd>Gitsigns stage_buffer<CR>", keys = { "n", "<leader>hS" }, cat = "git" },
      { desc = "Git undo stage hunk", cmd = "<cmd>Gitsigns undo_stage_hunk<CR>", keys = { "n", "<leader>hu" }, cat = "git" },
      { desc = "Git Reset buffer", cmd = "<cmd>Gitsigns reset_buffer<CR>", keys = { "n", "<leader>hR" }, cat = "git" },
      { desc = "Git preview hunk", cmd = "<cmd>Gitsigns preview_hunk<CR>", keys = { "n", "<leader>hp" }, cat = "git" },
      { desc = "Git blame line", cmd = "<cmd>Gitsigns blame_line<CR>", keys = { "n", "<leader>hb" }, cat = "git" },
      { desc = "Git diff against index", cmd = "<cmd>Gitsigns diffthis<CR>", keys = { "n", "<leader>hd" }, cat = "git" },
      {
        desc = "Git Diff against last commit",
        cmd = function()
          require("gitsigns").diffthis "@"
        end,
        keys = { "n", "<leader>hD" },
        cat = "git",
      },
      { desc = "Toggle git show blame line", cmd = "<cmd>Gitsigns toggle_current_line_blame<CR>", keys = { "n", "<leader>tb" }, cat = "git" },
      { desc = "Toggle git show Deleted", cmd = "<cmd>Gitsigns preview_hunk_inline<CR>", keys = { "n", "<leader>tD" }, cat = "git" },

      -- LSP - buffer-local, shown for reference only
      { desc = "LSP: Rename", cmd = vim.lsp.buf.rename, keys = { "n", "grn" }, cat = "lsp" },
      { desc = "LSP: Code Action", cmd = vim.lsp.buf.code_action, keys = { "n", "gra" }, cat = "lsp" },
      { desc = "LSP: References", cmd = "<cmd>Telescope lsp_references<CR>", keys = { "n", "grr" }, cat = "lsp" },
      { desc = "LSP: Implementation", cmd = "<cmd>Telescope lsp_implementations<CR>", keys = { "n", "gri" }, cat = "lsp" },
      { desc = "LSP: Definition", cmd = "<cmd>Telescope lsp_definitions<CR>", keys = { "n", "grd" }, cat = "lsp" },
      { desc = "LSP: Declaration", cmd = vim.lsp.buf.declaration, keys = { "n", "grD" }, cat = "lsp" },
      { desc = "LSP: Document Symbols", cmd = "<cmd>Telescope lsp_document_symbols<CR>", keys = { "n", "gO" }, cat = "lsp" },
      { desc = "LSP: Workspace Symbols", cmd = "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", keys = { "n", "gW" }, cat = "lsp" },
      { desc = "LSP: Type Definition", cmd = "<cmd>Telescope lsp_type_definitions<CR>", keys = { "n", "grt" }, cat = "lsp" },
      {
        desc = "LSP: Toggle Inlay Hints",
        cmd = function()
          local bufnr = vim.api.nvim_get_current_buf()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
        end,
        keys = { "n", "<leader>th" },
        cat = "lsp",
      },
    }, { set = false })

    -- Add keymaps from keymaps.lua (these will be registered by commander)
    commander.add(all_keymaps)

    -- Uncomment below to revert to simple commander setup:
    -- commander.add({ { desc = "Open commander", cmd = commander.show, keys = { "n", "<leader>p" } } }, {})
  end,
}
