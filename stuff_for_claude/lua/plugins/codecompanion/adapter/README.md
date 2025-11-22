# CodeCompanion Adapter Module

## 1. Overview

This directory contains various LLM adapter implementations for the CodeCompanion plugin. Each adapter encapsulates the logic for interacting with a specific LLM service, providing a unified interface for CodeCompanion to use.

## 2. File Structure

- `init.lua` - Main entry file, exports all adapter functions
- `worklink.lua` - Worklink adapter implementation
- `siliconflow.lua` - SiliconFlow adapter implementation
- `aihubmix.lua` - AIHubMix adapter implementation
- `sang.lua` - Sang (Ollama) adapter implementation

## 3. Usage

In the CodeCompanion configuration, you can specify the adapter to use as follows:

```lua
-- In codecompanion.lua
adapters = require("vars.codecompanion.adapter"),

-- In environment.lua
codecompanion = {
  chat = {
    adapter = "worklink", -- Use worklink adapter
  },
  -- ...
}
```

## 4. Adapter Descriptions

### 4.1 worklink

Adapter integrated with the Worklink platform, based on the OpenAI compatible interface, supporting multiple models:

- Supported models: gpt-4o, gpt-4o-mini, gpt-3.5-turbo, deepseek-r1, deepseek-v3, claude-3.5-haiku, claude-3.5-sonnet, claude-3.7-sonnet, etc.
- Default model: claude-3.7-sonnet

### 4.2 siliconflow

Adapter integrated with the SiliconFlow platform, based on the OpenAI compatible interface:

- Supported models: deepseek-ai/DeepSeek-R1, deepseek-ai/DeepSeek-V3, Qwen/QwQ-32B, etc.
- Default model: deepseek-ai/DeepSeek-R1-Distill-Qwen-7B
- Includes free and paid model options

### 4.3 aihubmix

Adapter integrated with the AIHubMix platform, based on the OpenAI compatible interface:

- Supported models: DeepSeek-R1, DeepSeek-V3, Qwen/QwQ-32B, Claude 3.5 Haiku, Claude 3.7 Sonnet, etc.
- Default model: DeepSeek-R1
- Includes pricing information for each model

### 4.4 sang

Adapter integrated with local Ollama service:

- Default connection to `http://dev.xm1.c8g.top:11434`
- Supported models: deepseek-r1:14b
- Suitable for scenarios requiring local model execution

## 5. How to Add a New Adapter

1. Create a new `.lua` file in the `adapter` directory (e.g., `newadapter.lua`)
2. Implement adapter logic using the standard template:

```lua
local secret = require("vars.secret")

local M = {}

function M.setup()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "newadapter name",
    env = {
      url = "https://api.example.com",
      api_key = secret.your_api_key,
    },
    schema = {
      model = {
        default = "default model",
        choices = {
          "model1",
          "model2",
          -- ...
        },
      },
    },
  })
end

return M
```

3. Add a reference to the new adapter in `init.lua`:

```lua
newadapter = require("vars.codecompanion.adapter.newadapter").setup,
```

4. Configure to use the new adapter in `environment.lua`:

```lua
codecompanion = {
  chat = {
    adapter = "newadapter",
  },
  -- ...
}
```

## 6. Notes

- All adapters depend on the `vars.secret` module to obtain API keys
- Adapters are typically extended from the `openai_compatible` or `ollama` base adapters
- Ensure the returned adapter configuration has the correct `name`, `env`, and `schema` fields
