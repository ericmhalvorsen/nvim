local map = LazyVim.safe_keymap_set

local function keymap(modes, key, command, opts)
  for _, mode in ipairs(modes) do
    map(mode, key, command, opts)
  end
end

return {
  keymap = keymap,
}
