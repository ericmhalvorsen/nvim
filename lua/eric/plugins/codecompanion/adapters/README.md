# CodeCompanion Adapters Guide

Complete documentation for using different AI providers with CodeCompanion.

## Table of Contents
- [Directory-Based Authentication](#directory-based-authentication)
- [GitHub Models (Free Tier)](#github-models-free-tier)
- [OpenRouter (Multi-Provider)](#openrouter-multi-provider)
- [Anthropic/Claude](#anthropiclaude)
- [Configuration](#configuration)

---

## Directory-Based Authentication

### Overview

The adapter selection automatically changes based on your current working directory in Neovim. This allows you to use different authentication methods for different projects (e.g., work projects vs personal projects).

### How It Works

**Dynamic Real-Time Switching**: The auth method is determined every time you start a new CodeCompanion chat, based on your current working directory at that moment.

- When you `:cd` to a new directory, the next chat will use the appropriate auth
- Uses `vim.fn.getcwd()` to check current directory in real-time
- No restart required - changes take effect on next chat creation

### Default Configuration

By default, any directory matching `censinet*` will use API key authentication:

```lua
-- In lua/eric/plugins/codecompanion/adapters/init.lua
M.config = {
  api_key_pattern = "censinet.*",  -- Matches: censinet, censinet-app, censinet-api, etc.
}
```

### Adding Custom Patterns

You can add multiple custom patterns for different project types:

```lua
M.config = {
  api_key_pattern = "censinet.*",

  -- Additional patterns
  patterns = {
    -- Work projects use API key
    { pattern = "work/.*", adapter_type = "api_key" },

    -- Client projects use API key
    { pattern = "client%-.*", adapter_type = "api_key" },

    -- Specific company projects
    { pattern = "acme%-corp/.*", adapter_type = "api_key" },
  },
}
```

### Pattern Syntax

Uses Lua pattern matching (similar to regex):
- `.` = any character
- `.*` = zero or more of any character
- `%-` = literal hyphen (escaped)
- `^` = start of string
- `$` = end of string

**Examples**:
```lua
"censinet.*"        -- Matches: /home/user/censinet-app, /projects/censinet/api
"work/.*"           -- Matches: /home/user/work/project1, /work/anything
"client%-[^/]+"     -- Matches: /projects/client-acme, /client-beta
"%.*/personal/.*"   -- Matches: any path containing /personal/
```

### Testing Your Patterns

To test which auth method will be used:

```vim
" Check current directory
:pwd

" Change directory to test
:cd ~/censinet-app

" Open CodeCompanion - will use API key auth
:CodeCompanion

" Change to personal project
:cd ~/personal/project

" Open CodeCompanion - will use default auth
:CodeCompanion
```

### How Auth is Selected

1. **API Key Mode** (matches pattern):
   - Uses `ANTHROPIC_WORK_API_KEY` environment variable
   - For work/client projects with specific API keys

2. **Default Mode** (no pattern match):
   - Uses `ANTHROPIC_API_KEY` environment variable
   - Falls back to OAuth when ACP is available

---

## GitHub Models (Free Tier)

### Overview

GitHub Models provides **free access** to premium AI models including GPT-4o, Claude 3.5/3.7 Sonnet, Gemini 2.0 Flash, and Llama 3.3-70B.

### Setup

**1. Install GitHub CLI**:
```bash
# macOS
brew install gh

# Linux
sudo apt install gh
# or
sudo dnf install gh
```

**2. Login to GitHub**:
```bash
gh auth login

# Follow prompts:
# - Select "GitHub.com"
# - Select "HTTPS" or "SSH"
# - Authenticate via browser or token
```

**3. Verify Access**:
```bash
# Test that gh CLI is authenticated
gh auth status

# Should show: "Logged in to github.com as <username>"
```

**4. Use in CodeCompanion**:

In your CodeCompanion chat, you can switch to GitHub Models adapter by configuring your strategy to use `adapter = "github"`, or by selecting it from the action palette.

### Available Models

| Model | Description | Rate Limit (Free) |
|-------|-------------|-------------------|
| **gpt-4o** | OpenAI's most capable model | 10 RPM, 150 RPD |
| **gpt-4o-mini** | Fast and cost-effective | 15 RPM, 450 RPD |
| **claude-3-5-sonnet** | Anthropic's balanced model | 10 RPM, 100 RPD |
| **claude-3-7-sonnet** | Latest Claude model | 10 RPM, 100 RPD |
| **gemini-2.0-flash-exp** | Google's fast experimental | 15 RPM, 1500 RPD |
| **llama-3.3-70b-instruct** | Meta's open-source model | 15 RPM, 150 RPD |

**RPM** = Requests Per Minute | **RPD** = Requests Per Day

### Paid Tier

For higher rate limits, enable paid inference:
- Significantly larger context windows
- Higher requests per minute
- Pay only for what you use

Visit: https://github.com/marketplace/models

### API Endpoint

GitHub Models uses OpenAI-compatible API:
- **Endpoint**: `https://models.github.ai/inference`
- **Auth**: Your GitHub token (via `gh auth token`)
- **Format**: OpenAI chat/completions API

### Troubleshooting

**"Authentication failed"**:
```bash
# Re-authenticate
gh auth login

# Check token
gh auth token
```

**"Rate limit exceeded"**:
- Free tier has per-minute and per-day limits
- Wait for rate limit to reset
- Consider enabling paid tier
- Switch to different model with higher limits

**"Model not found"**:
- Model names are case-sensitive
- Check available models: https://github.com/marketplace?type=models

### Example Usage

```vim
" Start CodeCompanion chat
:CodeCompanion

" In chat, the github adapter will use gh CLI authentication
" Models are selected from the available choices in the adapter config
```

---

## OpenRouter (Multi-Provider)

### Overview

OpenRouter provides unified access to **100+ AI models** from multiple providers (Anthropic, OpenAI, Google, Meta, DeepSeek, etc.) through a single API.

### Setup

**1. Get API Key**:
- Visit: https://openrouter.ai/
- Sign up for an account
- Navigate to "Keys" in your dashboard
- Create a new API key

**2. Set Environment Variable**:

**Option A: Shell Profile** (Permanent)
```bash
# Add to ~/.bashrc, ~/.zshrc, or ~/.profile
export OPENROUTER_API_KEY="sk-or-v1-xxxxxxxxxxxxxxxxxxxxx"

# Reload shell
source ~/.bashrc  # or ~/.zshrc
```

**Option B: Neovim Config** (Session-based)
```lua
-- In init.lua before loading plugins
vim.fn.setenv("OPENROUTER_API_KEY", "sk-or-v1-xxxxxxxxxxxxxxxxxxxxx")
```

**Option C: Per-Session**
```bash
# Set before launching Neovim
export OPENROUTER_API_KEY="sk-or-v1-xxxxxxxxxxxxxxxxxxxxx"
nvim
```

**3. Verify Setup**:
```vim
:lua print(os.getenv("OPENROUTER_API_KEY"))
" Should display your API key
```

### Available Models

OpenRouter adapter is configured with popular models:

```lua
-- Default model
"anthropic/claude-sonnet-4-5"

-- Available choices:
"anthropic/claude-sonnet-4-5"   -- Latest Claude, balanced
"anthropic/claude-opus-4"       -- Most capable, slower
"google/gemini-2.0-flash-exp"   -- Fast, experimental
"deepseek/deepseek-r1"          -- Reasoning model
"openai/gpt-4o"                 -- GPT-4 optimized
```

**See all models**: https://openrouter.ai/models

### Pricing

OpenRouter uses pay-per-use pricing:
- **No subscription required**
- Charged per token (input + output)
- Prices vary by model
- Free credits often available for new users

**Example costs** (approximate, check site for current):
- Claude Sonnet: ~$3/million input tokens, ~$15/million output
- GPT-4o: ~$2.50/million input tokens, ~$10/million output
- Gemini 2.0 Flash: ~$0.10/million tokens
- DeepSeek-R1: ~$0.50/million tokens

### Features

**Unified API**:
- Single endpoint for all providers
- Consistent format across models
- Easy model switching

**Automatic Routing**:
- Fallback if primary model is down
- Can specify multiple model preferences

**Usage Tracking**:
- Dashboard shows token usage
- Cost breakdowns per model
- Rate limit monitoring

### Configuration Customization

To add more models or change defaults:

```lua
-- Edit: lua/eric/plugins/codecompanion/adapters/init.lua

openrouter = function()
  -- ... existing code ...
  schema = {
    model = {
      default = "anthropic/claude-sonnet-4-5",
      choices = {
        "anthropic/claude-sonnet-4-5",
        "anthropic/claude-opus-4",
        "google/gemini-2.0-flash-exp",
        "deepseek/deepseek-r1",
        "openai/gpt-4o",
        -- Add your favorites:
        "meta-llama/llama-3.3-70b-instruct",
        "mistralai/mistral-large",
        -- etc.
      },
    },
  },
end
```

### Troubleshooting

**"OPENROUTER_API_KEY not set"**:
```bash
# Verify environment variable
echo $OPENROUTER_API_KEY

# If empty, set it:
export OPENROUTER_API_KEY="your-key"
```

**"Invalid API key"**:
- Check key format: should start with `sk-or-v1-`
- Regenerate key on OpenRouter dashboard
- Ensure no extra spaces in the key

**"Insufficient credits"**:
- Add credits to your OpenRouter account
- Check balance: https://openrouter.ai/credits

**"Rate limit exceeded"**:
- Each model has different rate limits
- Wait for rate limit window to reset
- Upgrade to higher tier on OpenRouter

---

## Anthropic/Claude

### Overview

Default adapter using Anthropic's Claude models directly.

### Authentication Modes

**1. API Key (Directory-Based)**:
- Triggered when directory matches pattern (e.g., `censinet*`)
- Uses the `ANTHROPIC_WORK_API_KEY` environment variable.

**2. Default Authentication**:
- Used when directory doesn't match patterns
- Uses the `ANTHROPIC_API_KEY` environment variable.
- Will support OAuth/ACP when available (via `CLAUDE_CODE_OAUTH_TOKEN`)

### Available Models

```lua
default = "claude-sonnet-4-5-20250929"

choices = {
  "claude-sonnet-4-5-20250929",  -- Latest Sonnet (balanced)
  "claude-opus-4-20250514",      -- Most capable
  "claude-haiku-4-5-20250110",   -- Fastest, most economical
}
```

### Model Characteristics

| Model | Speed | Cost | Best For |
|-------|-------|------|----------|
| **Sonnet 4.5** | Fast | Medium | General coding, balanced tasks |
| **Opus 4** | Slower | High | Complex reasoning, large codebases |
| **Haiku 4.5** | Fastest | Low | Quick edits, simple questions |

---

## Configuration

### Switching Adapters

**Method 1: Edit Strategy in Config**
```lua
-- Edit: lua/eric/plugins/codecompanion/init.lua
strategies = {
  chat = {
    adapter = "github",  -- Change to: "anthropic", "github", "openrouter"
  },
}
```

**Method 2: Action Palette** (if implemented)
```vim
:CodeCompanionActions
" Select adapter from menu
```

### Testing Different Adapters

```vim
" Test Anthropic in censinet project
:cd ~/censinet-app
:CodeCompanion
" Uses API key from ANTHROPIC_WORK_API_KEY

" Test GitHub Models
:cd ~/personal/project
:CodeCompanion
" Uses GitHub token (via gh auth)

" Test OpenRouter (if env var set)
:CodeCompanion
" Uses OPENROUTER_API_KEY
```

### Verifying Active Adapter

Check your chat window header - it should show the adapter name and model being used.

---

## Quick Reference

| Adapter | Setup Required | Cost | Models Available | Best For |
|---------|---------------|------|------------------|----------|
| **Anthropic** | API key env var | Pay-per-use | Claude Sonnet/Opus/Haiku | Direct Anthropic access, work projects |
| **GitHub Models** | `gh auth login` | Free tier available | GPT-4o, Claude, Gemini, Llama | Experimenting, personal projects |
| **OpenRouter** | API key env var | Pay-per-use | 100+ models | Model variety, unified billing |

---

## Support & Resources

- **CodeCompanion Docs**: https://codecompanion.olimorris.dev
- **GitHub Models**: https://github.com/marketplace?type=models
- **OpenRouter**: https://openrouter.ai/
- **Anthropic API**: https://console.anthropic.com/

---

**Last Updated**: 2025-01-22
