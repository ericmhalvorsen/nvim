local M = {}

--[[
  :GoBuild -o myapp
  :GoBuild -ldflags "-X main.version=1.0.0"
  :GoBuild -o myapp -ldflags "-X main.version=1.0.0"

  :GoRun main.go
  :GoRun -ldflags "-X main.version=1.0.0"
  :GoRun -ldflags "-X main.version=1.0.0" cmd/server

  :GoTest TestMyFunction
  :GoTest -run TestMyFunction
]]

local function run_in_terminal(cmd, title)
  local term_cmd = "terminal " .. cmd
  vim.cmd("botright split")
  vim.cmd("resize 15")
  vim.cmd(term_cmd)
  vim.cmd("setlocal nonumber norelativenumber")
  if title then
    vim.cmd("file " .. title)
  end
end

function M.build(...)
  vim.cmd("w")

  local args = { ... }
  local cmds = { "go", "build" }

  -- Check for custom arguments
  local i = 1

  while i <= #args do
    if args[i] == "-o" and i < #args then
      table.insert(cmds, "-o")
      table.insert(cmds, args[i + 1])
      i = i + 2
    elseif args[i] == "-ldflags" and i < #args then
      table.insert(cmds, "-ldflags")
      table.insert(cmds, args[i + 1])
      i = i + 2
    else
      i = i + 1
    end
  end

  -- Add default target if no custom path specified
  table.insert(cmds, "./...")

  local cmd = table.concat(cmds, " ")
  print("[GoBuild CMD] " .. cmd)

  run_in_terminal(cmd, "GoBuild")
end

function M.run(...)
  vim.cmd("w")

  local args = { ... }
  local cmds = { "go", "run" }
  local target = "."

  -- Check for custom arguments
  local i = 1
  while i <= #args do
    if args[i] == "-ldflags" and i < #args then
      table.insert(cmds, "-ldflags")
      table.insert(cmds, args[i + 1])
      i = i + 2
    elseif not string.match(args[i], "^-") then
      -- This is a path argument
      target = args[i]
      i = i + 1
    else
      i = i + 1
    end
  end

  table.insert(cmds, target)

  local cmd = table.concat(cmds, " ")
  print("[GoRun CMD] " .. cmd)

  run_in_terminal(cmd, "GoRun")
end

function M.test(...)
  vim.cmd("w")

  local args = { ... }
  local cmds = { "go", "test" }
  local target = "./..."

  -- Check for custom test function
  for i = 1, #args do
    if args[i] == "-run" and i < #args then
      table.insert(cmds, target)
      table.insert(cmds, "-run")
      table.insert(cmds, args[i + 1])
      goto execute
    elseif not string.match(args[i], "^-") then
      -- This might be a custom test function without -run flag
      table.insert(cmds, target)
      table.insert(cmds, "-run")
      table.insert(cmds, args[i])
      goto execute
    end
  end

  -- No custom test function, use default
  table.insert(cmds, target)

  ::execute::
  local cmd = table.concat(cmds, " ")
  print("[GoTest CMD] " .. cmd)

  run_in_terminal(cmd, "GoTest")
end

function M.setup()
  vim.api.nvim_create_user_command("GoBuild", function(opts)
    M.build(unpack(opts.fargs))
  end, {
    nargs = "*",
    desc = "Build Go project with optional -o and -ldflags arguments",
  })

  vim.api.nvim_create_user_command("GoRun", function(opts)
    M.run(unpack(opts.fargs))
  end, {
    nargs = "*",
    desc = "Run Go project with optional -ldflags and custom path",
  })

  vim.api.nvim_create_user_command("GoTest", function(opts)
    M.test(unpack(opts.fargs))
  end, {
    nargs = "*",
    desc = "Run Go tests with optional test function filter",
  })
end

return M

