-- CodeCompanion Prompt Library
-- Comprehensive collection of prompts for various coding tasks

return {
  -- Code Review
  ["Code Review"] = require "eric.plugins.codecompanion.prompts.code_review",

  -- Explain Code
  ["Explain Code"] = require "eric.plugins.codecompanion.prompts.explain",

  -- Analyze LSP Diagnostics
  ["Analyze LSP Diagnostics"] = require "eric.plugins.codecompanion.prompts.analyze",

  -- Fix Code and Diagnostics
  ["Fix Code"] = require "eric.plugins.codecompanion.prompts.fix",

  -- Unit Tests
  ["Unit Tests"] = require "eric.plugins.codecompanion.prompts.unit_tests",

  -- Task Workflow
  ["Task"] = require "eric.plugins.codecompanion.prompts.task",

  -- Act Workflow (Agentic)
  ["Act"] = require "eric.plugins.codecompanion.prompts.act",
}
