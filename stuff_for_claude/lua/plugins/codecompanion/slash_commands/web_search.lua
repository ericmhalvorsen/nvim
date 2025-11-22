local constants = require("plugins.codecompanion.slash_commands.constants")

---@param chat CodeCompanion.Chat
local callback = function(chat)
  vim.ui.input({ prompt = "Enter search query: " }, function(input)
    if input then
      local query = input
      local url = string.format("https://searxng.us.c8g.top/search?q=%s&format=json", query)
      local handle = io.popen("curl -s " .. '"' .. url .. '"')
      if handle ~= nil then
        local response = handle:read("*a")
        handle:close()
        local result_table = vim.fn.json_decode(response)
        local results = {}
        if result_table and result_table.results then
          for _, result in ipairs(result_table.results) do
            local content_url = result.content_url
            if content_url then
              local content_handle = io.popen("curl -s " .. content_url)
              if content_handle ~= nil then
                local detailed_content = content_handle:read("*a")
                content_handle:close()
                result.content = detailed_content
              else
                result.content = "Failed to fetch content"
              end
            end
            table.insert(results, {
              url = result.url,
              title = result.title,
              content = result.content,
            })
          end
          chat:add_reference({
            role = constants.USER_ROLE,
            content = vim.inspect(results),
          }, "web_search", "<web_search>")
        else
          vim.notify("No web search results available", vim.log.levels.INFO, { title = "CodeCompanion" })
        end
      else
        vim.notify("Failed to perform web search", vim.log.levels.INFO, { title = "CodeCompanion" })
      end
    else
      vim.notify("No query entered", vim.log.levels.INFO, { title = "CodeCompanion" })
    end
  end)
end

return {
  description = "Search the web for specific content",
  callback = callback,
  opts = {
    contains_code = false,
  },
}
