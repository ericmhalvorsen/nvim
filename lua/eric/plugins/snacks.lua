-- Snacks.nvim - Enhanced dashboard with fortune/cowsay/lolcat
-- Requires: fortune, cowsay, lolcat installed on the system
-- Install on Linux: sudo apt install fortune-mod cowsay lolcat
-- Install on macOS: brew install fortune cowsay lolcat
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    scroll = { enabled = false },
    indent = {
      scope = { enabled = false },
    },
    terminal = {},
    input = {},
    picker = {},
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        {
          pane = 1,
          { section = "keys", padding = 1, gap = 1 },
          { section = "startup" },
        },
        {
          pane = 2,
          {
            section = "terminal",
            cmd = "output=$(fortune | cowsay); padding=$(( (14 - $(echo $output | wc -l)) / 2 )); [ $padding -gt 0 ] && printf '%.0s\n' $(seq 1 $padding); echo $output | lolcat; sleep .1",
            random = 10,
            height = 14,
          },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
        },
      },
    },
  },
}
