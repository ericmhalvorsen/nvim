return {
  ["Explain Code"] = require("plugins.codecompanion.prompt_library.explain"),
  ["Analyze LSP Diagnostics"] = require("plugins.codecompanion.prompt_library.analyze"),
  ["Fix LSP Diagnostics"] = require("plugins.codecompanion.prompt_library.fix"),
  ["Translate"] = require("plugins.codecompanion.prompt_library.translate"),
  ["Merge Request"] = require("plugins.codecompanion.prompt_library.merge_request"),
  ["Task"] = require("plugins.codecompanion.prompt_library.task"),
  ["Act"] = require("plugins.codecompanion.prompt_library.act"),
  ["Ask"] = require("plugins.codecompanion.prompt_library.ask"),
}
