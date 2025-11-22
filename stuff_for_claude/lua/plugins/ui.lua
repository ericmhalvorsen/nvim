return {
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
      indent = {
        scope = { enabled = false },
      },
      dashboard = {
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
            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
          },
        },
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    enabled = true,
    opts = {
      stiffness = 0.6,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.1,
    },
  },
  {
    "b0o/incline.nvim",
    config = function()
      require("incline").setup({
        debounce_threshold = {
          falling = 50,
          rising = 10,
        },
        hide = {
          cursorline = true,
          focused_win = false,
          only_win = false,
        },
        highlight = {
          groups = {
            InclineNormal = {
              default = true,
              group = "NormalFloat",
            },
            InclineNormalNC = {
              default = true,
              group = "NormalFloat",
            },
          },
        },
        ignore = {
          buftypes = "special",
          filetypes = {},
          floating_wins = true,
          unlisted_buffers = true,
          wintypes = "special",
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified and "bold,italic" or "bold"

          local function get_git_diff()
            local icons = { removed = " ", changed = " ", added = " " }
            icons["changed"] = icons.modified
            local signs = vim.b[props.buf].gitsigns_status_dict
            local labels = {}
            if signs == nil then
              return labels
            end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
              end
            end
            if #labels > 0 then
              table.insert(labels, { "┊ " })
            end
            return labels
          end
          local function get_diagnostic_label()
            local icons = { error = " ", warn = " ", info = " ", hint = " " }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { "┊ " })
            end
            return label
          end

          local buffer = {
            { get_diagnostic_label() },
            { get_git_diff() },
            { (ft_icon or "") .. "  ", guifg = ft_color, guibg = "none" },
            { filename .. " ", gui = modified },
          }
          return buffer
        end,
        window = {
          margin = {
            horizontal = 1,
            vertical = 1,
          },
          options = {
            signcolumn = "no",
            wrap = false,
          },
          overlap = {
            borders = true,
            statusline = false,
            tabline = false,
            winbar = false,
          },
          padding = 1,
          padding_char = " ",
          placement = {
            horizontal = "right",
            vertical = "top",
          },
          width = "fit",
          winhighlight = {
            active = {
              EndOfBuffer = "None",
              Normal = "InclineNormal",
              Search = "None",
            },
            inactive = {
              EndOfBuffer = "None",
              Normal = "InclineNormalNC",
              Search = "None",
            },
          },
          zindex = 50,
        },
      })
    end,
    -- Optional: Lazy load Incline
    event = "VeryLazy",
  },
}
