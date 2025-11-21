return { -- Autocompletion
  "saghen/blink.cmp",
  event = "VimEnter",
  version = "1.*",
  dependencies = {
    -- Snippet Engine
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
      opts = {},
    },
    "folke/lazydev.nvim",
    "milanglacier/minuet-ai.nvim",
    -- Additional completion sources
    "moyiz/blink-emoji.nvim",
    "saghen/blink.compat", -- Compatibility layer for nvim-cmp sources
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      preset = "enter",

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      ["<tab>"] = {
        function(cmp)
          cmp.show {}
        end,
      },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
      -- Set to nvim-cmp fallback highlight groups when your theme doesn't support blink.cmp
      use_nvim_cmp_as_default = false,
    },

    completion = {
      
      -- REFERENCE
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      -- documentation = { auto_show = true, auto_show_delay_ms = 500 },
      -- trigger = { prefetch_on_insert = false },
      -- documentation = {
      --   auto_show = true,
      --   auto_show_delay_ms = 100,
      --   update_delay_ms = 50,
      --   window = {
      --     max_width = math.min(80, vim.o.columns),
      --     border = "rounded",
      --   },
      -- },
      -- list = {
      --   selection = {
      --     preselect = false,
      --   },

      -- END


      -- Disable completion in certain buffers to prevent slowdowns
      enabled = function()
        local disabled_filetypes = {
          "TelescopePrompt",
          "mini.files",
          "snacks_picker",
        }
        local buftype = vim.bo.buftype
        local filetype = vim.bo.filetype

        return not vim.tbl_contains(disabled_filetypes, filetype)
          and buftype ~= "prompt"
      end,

      -- Customize the completion menu appearance
      menu = {
        border = "rounded",
        -- Draw custom columns in the menu
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
          -- Customize how components appear
          components = {
            source_name = {
              width = { max = 30 },
              text = function(ctx)
                return "[" .. ctx.source_name .. "]"
              end,
              highlight = "Comment",
            },
          },
        },
      },

      -- Documentation window configuration
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200, -- Faster than default 1000ms
        window = {
          border = "rounded",
          max_width = 80,
          max_height = 20,
        },
      },

      -- Ghost text configuration
      ghost_text = {
        enabled = true,
      },

      -- Trigger configuration
      trigger = {
        prefetch_on_insert = false,
      },
    },

    sources = {
      -- Default sources active in all buffers
      default = { "lsp", "path", "snippets", "buffer", "lazydev", "calc", "emoji" },

      -- Per-filetype sources (examples commented out)
      per_filetype = {
        -- Enable emoji for markdown and git commits
        markdown = { "lsp", "path", "snippets", "buffer", "emoji" },
        gitcommit = { "emoji", "buffer" },
        -- SQL databases with dadbod (uncomment if you use vim-dadbod)
        -- sql = { "lsp", "path", "snippets", "buffer", "dadbod" },
      },

      -- Provider configuration with score offsets for prioritization
      providers = {
        -- LazyDev: Highest priority for Neovim Lua API development
        lazydev = {
          module = "lazydev.integrations.blink",
          name = "LazyDev",
          score_offset = 100,
        },

        -- LSP: High priority for language server completions
        lsp = {
          name = "LSP",
          score_offset = 90,
        },

        -- Snippets: High priority for code snippets
        snippets = {
          name = "Snippets",
          score_offset = 85,
        },

        -- Calc: Math calculations (e.g., type "2+2" get "4")
        calc = {
          module = "blink.compat.source",
          name = "Calc",
          score_offset = 50,
          opts = {
            -- Use hrsh7th/cmp-calc via compatibility layer
            name = "calc",
          },
        },

        -- Emoji: Emoji completions triggered by ":"
        emoji = {
          module = "blink-emoji",
          name = "Emoji",
          score_offset = 15,
          opts = {
            insert = true, -- Insert emoji instead of keeping text
          },
        },

        -- Path: File path completions
        path = {
          name = "Path",
          score_offset = 75,
        },

        -- Buffer: Text from current buffer (lower priority)
        buffer = {
          name = "Buffer",
          score_offset = 10,
          max_items = 5, -- Limit buffer completions to avoid clutter
        },

        -- Minuet: AI completions (manual trigger)
        minuet = {
          name = "Minuet",
          module = "minuet.blink",
          score_offset = 10,
          timeout_ms = 10000,
          async = true,
        },

        -- Optional: Database completions (uncomment if using vim-dadbod)
        -- dadbod = {
        --   module = "vim_dadbod_completion.blink",
        --   name = "DB",
        --   score_offset = 85,
        -- },
      },
    },

    snippets = { preset = "luasnip" },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },

    -- Shows a signature help window while you type arguments for a function
    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },
  },
}
