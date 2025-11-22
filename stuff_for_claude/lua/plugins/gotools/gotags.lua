local M = {}

function M.add_tags(start_line, end_line, ...)
  vim.cmd("w")

  local filename = vim.fn.expand("%:t")
  local line = start_line .. "," .. end_line

  local cmds = { "gomodifytags" }
  table.insert(cmds, "-file")
  table.insert(cmds, filename)
  table.insert(cmds, "-line")
  table.insert(cmds, line)
  table.insert(cmds, "--skip-unexported")
  table.insert(cmds, "-w")
  table.insert(cmds, "--quiet")

  local args = { ... }

  if args[1] then
    if args[1] ~= "--" then
      table.insert(cmds, "-add-tags")
      table.insert(cmds, args[1])
    end
  else
    table.insert(cmds, "-add-tags")
    table.insert(cmds, "json")
  end

  if args[2] then
    if args[2] ~= "--" then
      table.insert(cmds, "-add-options")
      table.insert(cmds, args[2])
    end
  else
    table.insert(cmds, "-add-options")
    table.insert(cmds, "json=omitempty")
  end

  if args[3] then
    if args[3] ~= "--" then
      table.insert(cmds, "-transform")
      table.insert(cmds, args[3])
    end
  else
    table.insert(cmds, "-transform")
    table.insert(cmds, "camelcase")
  end

  local cmd = table.concat(cmds, " ")
  print("[GoTags CMD] " .. cmd)

  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    print("[GoTags Error] " .. result)
    return
  end

  vim.cmd("e!")
end

function M.remove_tags(start_line, end_line, ...)
  vim.cmd("w")

  local filename = vim.fn.expand("%:t")
  local line = start_line .. "," .. end_line

  local cmds = { "gomodifytags" }
  table.insert(cmds, "-file")
  table.insert(cmds, filename)
  table.insert(cmds, "-line")
  table.insert(cmds, line)
  table.insert(cmds, "-transform")
  table.insert(cmds, "camelcase")
  table.insert(cmds, "--skip-unexported")
  table.insert(cmds, "-w")
  table.insert(cmds, "--quiet")

  local args = { ... }

  if args[1] then
    if args[1] ~= "--" then
      table.insert(cmds, "-remove-tags")
      table.insert(cmds, args[1])
    end
  else
    table.insert(cmds, "-remove-tags")
    table.insert(cmds, "json")
  end

  if args[2] then
    if args[2] ~= "--" then
      table.insert(cmds, "-remove-options")
      table.insert(cmds, args[2])
    end
  else
    table.insert(cmds, "-remove-options")
    table.insert(cmds, "json=omitempty")
  end

  local cmd = table.concat(cmds, " ")
  print("[GoTags CMD] " .. cmd)

  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    print("[GoTags Error] " .. result)
    return
  end

  vim.cmd("e!")
end

function M.setup()
  vim.api.nvim_create_user_command("GoTagsAdd", function(opts)
    M.add_tags(opts.line1, opts.line2, unpack(opts.fargs))
  end, {
    range = true,
    nargs = "*",
    desc = "Add tags to Go structs",
  })

  vim.api.nvim_create_user_command("GoTagsRemove", function(opts)
    M.remove_tags(opts.line1, opts.line2, unpack(opts.fargs))
  end, {
    range = true,
    nargs = "*",
    desc = "Remove tags from Go structs",
  })
end

return M
