local M = {} -- Why M? I dunno too lazy to look it up

function map_key(mode, l, r, opts, bufnr)
  opts = opts or {}
  if bufnr then
    opts.buffer = bufnr
  end
  vim.keymap.set(mode, l, r, opts)
end

function M.setup_core_keymaps()
  map_key("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
  map_key("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
  map_key("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

  map_key("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
  map_key("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
  map_key("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
  map_key("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
end

function M.setup_telescope_keymaps()
  local builtin = require "telescope.builtin"

  map_key("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
  map_key("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
  map_key("n", "<leader>sp", builtin.find_files, { desc = "[S]earch [F]iles" })
  map_key("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
  map_key("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
  map_key("n", "<leader>sf", builtin.live_grep, { desc = "[S]earch by [G]rep" })
  map_key("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
  map_key("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
  map_key("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  map_key("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
  map_key("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = "[/] Fuzzily search in current buffer" })
  map_key("n", "<leader>s/", function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    }
  end, { desc = "[S]earch [/] in Open Files" })
  map_key("n", "<leader>sn", function()
    builtin.find_files { cwd = vim.fn.stdpath "config" }
  end, { desc = "[S]earch [N]eovim files" })
end

function M.get_neotree_keys()
  return {
    { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
    { "<leader><c-l>", ":Neotree left<CR>", desc = "Show NeoTree on left side", silent = true },
    { "<leader><c-f>", ":Neotree float<CR>", desc = "Float NeoTree (default)", silent = true },
  }
end

function M.setup_gitsigns_keymaps(bufnr)
  local gitsigns = require "gitsigns"

  map_key("n", "]c", function()
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
  end, { desc = "Jump to previous git [c]hange" }, bufnr)

  map_key("v", "<leader>hs", function()
    gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "git [s]tage hunk" }, bufnr)
  map_key("v", "<leader>hr", function()
    gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "git [r]eset hunk" }, bufnr)
  map_key("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" }, bufnr)
  map_key("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" }, bufnr)
  map_key("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" }, bufnr)
  -- map_key("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" }, bufnr) -- deprecated
  map_key("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" }, bufnr)
  map_key("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" }, bufnr)
  map_key("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" }, bufnr)
  map_key("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" }, bufnr)
  map_key("n", "<leader>hD", function()
    gitsigns.diffthis "@"
  end, { desc = "git [D]iff against last commit" }, bufnr)
  map_key("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" }, bufnr)
  map_key("n", "<leader>tD", gitsigns.preview_hunk_inline, { desc = "[T]oggle git show [D]eleted" }, bufnr)
end

function M.setup_floaterm_keymaps()
  map_key("n", "<leader>tt", vim.cmd.FloatermToggle, { desc = "Hide / Show terminal" })
  map_key("n", "<leader>ta", vim.cmd.FloatermNew, { desc = "New terminal" })
  map_key("n", "<leader>tn", vim.cmd.FloatermNext, { desc = "Cycle terminal instance" })
end

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


function M.setup_lsp_keymaps(event)
  map_key("n", "grn", vim.lsp.buf.rename, { buffer = event.buf, desc = "LSP: [R]e[n]ame" })
  map_key({ "n", "x" }, "gra", vim.lsp.buf.code_action, { buffer = event.buf, desc = "LSP: [G]oto Code [A]ction" })
  map_key("n", "grr", require("telescope.builtin").lsp_references, { buffer = event.buf, desc = "LSP: [G]oto [R]eferences" })
  map_key("n", "gri", require("telescope.builtin").lsp_implementations, { buffer = event.buf, desc = "LSP: [G]oto [I]mplementation" })
  map_key("n", "grd", require("telescope.builtin").lsp_definitions, { buffer = event.buf, desc = "LSP: [G]oto [D]efinition" })
  map_key("n", "grD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "LSP: [G]oto [D]eclaration" })
  map_key("n", "gO", require("telescope.builtin").lsp_document_symbols, { buffer = event.buf, desc = "LSP: [Open Document Symbols" })
  map_key("n", "gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, { buffer = event.buf, desc = "LSP: Open Workspace Symbols" })
  map_key("n", "grt", require("telescope.builtin").lsp_type_definitions, { buffer = event.buf, desc = "LSP: [G]oto [T]ype Definition" })

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client then
    local function client_supports_method(c, method, bufnr)
      if vim.fn.has "nvim-0.11" == 1 then
        return c.supports_method(method, bufnr)
      else
        return c.supports_method(method, { bufnr = bufnr })
      end
    end

    if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map_key("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, "[T]oggle Inlay [H]ints")
    end
  end
end

function M.setup_commander_keymaps()
  local commander = require "commander"
  map_key("n", "<leader>p", commander.show, { desc = "Open commander" })
end

function M.setup()
  M.setup_core_keymaps()
end

return M
