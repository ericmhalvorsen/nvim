-- OpenCode.nvim - Claude Code AI Assistant Integration
-- Provides editor-aware research, reviews, and requests with Claude Code
-- Docs: https://github.com/NickvanDyke/opencode.nvim

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim", -- For improved input and select UI
  },
  config = function()
    -- Enable autoread so buffers reload when opencode makes edits
    vim.o.autoread = true

    -- Configure opencode
    vim.g.opencode_opts = {
      -- Provider configuration (uses snacks.terminal by default)
      provider = "snacks.terminal",

      -- Custom prompts in addition to built-in ones
      -- Built-in prompts: diagnostics, diff, document, explain, fix, optimize, review, test
      prompts = {
        -- Code Review - comprehensive review for best practices
        ["review-detailed"] = [[Review @this for:
- Bugs and logic errors
- Security vulnerabilities
- Performance issues
- Best practices violations
- Code style and readability
- Potential edge cases

Provide specific, actionable feedback with examples where applicable.]],

        -- Analyze with diagnostics context
        ["analyze"] = [[Analyze @this along with @diagnostics.

When analyzing:
1. Identify the problem from the diagnostics
2. Explain the root cause
3. Plan the fix using pseudocode
4. Provide the corrected code
5. Explain the changes and reasoning

Ensure fixed code follows best practices and includes necessary imports.]],

        -- Explain code in detail
        ["explain-detailed"] = [[Explain @this in detail:

1. Overview: High-level summary of what the code does
2. Step-by-Step: Break down the logic flow
3. Key Concepts: Explain important programming concepts used
4. Purpose: How this fits into the broader application
5. Notable Details: Point out clever techniques or gotchas

Keep explanations clear and concise.]],

        -- Fix with diagnostics
        ["fix-diagnostics"] = [[Fix @this considering @diagnostics.

Follow these steps:
1. Identify the problem from diagnostics
2. Plan the fix step-by-step
3. Implement the corrected code
4. Explain the changes

Ensure the fix includes necessary imports and proper error handling.]],

        -- Generate comprehensive unit tests
        ["unit-tests"] = [[Generate comprehensive unit tests for @this.

Include:
1. Test cases for normal/happy path
2. Edge cases
3. Error handling scenarios
4. Proper setup and teardown if needed

Use appropriate testing framework and follow best practices.]],

        -- Security review
        ["security"] = [[Perform a security review of @this.

Check for:
- SQL injection vulnerabilities
- XSS vulnerabilities
- Authentication/authorization issues
- Input validation problems
- Sensitive data exposure
- Insecure dependencies

Provide specific remediation advice.]],

        -- Performance analysis
        ["performance"] = [[Analyze @this for performance issues.

Look for:
- Inefficient algorithms (O(n²) or worse)
- Unnecessary loops or iterations
- Memory leaks
- Database query optimization
- Caching opportunities
- Resource cleanup

Suggest specific improvements with examples.]],

        -- Refactor for readability
        ["refactor"] = [[Refactor @this for better readability and maintainability.

Focus on:
- Simplifying complex logic
- Extracting reusable functions
- Improving naming conventions
- Reducing code duplication
- Following DRY principles
- Adding helpful comments where needed]],

        -- Quick fix without extensive explanation
        ["quickfix"] = [[Fix @this. Be concise - just provide the corrected code with a brief explanation of what changed.]],

        -- Debug help
        ["debug"] = [[Help debug @this.

Analyze the code for:
1. Logic errors that could cause bugs
2. Potential null/undefined references
3. Off-by-one errors
4. Race conditions
5. Edge cases not handled

Suggest debugging strategies and potential fixes.]],

        -- Project context review
        ["project-review"] = [[Review the current project structure and recent changes:

Project Files:
@tree

Recent Files:
@recent

Git Status:
@git

Provide analysis of project organization and suggest improvements.]],

        -- Error-focused fix
        ["fix-errors"] = [[Fix the errors in @this:

Errors:
@errors

Provide corrected code that resolves all errors.]],
      },

      -- Custom context placeholders
      -- Built-in: @this, @buffer, @buffers, @visible, @diagnostics, @quickfix, @diff, @grapple
      contexts = {
        -- Clipboard content
        ["@clipboard"] = function()
          return vim.fn.getreg "+"
        end,

        -- Only errors (no warnings) from diagnostics
        ["@errors"] = function()
          local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          if #diagnostics == 0 then
            return "No errors found"
          end

          local lines = {}
          for _, diag in ipairs(diagnostics) do
            table.insert(lines, string.format("Line %d: %s", diag.lnum + 1, diag.message))
          end
          return table.concat(lines, "\n")
        end,

        -- Recently edited files
        ["@recent"] = function()
          local recent_files = vim.v.oldfiles or {}
          local cwd = vim.fn.getcwd()
          local result = {}

          -- Get up to 10 recent files from current project
          for _, file in ipairs(recent_files) do
            if vim.startswith(file, cwd) and #result < 10 then
              table.insert(result, file:sub(#cwd + 2)) -- Remove cwd prefix
            end
          end

          return #result > 0 and table.concat(result, "\n") or "No recent files"
        end,

        -- Git status output
        ["@git"] = function()
          local handle = io.popen "git status --short 2>&1"
          if not handle then
            return "Git not available"
          end
          local result = handle:read "*a"
          handle:close()
          return result ~= "" and result or "No git changes"
        end,

        -- Current function/method context (using treesitter)
        ["@function"] = function()
          local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
          if not ok then
            return "Treesitter not available"
          end

          local node = ts_utils.get_node_at_cursor()
          if not node then
            return "Not inside a function"
          end

          -- Walk up the tree to find function node
          while node do
            local node_type = node:type()
            if
              node_type == "function_declaration"
              or node_type == "function_definition"
              or node_type == "method_declaration"
              or node_type == "method_definition"
              or node_type == "arrow_function"
              or node_type == "function"
            then
              local start_row, start_col, end_row, end_col = node:range()
              local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
              return table.concat(lines, "\n")
            end
            node = node:parent()
          end

          return "Not inside a function"
        end,

        -- Current project structure (simple tree)
        ["@tree"] = function()
          local handle = io.popen "find . -type f -not -path '*/.*' -not -path '*/node_modules/*' | head -n 50"
          if not handle then
            return "Unable to generate tree"
          end
          local result = handle:read "*a"
          handle:close()
          return result ~= "" and result or "Empty project"
        end,
      },
    }

    -- Set up autocmds for opencode events
    -- This enables automation based on opencode's Server-Sent-Events
    vim.api.nvim_create_autocmd("User", {
      pattern = "OpencodeEvent",
      callback = function(ev)
        -- Handle opencode Server-Sent-Events
        -- Examples: idle state triggers, permission requests, etc.
        -- ev.data contains the event data

        -- You can add custom automation here, for example:
        -- if ev.data.type == "permission_request" then
        --   -- Auto-approve certain types of requests
        -- end
      end,
    })
  end,
}
