-- ============================================================================
-- Centralized Keymaps Configuration
-- ============================================================================
-- All keymaps are defined here for easy discovery and management
-- Individual plugin files have their keymaps commented out for reference

local M = {}

-- ============================================================================
-- Core Editor Keymaps
-- ============================================================================

function M.setup_core_keymaps()
  -- Clear search highlighting
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

  -- Diagnostic quickfix list
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

  -- Terminal mode escape
  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

  -- Window navigation
  vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
  vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
  vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
end

-- ============================================================================
-- Telescope Keymaps
-- ============================================================================

function M.setup_telescope_keymaps()
  local builtin = require "telescope.builtin"

  vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
  vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
  vim.keymap.set("n", "<leader>sp", builtin.find_files, { desc = "[S]earch [F]iles" })
  vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
  vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
  vim.keymap.set("n", "<leader>sf", builtin.live_grep, { desc = "[S]earch by [G]rep" })
  vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
  vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
  vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

  -- Search in current buffer
  vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = "[/] Fuzzily search in current buffer" })

  -- Search in open files
  vim.keymap.set("n", "<leader>s/", function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    }
  end, { desc = "[S]earch [/] in Open Files" })

  -- Search Neovim config
  vim.keymap.set("n", "<leader>sn", function()
    builtin.find_files { cwd = vim.fn.stdpath "config" }
  end, { desc = "[S]earch [N]eovim files" })
end

-- ============================================================================
-- Neo-tree Keymaps
-- ============================================================================

function M.get_neotree_keys()
  return {
    { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
    { "<leader><c-l>", ":Neotree left<CR>", desc = "Show NeoTree on left side", silent = true },
    { "<leader><c-f>", ":Neotree float<CR>", desc = "Float NeoTree (default)", silent = true },
  }
end

-- ============================================================================
-- Git (Gitsigns) Keymaps
-- ============================================================================

function M.setup_gitsigns_keymaps(bufnr)
  local gitsigns = require "gitsigns"

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal { "]c", bang = true }
    else
      gitsigns.nav_hunk "next"
    end
  end, { desc = "Jump to next git [c]hange" })

  map("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal { "[c", bang = true }
    else
      gitsigns.nav_hunk "prev"
    end
  end, { desc = "Jump to previous git [c]hange" })

  -- Actions
  -- visual mode
  map("v", "<leader>hs", function()
    gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "git [s]tage hunk" })
  map("v", "<leader>hr", function()
    gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "git [r]eset hunk" })
  -- normal mode
  map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
  map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
  map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
  map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
  map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
  map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
  map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
  map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
  map("n", "<leader>hD", function()
    gitsigns.diffthis "@"
  end, { desc = "git [D]iff against last commit" })
  -- Toggles
  map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
  map("n", "<leader>tD", gitsigns.preview_hunk_inline, { desc = "[T]oggle git show [D]eleted" })
end

-- ============================================================================
-- Terminal (Floaterm) Keymaps
-- ============================================================================

function M.setup_floaterm_keymaps()
  vim.keymap.set("n", "<leader>tt", vim.cmd.FloatermToggle, { desc = "Hide / Show terminal" })
  vim.keymap.set("n", "<leader>ta", vim.cmd.FloatermNew, { desc = "New terminal" })
  vim.keymap.set("n", "<leader>tn", vim.cmd.FloatermNext, { desc = "Cycle terminal instance" })
end

-- ============================================================================
-- Debug (DAP) Keymaps
-- ============================================================================

function M.get_debug_keys()
  return {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<F1>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F2>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F3>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>b",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>B",
      function()
        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end,
      desc = "Debug: Set Breakpoint",
    },
    {
      "<F7>",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: See last session result.",
    },
  }
end

-- ============================================================================
-- Format (Conform) Keymaps
-- ============================================================================

function M.get_conform_keys()
  return {
    {
      "<leader>f",
      function()
        require("conform").format { async = true, lsp_format = "fallback" }
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  }
end

-- ============================================================================
-- LSP Keymaps
-- ============================================================================

function M.setup_lsp_keymaps(event)
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
  end

  map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
  map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
  map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
  map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
  map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
  map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

  -- Inlay hints toggle (conditionally added based on LSP capability)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client then
    -- Check for inlay hint support
    local function client_supports_method(client, method, bufnr)
      if vim.fn.has "nvim-0.11" == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, "[T]oggle Inlay [H]ints")
    end
  end
end

-- ============================================================================
-- Commander Keymaps
-- ============================================================================

function M.setup_commander_keymaps()
  local commander = require "commander"
  vim.keymap.set("n", "<leader>p", commander.show, { desc = "Open commander" })
end

-- ============================================================================
-- Initialize All Keymaps
-- ============================================================================

function M.setup()
  M.setup_core_keymaps()
end

return M
