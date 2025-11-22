local M = {} -- Why M? I dunno too lazy to look it up

-- Global registry of all keymaps for commander integration
M.registered_keymaps = {}

function M.register_keymap(category, mode, lhs, rhs, opts, bufnr)
  opts = opts or {}
  if bufnr then
    opts.buffer = bufnr
  end

  vim.keymap.set(mode, lhs, rhs, opts)

  local keymap_entry = {
    desc = opts.desc or "",
    cmd = rhs,
    keys = { mode, lhs },
    cat = category,
    set = not bufnr, -- Buffer-local keymaps have set = false for commander
  }

  table.insert(M.registered_keymaps, keymap_entry)
end

function M.add_core_keymaps()
  M.register_keymap("editor", "n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
  M.register_keymap("editor", "n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })
  M.register_keymap("editor", "t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

  M.register_keymap("windows", "n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to left window" })
  M.register_keymap("windows", "n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to right window" })
  M.register_keymap("windows", "n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to lower window" })
  M.register_keymap("windows", "n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to upper window" })

  M.register_keymap(
    "telescope",
    "n",
    "<leader>sw",
    "<cmd>lua require('telescope.builtin').grep_string({search = vim.fn.expand(\"<cword>\")})<cr>",
    { desc = "Search for word under the cursor" }
  )
end

function M.add_telescope_keymaps()
  local builtin = require "telescope.builtin"

  M.register_keymap("telescope", "n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
  M.register_keymap("telescope", "n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
  M.register_keymap("telescope", "n", "<leader>sp", builtin.find_files, { desc = "Search Files" })
  M.register_keymap("telescope", "n", "<leader>ss", builtin.builtin, { desc = "Search Select Telescope" })
  M.register_keymap("telescope", "n", "<leader>sw", builtin.grep_string, { desc = "Search current Word" })
  M.register_keymap("telescope", "n", "<leader>sf", builtin.live_grep, { desc = "Search by Grep" })
  M.register_keymap("telescope", "n", "<leader>sd", builtin.diagnostics, { desc = "Search Diagnostics" })
  M.register_keymap("telescope", "n", "<leader>sr", builtin.resume, { desc = "Search Resume" })
  M.register_keymap("telescope", "n", "<leader>s.", builtin.oldfiles, { desc = "Search Recent Files" })
  M.register_keymap("telescope", "n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })
  M.register_keymap("telescope", "n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = "Fuzzily search in current buffer" })
  M.register_keymap("telescope", "n", "<leader>s/", function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    }
  end, { desc = "Search in Open Files" })
  M.register_keymap("telescope", "n", "<leader>sn", function()
    builtin.find_files { cwd = vim.fn.stdpath "config" }
  end, { desc = "Search Neovim files" })
end

function M.get_neotree_keys()
  return {
    { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
    { "<leader><c-l>", ":Neotree left<CR>", desc = "Show NeoTree on left side", silent = true },
    { "<leader><c-f>", ":Neotree float<CR>", desc = "Float NeoTree (default)", silent = true },
  }
end

function M.add_gitsigns_keymaps(bufnr)
  local gitsigns = require "gitsigns"

  M.register_keymap("git", "n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal { "]c", bang = true }
    else
      gitsigns.nav_hunk "next"
    end
  end, { desc = "Jump to next git change" }, bufnr)

  M.register_keymap("git", "n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal { "[c", bang = true }
    else
      gitsigns.nav_hunk "prev"
    end
  end, { desc = "Jump to previous git change" }, bufnr)

  M.register_keymap("git", "v", "<leader>hs", function()
    gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Git stage hunk" }, bufnr)
  M.register_keymap("git", "v", "<leader>hr", function()
    gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
  end, { desc = "Git reset hunk" }, bufnr)
  M.register_keymap("git", "n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git stage hunk" }, bufnr)
  M.register_keymap("git", "n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git reset hunk" }, bufnr)
  M.register_keymap("git", "n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git Stage buffer" }, bufnr)
  M.register_keymap("git", "n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git Reset buffer" }, bufnr)
  M.register_keymap("git", "n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git preview hunk" }, bufnr)
  M.register_keymap("git", "n", "<leader>hb", gitsigns.blame_line, { desc = "Git blame line" }, bufnr)
  M.register_keymap("git", "n", "<leader>hd", gitsigns.diffthis, { desc = "Git diff against index" }, bufnr)
  M.register_keymap("git", "n", "<leader>hD", function()
    gitsigns.diffthis "@"
  end, { desc = "Git Diff against last commit" }, bufnr)
  M.register_keymap("git", "n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle git show blame line" }, bufnr)
  M.register_keymap("git", "n", "<leader>tD", gitsigns.preview_hunk_inline, { desc = "Toggle git show Deleted" }, bufnr)
