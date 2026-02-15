local M = {} -- Why M? I dunno too lazy to look it up

-- Global registry of all keymaps
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
    set = not bufnr,
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
end

function M.add_telescope_keymaps()
  M.register_keymap("telescope", "n", "<leader>shi", function()
    require("telescope.builtin").search_history()
  end, { desc = "Search History" })
  M.register_keymap("telescope", "n", "<leader>she", function()
    require("telescope.builtin").help_tags()
  end, { desc = "Search Help" })
  M.register_keymap("telescope", "n", "<leader>sk", function()
    require("telescope.builtin").keymaps()
  end, { desc = "Search Keymaps" })
  M.register_keymap("telescope", "n", "<leader>sp", function()
    require("telescope.builtin").find_files()
  end, { desc = "Search Files" })
  M.register_keymap("telescope", "n", "<leader>ss", function()
    require("telescope.builtin").builtin()
  end, { desc = "Search Select Telescope" })
  M.register_keymap("telescope", { "n", "v" }, "<leader>sW", function()
    require("telescope.builtin").grep_string()
  end, { desc = "Search current Word" })
  M.register_keymap("telescope", "n", "<leader>sf", function()
    require("telescope.builtin").live_grep { additional_args = { "--fixed-strings" }, prompt_title = "Search All" }
  end, { desc = "Search All " })
  M.register_keymap("telescope", "n", "<leader>sF", function()
    require("telescope.builtin").live_grep { prompt_title = "Search All (Grep)" }
  end, { desc = "Search All (Grep)" })
  M.register_keymap("telescope", "n", "<leader>sd", function()
    require("telescope.builtin").diagnostics()
  end, { desc = "Search Diagnostics" })
  M.register_keymap("telescope", "n", "<leader>sr", function()
    require("telescope.builtin").resume()
  end, { desc = "Search Resume" })
  M.register_keymap("telescope", "n", "<leader>sc", function()
    require("colorscheme-persist").picker()
  end, { desc = "Select colorscheme" })
  M.register_keymap("telescope", "n", "<leader>s.", function()
    require("telescope.builtin").oldfiles()
  end, { desc = "Search Recent Files" })
  M.register_keymap("telescope", "n", "<leader><leader>", function()
    require("telescope.builtin").buffers()
  end, { desc = "Find existing buffers" })
  M.register_keymap("telescope", "n", "<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = "Fuzzily search in current buffer" })
  M.register_keymap("telescope", "n", "<leader>s/", function()
    require("telescope.builtin").live_grep {
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    }
  end, { desc = "Search in Open Files" })
  M.register_keymap("telescope", "n", "<leader>sn", function()
    require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" }
  end, { desc = "Search Neovim files" })
end

function M.add_spectre_keymaps()
  M.register_keymap("spectre", "n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre",
  })
  M.register_keymap("spectre", "n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word",
  })
  M.register_keymap("spectre", "v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word",
  })
  -- M.register_keymap("spectre", "n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  --   desc = "Search on current file",
  -- })
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
  M.register_keymap("lsp", "n", "grr", function()
    require("telescope.builtin").lsp_references()
  end, { desc = "LSP: References" }, event.buf)
  M.register_keymap("lsp", "n", "gri", function()
    require("telescope.builtin").lsp_implementations()
  end, { desc = "LSP: Implementation" }, event.buf)
  M.register_keymap("lsp", "n", "grd", function()
    require("telescope.builtin").lsp_definitions()
  end, { desc = "LSP: Definition" }, event.buf)
  M.register_keymap("lsp", "n", "grD", vim.lsp.buf.declaration, { desc = "LSP: Declaration" }, event.buf)
  M.register_keymap("lsp", "n", "gO", function()
    require("telescope.builtin").lsp_document_symbols()
  end, { desc = "LSP: Document Symbols" }, event.buf)
  M.register_keymap("lsp", "n", "gW", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols()
  end, { desc = "LSP: Workspace Symbols" }, event.buf)
  M.register_keymap("lsp", "n", "grt", function()
    require("telescope.builtin").lsp_type_definitions()
  end, { desc = "LSP: Type Definition" }, event.buf)

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

function M.add_database_keymaps()
  -- Main database UI toggle
  M.register_keymap("database", "n", "<leader>D", "<cmd>DBUIToggle<CR>", { desc = "Toggle database UI" })

  -- Additional database commands (these are available but not bound to keys by default)
  -- Uncomment if you want quick access to these commands:
  -- M.register_keymap("database", "n", "<leader>Da", "<cmd>DBUIAddConnection<CR>", { desc = "Add database connection" })
  -- M.register_keymap("database", "n", "<leader>Df", "<cmd>DBUIFindBuffer<CR>", { desc = "Find database buffer" })
  -- M.register_keymap("database", "n", "<leader>Dl", "<cmd>DBUILastQueryInfo<CR>", { desc = "Last query info" })
