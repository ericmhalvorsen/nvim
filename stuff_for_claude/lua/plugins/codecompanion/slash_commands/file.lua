return {
  callback = "strategies.chat.slash_commands.file",
  description = "Select a file using Telescope",
  opts = {
    provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
    contains_code = true,
  },
}
