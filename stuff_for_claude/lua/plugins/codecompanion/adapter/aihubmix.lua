local secret = require("vars.secret")

local M = {}

function M.setup()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "aihubmix",
    env = {
      url = "https://aihubmix.com",
      api_key = secret.aihubmix,
    },
    schema = {
      model = {
        default = "DeepSeek-R1",
        choices = {
          "DeepSeek-R1", -- $0.62/$2.48
          "DeepSeek-V3", -- $0.4/$1.6
          "Qwen/QwQ-32B", -- $0.14/$0.56
          "claude-3-5-haiku-20241022", -- $1.1/$5.5
          "claude-3-7-sonnet-20250219", -- $3.3/$16.5
        },
      },
    },
  })
end

return M
