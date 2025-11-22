-- CodeCompanion Adapters Configuration
-- Provides intelligent adapter selection based on directory patterns

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
}

-- Check if current working directory matches a pattern
local function matches_pattern(pattern)
  local cwd = vim.fn.getcwd()
  return string.match(cwd, pattern) ~= nil
end

-- Determine which authentication method to use
local function should_use_api_key()
  -- Check main pattern
  if matches_pattern(M.config.api_key_pattern) then
    return true
  end

  -- Check custom patterns
  for _, config in ipairs(M.config.patterns) do
    if config.adapter_type == "api_key" and matches_pattern(config.pattern) then
      return true
    end
  end

  return false
end

-- Return all adapter configurations
return {
  http = {
    -- Anthropic/Claude adapter with intelligent auth selection
    anthropic = function()
      local api_key_config = should_use_api_key() and "cmd:~/.claude/anthropic_key.sh" or nil

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
