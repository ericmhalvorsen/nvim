local secret = require("vars.secret")

local M = {}

function M.setup()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "siliconflow",
    env = {
      url = "https://api.siliconflow.cn/v1",
      api_key = secret.siliconflow,
    },
    schema = {
      model = {
        default = "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B",
        choices = {
          "deepseek-ai/DeepSeek-R1", -- ￥4/￥16
          "deepseek-ai/DeepSeek-V3", -- ￥2/￥8
          "Qwen/QwQ-32B", -- ￥1/￥4
          "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B", -- Free
          "Qwen/Qwen2.5-7B-Instruct", -- Free
        },
      },
    },
  })
end

return M
