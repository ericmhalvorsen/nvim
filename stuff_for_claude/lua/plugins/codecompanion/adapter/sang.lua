local M = {}

function M.setup()
  return require("codecompanion.adapters").extend("ollama", {
    name = "sang",
    env = {
      url = "http://dev.xm1.c8g.top:11434",
    },
    schema = {
      model = {
        default = "deepseek-r1:14b",
        choices = {
          "deepseek-r1:14b",
        },
      },
    },
  })
end

return M
