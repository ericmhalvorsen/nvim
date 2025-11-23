-- CodeCompanion Adapters Configuration
-- Provides intelligent adapter selection based on directory patterns
--
-- DYNAMIC DIRECTORY-BASED AUTH:
-- Auth method is determined IN REAL-TIME based on current working directory.
-- When you :cd to a new directory, the next CodeCompanion chat will automatically
-- use the appropriate auth method. No restart required!

local M = {}

-- Configuration for directory-based adapter selection
-- You can customize these patterns to match your workflow
M.config = {
  -- Default directory pattern for API key authentication
  -- Projects matching this pattern will use the API key from file
  api_key_pattern = "censinet.*",

  -- Additional custom patterns can be added here
  patterns = {
    -- Example: { pattern = "client%-.*", adapter_type = "api_key" }
    -- Example: { pattern = "personal/.*", adapter_type = "oauth" }
  },

  -- Show notification when auth method changes? (true/false/"verbose")
  -- true = show simple notification
  -- "verbose" = show detailed info including directory
  -- false = silent
  notify_auth_switch = "verbose",
}

-- Check if current working directory matches a pattern
local function matches_pattern(pattern)
  local cwd = vim.fn.getcwd()
  return string.match(cwd, pattern) ~= nil
end

-- Get current working directory (for notifications)
local function get_cwd()
  return vim.fn.getcwd()
end

-- Determine which authentication method to use (called dynamically each time)
local function should_use_api_key()
  -- Check main pattern
  if matches_pattern(M.config.api_key_pattern) then
    return true, M.config.api_key_pattern
  end

  -- Check custom patterns
  for _, config in ipairs(M.config.patterns) do
    if config.adapter_type == "api_key" and matches_pattern(config.pattern) then
      return true, config.pattern
    end
  end

  return false, nil
end

-- Notify user about auth method (if enabled)
local function notify_auth_method(using_api_key, matched_pattern)
  if M.config.notify_auth_switch == false then
    return
  end

  local cwd = get_cwd()
  local method = using_api_key and "API Key (file)" or "Default Auth"

  if M.config.notify_auth_switch == "verbose" then
    local msg = string.format(
      "Auth: %s\nDir: %s%s",
      method,
      cwd,
      matched_pattern and string.format("\nPattern: %s", matched_pattern) or ""
    )
    vim.notify(msg, vim.log.levels.INFO, { title = "CodeCompanion" })
  elseif M.config.notify_auth_switch == true then
    vim.notify("Using: " .. method, vim.log.levels.INFO, { title = "CodeCompanion" })
  end
end

-- Return all adapter configurations
return {
  http = {
    -- Anthropic/Claude adapter with DYNAMIC intelligent auth selection
    -- Auth method determined in real-time based on current working directory
    -- Changes automatically when you :cd to different directories
    anthropic = function()
      -- Dynamically check current directory for auth method
      local using_api_key, matched_pattern = should_use_api_key()
      local api_key_config = using_api_key and "cmd:~/.claude/anthropic_key.sh" or nil

      -- Notify user about auth method (if enabled in config)
      notify_auth_method(using_api_key, matched_pattern)

      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          -- Use API key from file if directory matches pattern, otherwise use default auth
          api_key = api_key_config,
        },
        schema = {
          model = {
            default = "claude-sonnet-4-5-20250929",
            choices = {
              "claude-sonnet-4-5-20250929",
              "claude-opus-4-20250514",
              "claude-haiku-4-5-20250110",
            },
          },
        },
      })
    end,

    -- GitHub Models adapter (free tier with rate limits)
    -- Requires: gh CLI installed and logged in
    -- Uses GitHub token with models:read permission
    github = function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        name = "github_models",
        env = {
          url = "https://models.github.ai/inference",
          -- GitHub CLI auth or personal access token
          api_key = "cmd:gh auth token",
        },
        headers = {
          ["Content-Type"] = "application/json",
        },
        schema = {
          model = {
            default = "gpt-4o",
            choices = {
              "gpt-4o",
              "gpt-4o-mini",
              "claude-3-5-sonnet",
              "claude-3-7-sonnet",
              "gemini-2.0-flash-exp",
              "llama-3.3-70b-instruct",
            },
          },
        },
      })
    end,

    -- OpenRouter adapter (access to many models)
    openrouter = function()
      local api_key = os.getenv "OPENROUTER_API_KEY"
      if not api_key then
        vim.notify("OPENROUTER_API_KEY not set", vim.log.levels.WARN, { title = "CodeCompanion" })
        return nil
      end

      return require("codecompanion.adapters").extend("openai_compatible", {
        name = "openrouter",
        env = {
          url = "https://openrouter.ai/api/v1",
          api_key = api_key,
        },
        headers = {
          ["HTTP-Referer"] = "https://github.com/ericmhalvorsen/nvim",
          ["X-Title"] = "Neovim CodeCompanion",
        },
        schema = {
          model = {
            default = "anthropic/claude-sonnet-4-5",
            choices = {
              "anthropic/claude-sonnet-4-5",
              "anthropic/claude-opus-4",
              "google/gemini-2.0-flash-exp",
              "deepseek/deepseek-r1",
              "openai/gpt-4o",
            },
          },
        },
      })
    end,
  },

  -- Agent Client Protocol (ACP) configuration
  -- NOTE: Claude Code does not yet support ACP as of January 2025
  -- Configuration is ready for when it becomes available
  -- acp = {
  --   claude_code = function()
  --     return require("codecompanion.adapters").extend("claude_code", {
  --       env = {
  --         CLAUDE_CODE_OAUTH_TOKEN = "cmd:~/.claude/oauth_token.sh",
  --       },
  --     })
  --   end,
  -- },
}
