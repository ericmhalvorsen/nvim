-- COLOUR

return {
  ---- Theme persistence
  {
    "propet/colorscheme-persist.nvim",
    lazy = false, -- Required: Load on startup to set the colorscheme
    config = true, -- Required: call setup() function
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    -- Set a keymap to open the picker
    -- keys = {
    --   {
    --     "<leader>sc", -- Or your preferred keymap
    --     function()
    --
    --     end,
    --     mode = "n",
    --     desc = "Choose colorscheme",
    --   },
    -- },
    fallback = "tokyonight-storm",
  },
  -- dark / light mode
  { "eliseshaffer/darklight.nvim" },
  -- Themes
  { "Everblush/nvim", name = "everblush", as = "everblush" },
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {},
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = "light"
      require("solarized").setup(opts)
      vim.cmd.colorscheme "solarized"
    end,
  },
  {
    "everviolet/nvim",
    name = "evergarden",
    as = "evergarden",
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    opts = {
      theme = {
        variant = "fall", -- 'winter'|'fall'|'spring'|'summer'
        accent = "green",
      },
      editor = {
        transparent_background = false,
        sign = { color = "none" },
        float = {
          color = "mantle",
          solid_border = false,
        },
        completion = {
          color = "surface0",
        },
      },
    },
  },
  { "jacoborus/tender.vim", as = "tender" },
  { "nyoom-engineering/oxocarbon.nvim" },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      local color = "tokyonight-storm"
      vim.cmd.colorscheme(color)
    end,
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    config = function()
      require("monokai-pro").setup()
    end,
  },
  {
    "sainnhe/sonokai",
    lazy = false,
    config = function()
      vim.g.sonokai_enable_italic = true
      -- vim.g.sonokai_style = "andromeda"
      -- vim.cmd.colorscheme "sonokai"
    end,
  },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    opts = {
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find "catppuccin" then
            opts.highlights = require("catppuccin.special.bufferline").get_theme()
          end
        end,
      },
    },
  },
}
