return {
  "ph1losof/ecolog.nvim",
  -- Load early to ensure environment variables are available
  lazy = false,
  keys = {
    { "<leader>ge", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
    { "<leader>ep", "<cmd>EcologPeek<cr>", desc = "Peek env variable value" },
    { "<leader>es", "<cmd>EcologSelect<cr>", desc = "Select/switch env file" },
    { "<leader>et", "<cmd>EcologShelterToggle<cr>", desc = "Toggle env value masking" },
  },
  opts = {
    -- Enable integration with blink.cmp for environment variable completion
    integrations = {
      nvim_cmp = false, -- We're using blink.cmp instead
      blink_cmp = true, -- Enable blink.cmp integration
    },

    -- Sync environment variables with vim.env (accessible to all Neovim plugins)
    vim_env = true,

    -- Working directory path (default: current working directory)
    path = vim.fn.getcwd(),

    -- Preferred environment when multiple .env files exist
    -- Options: "development", "production", "local", "test", etc.
    preferred_environment = "development",

    -- Shelter mode: security features for sensitive data
    shelter = {
      configuration = {
        -- Partial mode: false = fully mask, true = show partial value
        partial_mode = false,
        -- Character used for masking
        mask_char = "*",
      },
      -- Which modules should mask sensitive values
      modules = {
        cmp = true, -- Mask in completion menu
        peek = false, -- Don't mask when peeking (you want to see the value)
        files = true, -- Mask in file display
        telescope = true, -- Mask in telescope picker
      },
    },

    -- Enable type checking and validation for environment variables
    types = true,

    -- Detect and use provider-specific patterns (e.g., Vercel, Railway, etc.)
    provider_patterns = true,

    -- Support for monorepo workspaces (Turborepo, Nx, Lerna, Rush)
    -- Automatically detects and switches between workspace environments
    -- (No explicit config needed - auto-detection works out of the box)
  },
}
