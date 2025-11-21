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
    "MahanRahmati/blink-nerdfont.nvim",
    "marcoSven/blink-cmp-yanky", -- Yank history completion
    "Dynge/gitmoji.nvim", -- Semantic commit message emojis
    "saghen/blink.compat", -- Compatibility layer for nvim-cmp sources
    -- Optional sources (uncomment to enable):
    -- "mikavilpas/blink-ripgrep.nvim", -- Ripgrep search across project
    -- "Kaiser-Yang/blink-cmp-git", -- Git commits/issues/PRs
    -- "krissen/blink-cmp-bibtex", -- BibTeX citations for LaTeX
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
      default = { "lsp", "path", "snippets", "buffer", "lazydev", "ecolog", "yank", "calc", "emoji", "nerdfont" },

      -- Per-filetype sources
      per_filetype = {
        -- Enable emoji and nerdfont for markdown
        markdown = { "lsp", "path", "snippets", "buffer", "emoji", "nerdfont" },
        -- Git commits: gitmoji (semantic commit emojis), nerdfont, and buffer
        gitcommit = { "gitmoji", "nerdfont", "buffer" },
        -- SQL databases with dadbod
        sql = { "lsp", "path", "snippets", "buffer", "dadbod" },
        mysql = { "lsp", "path", "snippets", "buffer", "dadbod" },
        plsql = { "lsp", "path", "snippets", "buffer", "dadbod" },
        -- LaTeX with BibTeX (uncomment if you use LaTeX)
        -- tex = { "lsp", "path", "snippets", "buffer", "bibtex" },
      },

      -- Provider configuration with score offsets for prioritization
      providers = {
        -- LazyDev: Highest priority for Neovim Lua API development
        lazydev = {
          module = "lazydev.integrations.blink",
          name = "LazyDev",
          score_offset = 100,
        },

        -- Ecolog: Environment variable completions from .env files
        ecolog = {
          module = "ecolog.integrations.cmp.blink_cmp",
          name = "Ecolog",
          score_offset = 95,
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

        -- Path: File path completions
        path = {
          name = "Path",
          score_offset = 75,
        },

        -- Buffer: Text from current buffer (higher priority - contextually relevant!)
        buffer = {
          name = "Buffer",
          score_offset = 60,
          max_items = 5, -- Limit buffer completions to avoid clutter
        },

        -- Yank: Clipboard history from yanky.nvim
        yank = {
          module = "blink-yanky",
          name = "Yank",
          score_offset = 55,
          opts = {
            minLength = 3, -- Minimum yank length to show in completion
            onlyCurrentFiletype = false, -- Show yanks from all filetypes
            insert = true, -- Insert the yank on selection
          },
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

        -- Gitmoji: Semantic commit message emojis with descriptions
        gitmoji = {
          module = "gitmoji.blink",
          name = "Gitmoji",
          score_offset = 90, -- High priority for commit messages
          opts = {
            filetypes = { "gitcommit" },
            append_space = true, -- Add space after emoji
            complete_as = "emoji", -- Options: "emoji" or "text"
          },
        },

        -- Nerdfont: Nerd font icon completions triggered by ":"
        nerdfont = {
          module = "blink-nerdfont",
          name = "Nerd Fonts",
          score_offset = 15,
          opts = {
            insert = true, -- Insert icon instead of keeping text
          },
        },

        -- Minuet: AI completions (manual trigger)
        minuet = {
          name = "Minuet",
          module = "minuet.blink",
          score_offset = 10,
          timeout_ms = 10000,
          async = true,
        },

        -- Optional: Ripgrep (search entire project - can be slow on large projects)
        -- Uncomment dependency "mikavilpas/blink-ripgrep.nvim" and add "ripgrep" to sources.default
        -- ripgrep = {
        --   module = "blink-ripgrep",
        --   name = "Ripgrep",
        --   score_offset = 20,
        --   opts = {
        --     prefix_min_len = 3, -- Minimum characters before triggering
        --     get_command = function(_, prefix)
        --       return { "rg", "--no-config", "--json", "--word-regexp", "--", prefix, "." }
        --     end,
        --     get_prefix = function(context)
        --       return context.get_keyword_with_prefix()
        --     end,
        --   },
        -- },

        -- Optional: Git completions (commits, issues, PRs)
        -- Uncomment dependency "Kaiser-Yang/blink-cmp-git" and add "git" to per_filetype sources
        -- git = {
        --   module = "blink-cmp-git",
        --   name = "Git",
        --   score_offset = 80,
        --   opts = {
        --     -- Configuration for git source
        --     filetypes = { "gitcommit", "octo", "markdown" },
        --     remotes = { "upstream", "origin" },
        --   },
        -- },

        -- Database completions (vim-dadbod)
        dadbod = {
          module = "vim_dadbod_completion.blink",
          name = "DB",
          score_offset = 85,
        },

        -- Optional: BibTeX citations for LaTeX (uncomment if using LaTeX)
        -- Uncomment dependency "krissen/blink-cmp-bibtex" and add "bibtex" to per_filetype sources
        -- bibtex = {
        --   module = "blink-cmp-bibtex",
        --   name = "BibTeX",
        --   score_offset = 90,
        --   opts = {
        --     -- Configuration for bibtex source
        --     ft_enable = { "tex", "markdown", "rmd" },
        --   },
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
