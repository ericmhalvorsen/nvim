local M = {}

function M.setup()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "openrouter",
    env = {
      url = "https://openrouter.ai/api",
      api_key = require("vars.secret").openrouter,
      chat_url = "/v1/chat/completions",
    },
    headers = {
      ["User-Agent"] = "CodeCompanion.nvim",
    },
    schema = {
      model = {
        default = "qwen/qwen3-coder:free",
        choices = {
          "qwen/qwen3-coder:free", -- 256K Context
          "deepseek/deepseek-r1:free", -- 164K Context
          "moonshotai/kimi-k2:free", -- 66K Context
        },
      },
    },
  })
end

return M
