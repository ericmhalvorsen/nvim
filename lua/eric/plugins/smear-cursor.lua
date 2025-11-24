-- Smear Cursor - Smooth cursor animations
-- Makes cursor movement smooth and animated instead of instant jumps
return {
  "sphamba/smear-cursor.nvim",
  enabled = true,
  opts = {
    stiffness = 0.6,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.1,
  },
}
