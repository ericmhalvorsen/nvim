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
    -- set = false prevents double registration since keymaps are already set in keymaps.lua
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
      {
        desc = "Fuzzily search in current buffer",
        cmd = function()
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        keys = { "n", "<leader>/" },
        cat = "telescope",
      },
      {
        desc = "Search in Open Files",
        cmd = function()
          require("telescope.builtin").live_grep {
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          }
        end,
        keys = { "n", "<leader>s/" },
        cat = "telescope",
      },
      {
        desc = "Search Neovim files",
        cmd = function()
          require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" }
        end,
        keys = { "n", "<leader>sn" },
        cat = "telescope",
      },

      -- Neo-tree
      { desc = "NeoTree reveal", cmd = "<cmd>Neotree reveal<CR>", keys = { "n", "\\" }, cat = "file-tree" },
      { desc = "NeoTree left side", cmd = "<cmd>Neotree left<CR>", keys = { "n", "<leader><C-l>" }, cat = "file-tree" },
      { desc = "NeoTree float", cmd = "<cmd>Neotree float<CR>", keys = { "n", "<leader><C-f>" }, cat = "file-tree" },

      -- Git (Gitsigns) - These are buffer-local so we show them for reference
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

      -- Terminal (Floaterm)
      { desc = "Toggle terminal", cmd = "<cmd>FloatermToggle<CR>", keys = { "n", "<leader>tt" }, cat = "terminal" },
      { desc = "New terminal", cmd = "<cmd>FloatermNew<CR>", keys = { "n", "<leader>ta" }, cat = "terminal" },
      { desc = "Cycle terminal instance", cmd = "<cmd>FloatermNext<CR>", keys = { "n", "<leader>tn" }, cat = "terminal" },

      -- Debug (DAP)
      {
        desc = "Debug: Start/Continue",
        cmd = function()
          require("dap").continue()
        end,
        keys = { "n", "<F5>" },
        cat = "debug",
      },
      {
        desc = "Debug: Step Into",
        cmd = function()
          require("dap").step_into()
        end,
        keys = { "n", "<F1>" },
        cat = "debug",
      },
      {
        desc = "Debug: Step Over",
        cmd = function()
          require("dap").step_over()
        end,
        keys = { "n", "<F2>" },
        cat = "debug",
      },
      {
        desc = "Debug: Step Out",
        cmd = function()
          require("dap").step_out()
        end,
        keys = { "n", "<F3>" },
        cat = "debug",
      },
      {
        desc = "Debug: Toggle Breakpoint",
        cmd = function()
          require("dap").toggle_breakpoint()
        end,
        keys = { "n", "<leader>b" },
        cat = "debug",
      },
      {
        desc = "Debug: Set Breakpoint",
        cmd = function()
          require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end,
        keys = { "n", "<leader>B" },
        cat = "debug",
      },
      {
        desc = "Debug: Toggle UI",
        cmd = function()
          require("dapui").toggle()
        end,
        keys = { "n", "<F7>" },
        cat = "debug",
      },

      -- Format
      {
        desc = "Format buffer",
        cmd = function()
          require("conform").format { async = true, lsp_format = "fallback" }
        end,
        keys = { "n", "<leader>f" },
        cat = "format",
      },

      -- LSP (These are buffer-local and set on LspAttach, shown here for reference)
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

    -- Uncomment below to revert to simple commander setup:
    -- commander.add({ { desc = "Open commander", cmd = commander.show, keys = { "n", "<leader>p" } } }, {})
  end,
}