end

function M.add_floaterm_keymaps()
  M.register_keymap("terminal", "n", "<leader>tt", vim.cmd.FloatermToggle, { desc = "Toggle terminal" })
  M.register_keymap("terminal", "n", "<leader>ta", vim.cmd.FloatermNew, { desc = "New terminal" })
  M.register_keymap("terminal", "n", "<leader>tn", vim.cmd.FloatermNext, { desc = "Cycle terminal instance" })
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

function M.add_lsp_keymaps(event)
  M.register_keymap("lsp", "n", "grn", vim.lsp.buf.rename, { desc = "LSP: Rename" }, event.buf)
  M.register_keymap("lsp", { "n", "x" }, "gra", vim.lsp.buf.code_action, { desc = "LSP: Code Action" }, event.buf)
  M.register_keymap("lsp", "n", "grr", require("telescope.builtin").lsp_references, { desc = "LSP: References" }, event.buf)
  M.register_keymap("lsp", "n", "gri", require("telescope.builtin").lsp_implementations, { desc = "LSP: Implementation" }, event.buf)
  M.register_keymap("lsp", "n", "grd", require("telescope.builtin").lsp_definitions, { desc = "LSP: Definition" }, event.buf)
  M.register_keymap("lsp", "n", "grD", vim.lsp.buf.declaration, { desc = "LSP: Declaration" }, event.buf)
  M.register_keymap("lsp", "n", "gO", require("telescope.builtin").lsp_document_symbols, { desc = "LSP: Document Symbols" }, event.buf)
  M.register_keymap("lsp", "n", "gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "LSP: Workspace Symbols" }, event.buf)
  M.register_keymap("lsp", "n", "grt", require("telescope.builtin").lsp_type_definitions, { desc = "LSP: Type Definition" }, event.buf)

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
      M.register_keymap("lsp", "n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, { desc = "LSP: Toggle Inlay Hints" }, event.buf)
    end
  end
end

function M.add_commander_keymaps()
  local commander = require "commander"
  M.register_keymap("commander", "n", "<leader>p", commander.show, { desc = "Open commander" })
end

function M.add_database_keymaps()
  -- Main database UI toggle (defined in dadbod.lua plugin keys, registered here for commander)
  M.register_keymap("database", "n", "<leader>D", "<cmd>DBUIToggle<CR>", { desc = "Toggle database UI" })

  -- Additional database commands (these are available but not bound to keys by default)
  -- Uncomment if you want quick access to these commands:
  -- M.register_keymap("database", "n", "<leader>Da", "<cmd>DBUIAddConnection<CR>", { desc = "Add database connection" })
  -- M.register_keymap("database", "n", "<leader>Df", "<cmd>DBUIFindBuffer<CR>", { desc = "Find database buffer" })
  -- M.register_keymap("database", "n", "<leader>Dl", "<cmd>DBUILastQueryInfo<CR>", { desc = "Last query info" })
end

function M.add_yank_keymaps()
  -- Yank history picker (defined in yanky.lua plugin keys, registered here for commander)
  M.register_keymap("yank", "n", "<leader>y", "<cmd>Telescope yank_history<CR>", { desc = "Open yank history" })
  M.register_keymap("yank", "x", "<leader>y", "<cmd>Telescope yank_history<CR>", { desc = "Open yank history" })

  -- Note: The enhanced paste operations (p, P, gp, gP) and cycle keymaps (<c-p>, <c-n>)
  -- are defined in yanky.lua plugin keys as they need to be available immediately on plugin load.
  -- They work through Yanky's <Plug> mappings which are automatically registered.
end

function M.add_ecolog_keymaps()
  -- Environment variable management (defined in ecolog.lua plugin keys, registered here for commander)
  M.register_keymap("environment", "n", "<leader>ge", "<cmd>EcologGoto<cr>", { desc = "Go to env file" })
  M.register_keymap("environment", "n", "<leader>ep", "<cmd>EcologPeek<cr>", { desc = "Peek env variable value" })
  M.register_keymap("environment", "n", "<leader>es", "<cmd>EcologSelect<cr>", { desc = "Select/switch env file" })
  M.register_keymap("environment", "n", "<leader>et", "<cmd>EcologShelterToggle<cr>", { desc = "Toggle env value masking" })
end

function M.add_codecompanion_keymaps()
  M.register_keymap("ai", { "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
  M.register_keymap("ai", { "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })
  M.register_keymap("ai", "v", "<LocalLeader>aa", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to chat" })
  M.register_keymap("ai", { "n", "v" }, "<LocalLeader>ai", "<cmd>CodeCompanion<cr>", { desc = "Inline AI assistant" })
  M.register_keymap("ai", "n", "<LocalLeader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "New CodeCompanion chat" })

  vim.cmd [[cab cc CodeCompanion]]
end

function M.get_codecompanion_chat_keys()
  return {
    send = {
      modes = { n = "<C-s>", i = "<C-s>" },
      index = 1,
      callback = "keymaps.send",
      description = "Send message",
    },
    close = {
      modes = { n = "q", i = "<C-c>" },
      index = 2,
      callback = "keymaps.close",
      description = "Close chat",
    },
    stop = {
      modes = { n = "<C-c>" },
      index = 3,
      callback = "keymaps.stop",
      description = "Stop request",
    },
    regenerate = {
      modes = { n = "gr" },
      index = 4,
      callback = "keymaps.regenerate",
      description = "Regenerate response",
    },
    codeblock = {
      modes = { n = "gc" },
      index = 5,
      callback = "keymaps.codeblock",
      description = "Insert codeblock",
    },
    yank_code = {
      modes = { n = "gy" },
      index = 6,
      callback = "keymaps.yank_code",
      description = "Yank code",
    },
    next_chat = {
      modes = { n = "}" },
      index = 7,
      callback = "keymaps.next_chat",
      description = "Next chat",
    },
    previous_chat = {
      modes = { n = "{" },
      index = 8,
      callback = "keymaps.previous_chat",
      description = "Previous chat",
    },
    next_header = {
      modes = { n = "]]" },
      index = 9,
      callback = "keymaps.next_header",
      description = "Next header",
    },
    previous_header = {
      modes = { n = "[[" },
      index = 10,
      callback = "keymaps.previous_header",
      description = "Previous header",
    },
  }
end

function M.get_codecompanion_inline_keys()
  return {
    accept_change = {
      modes = { n = "ga" },
      index = 1,
      callback = "keymaps.accept_change",
      description = "Accept change",
    },
    reject_change = {
      modes = { n = "gr" },
      index = 2,
      callback = "keymaps.reject_change",
      description = "Reject change",
      opts = { nowait = true },
    },
  }
end

function M.add_ufo_keymaps()
  M.register_keymap("folding", "n", "zR", function()
    require("ufo").openAllFolds()
  end, { desc = "Open all folds" })
  M.register_keymap("folding", "n", "zM", function()
    require("ufo").closeAllFolds()
  end, { desc = "Close all folds" })
end

function M.setup()
  M.add_telescope_keymaps()
  M.add_core_keymaps()
  M.add_floaterm_keymaps()
  M.add_commander_keymaps()
  M.add_codecompanion_keymaps()
  M.add_ufo_keymaps()

  local keymaps = require "eric.keymaps"
  require("commander").add(keymaps.registered_keymaps, {})
end

return M
