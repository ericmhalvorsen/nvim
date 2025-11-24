-- AI-Powered Git Commits using aicommit
-- Install: npm install -g aicommit or brew install aicommit
-- Usage: :GitAICommit to generate commit message from staged changes
return {
  "gitsang/aicommit", -- Dummy plugin name for lazy.nvim tracking
  dev = true, -- Mark as development plugin (not from GitHub)
  config = function()
    -- Configuration storage
    local config = {
      adapter = "worklink",
      adapters = {
        default = {
          base_url = "https://api.openai.com/v1",
          api_key = "",
          model = "gpt-3.5-turbo",
        },
        worklink = {
          base_url = "https://worklink.yealink.com/llmproxy",
          api_key = require("vars.secret").worklink_llm,
          model = "gpt-4o",
        },
      },
    }

    local function run_in_terminal(cmd, title)
      local term_cmd = "terminal " .. cmd
      vim.cmd("botright split")
      vim.cmd("resize 15")
      vim.cmd(term_cmd)
      vim.cmd("setlocal nonumber norelativenumber")
      if title then
        vim.cmd("file " .. title)
      end
    end

    local function list_adapters()
      if vim.tbl_isempty(config.adapters) then
        print("[GitAICommit] No adapters configured")
        return
      end

      print("[GitAICommit] Configured adapters:")
      for name, adapter in pairs(config.adapters) do
        local status = (name == config.adapter) and "* " or "  "
        print(status .. name .. " - " .. adapter.model)
      end
    end

    local function get_adapter(name)
      name = name or config.adapter
      if not name then
        return nil, "No adapter specified and no default adapter set"
      end

      local adapter = config.adapters[name]
      if not adapter then
        return nil, "Adapter '" .. name .. "' not found"
      end

      if not adapter.base_url or not adapter.api_key or not adapter.model then
        return nil, "Adapter '" .. name .. "' is not fully configured"
      end

      return adapter, nil
    end

    local function ai_commit(opts)
      vim.cmd("w")

      opts = opts or {}
      local adapter_name = opts.adapter

      local adapter, err = get_adapter(adapter_name)
      if not adapter then
        print("[GitAICommit Error] " .. err)
        print("Available adapters: " .. table.concat(vim.tbl_keys(config.adapters), ", "))
        print("Use :GitAICommitConfig to configure adapters")
        return
      end

      local cmds = { "aicommit" }
      table.insert(cmds, "--openai-base-url")
      table.insert(cmds, adapter.base_url)
      table.insert(cmds, "--openai-key")
      table.insert(cmds, adapter.api_key)
      table.insert(cmds, "--model")
      table.insert(cmds, adapter.model)

      local cmd = table.concat(cmds, " ")
      print("[GitAICommit] Using adapter: " .. (adapter_name or config.adapter))
      print("[GitAICommit] " .. cmd:gsub(adapter.api_key, "***")) -- Hide API key in output
      run_in_terminal(cmd, "GitAICommit-" .. (adapter_name or config.adapter))
    end

    -- Setup commands
    vim.api.nvim_create_user_command("GitAICommit", function()
      ai_commit()
    end, {
      desc = "Generate AI commit message using aicommit",
    })

    vim.api.nvim_create_user_command("GitAICommitList", function()
      list_adapters()
    end, {
      desc = "List all configured adapters",
    })
  end,
}