end

function M.add_yank_keymaps()
  -- Yank history picker
  M.register_keymap("yank", { "n", "x" }, "<leader>y", "<cmd>Telescope yank_history<CR>", { desc = "Open yank history" })

  -- Note: The enhanced paste operations (p, P, gp, gP) and cycle keymaps (<c-p>, <c-n>)
  -- are defined in yanky.lua plugin keys as they need to be available immediately on plugin load.
  -- They work through Yanky's <Plug> mappings which are automatically registered.
end

function M.add_ecolog_keymaps()
  -- Environment variable management
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

function M.add_opencode_keymaps()
  local opencode = require "opencode"

  -- Main interface
  M.register_keymap("ai", { "n", "v" }, "<leader>oci", opencode.ask, { desc = "OpenCode: Ask with prompt" })
  M.register_keymap("ai", { "n", "v" }, "<leader>ocs", opencode.select, { desc = "OpenCode: Select action" })

  -- Built-in prompts with context
  M.register_keymap("ai", { "n", "v" }, "<leader>ocd", function()
    opencode.prompt "diagnostics"
  end, { desc = "OpenCode: Fix diagnostics" })

  M.register_keymap("ai", { "n", "v" }, "<leader>oce", function()
    opencode.prompt "explain"
  end, { desc = "OpenCode: Explain code" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocf", function()
    opencode.prompt "fix"
  end, { desc = "OpenCode: Fix code" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocr", function()
    opencode.prompt "review"
  end, { desc = "OpenCode: Review code" })

  M.register_keymap("ai", { "n", "v" }, "<leader>oct", function()
    opencode.prompt "test"
  end, { desc = "OpenCode: Generate tests" })

  M.register_keymap("ai", { "n", "v" }, "<leader>oco", function()
    opencode.prompt "optimize"
  end, { desc = "OpenCode: Optimize code" })

  M.register_keymap("ai", "n", "<leader>ocD", function()
    opencode.prompt "diff"
  end, { desc = "OpenCode: Review diff" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocm", function()
    opencode.prompt "document"
  end, { desc = "OpenCode: Document code" })

  -- Custom prompts
  M.register_keymap("ai", { "n", "v" }, "<leader>ocR", function()
    opencode.prompt "review-detailed"
  end, { desc = "OpenCode: Detailed code review" })

  M.register_keymap("ai", { "n", "v" }, "<leader>oca", function()
    opencode.prompt "analyze"
  end, { desc = "OpenCode: Analyze with diagnostics" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocE", function()
    opencode.prompt "explain-detailed"
  end, { desc = "OpenCode: Detailed explanation" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocF", function()
    opencode.prompt "fix-diagnostics"
  end, { desc = "OpenCode: Fix with diagnostics" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocu", function()
    opencode.prompt "unit-tests"
  end, { desc = "OpenCode: Generate unit tests" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocS", function()
    opencode.prompt "security"
  end, { desc = "OpenCode: Security review" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocp", function()
    opencode.prompt "performance"
  end, { desc = "OpenCode: Performance analysis" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocx", function()
    opencode.prompt "refactor"
  end, { desc = "OpenCode: Refactor code" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocq", function()
    opencode.prompt "quickfix"
  end, { desc = "OpenCode: Quick fix" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocb", function()
    opencode.prompt "debug"
  end, { desc = "OpenCode: Debug help" })

  M.register_keymap("ai", "n", "<leader>ocP", function()
    opencode.prompt "project-review"
  end, { desc = "OpenCode: Project review" })

  M.register_keymap("ai", { "n", "v" }, "<leader>ocX", function()
    opencode.prompt "fix-errors"
  end, { desc = "OpenCode: Fix errors only" })

  -- Session management
  M.register_keymap("ai", "n", "<leader>ocn", function()
    opencode.command "new"
  end, { desc = "OpenCode: New session" })

  M.register_keymap("ai", "n", "<leader>ocl", function()
    opencode.command "list"
  end, { desc = "OpenCode: List sessions" })
end

function M.add_quicker_keymaps()
  M.register_keymap("quicker", "n", "<leader>q", function()
    require("quicker").toggle()
  end, {
    desc = "Toggle quickfix",
  })
  M.register_keymap("quicker", "n", "<leader>l", function()
    require("quicker").toggle { loclist = true }
  end, {
    desc = "Toggle loclist",
  })
  require("quicker").setup {
    keys = {
      {
        ">",
        function()
          require("quicker").expand { before = 2, after = 2, add_to_existing = true }
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
  }
end

function M.setup()
  M.add_telescope_keymaps()
  M.add_core_keymaps()
  M.add_floaterm_keymaps()
  M.add_codecompanion_keymaps()
  M.add_opencode_keymaps()
  M.add_ufo_keymaps()
  M.add_quicker_keymaps()
  M.add_spectre_keymaps()
end

return M
