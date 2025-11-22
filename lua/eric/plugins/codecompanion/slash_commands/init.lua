-- CodeCompanion Slash Commands
-- Custom slash commands to enhance chat functionality

return {
  -- Use Telescope for file selection
  ["file"] = {
    opts = {
      provider = "telescope",
    },
  },

  -- Use Telescope for help selection
  ["help"] = {
    opts = {
      provider = "telescope",
    },
  },

  -- Use Telescope for symbols
  ["symbols"] = {
    opts = {
      provider = "telescope",
    },
  },

  -- Use default for buffer
  ["buffer"] = {
    opts = {
      provider = "default",
    },
  },

  -- Custom slash commands
  ["diagnostics"] = require "eric.plugins.codecompanion.slash_commands.diagnostics",
  ["git_files"] = require "eric.plugins.codecompanion.slash_commands.git_files",
}
