local M = {}

function M.setup()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "modelscope",
    env = {
      url = "https://api-inference.modelscope.cn/v1",
      api_key = require("vars.secret").modelscope,
      chat_url = "/chat/completions",
    },
    headers = {
      ["User-Agent"] = "CodeCompanion.nvim",
    },
    schema = {
      model = {
        default = "Qwen/Qwen3-Coder-480B-A35B-Instruct",
        choices = {
          "Qwen/Qwen3-Coder-480B-A35B-Instruct", -- 256K Context
        },
      },
    },
  })
end

return M
