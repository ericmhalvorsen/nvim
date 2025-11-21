return {
  "https://codeberg.org/FelipeLema/nvim-macos-notify.git",
  -- Only load if on macOS (Darwin platform)
  cond = vim.loop.os_uname().sysname == "Darwin",
  config = function()
    -- Replace vim.notify with macOS native notifications
    vim.notify = require("macos-notify").notify

    -- Customize notification emojis for different log levels
    require("macos-notify").level_to_emoji = {
      [vim.log.levels.DEBUG] = "🐛 ", -- Debug messages
      [vim.log.levels.ERROR] = "❌ ", -- Error messages
      [vim.log.levels.INFO] = "ℹ️  ", -- Info messages
      [vim.log.levels.WARN] = "⚠️  ", -- Warning messages
    }
  end,
}
