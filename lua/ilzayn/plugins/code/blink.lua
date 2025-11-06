return {
  {
    "lazydev.nvim",

    dep_of = { "blink.cmp" },

    after = function()
      require("lazydev").setup({
        library = {
          path = "${3rd}/luv/library",
          words = "vim%.uv",
        },
      })
    end,
  },
  {
    "blink.cmp",

    event = "DeferredUIEnter",

    after = function()
      require("blink.cmp").setup({
        keymap = {
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<Enter>" ]  = { "accept", "fallback" },

          ["<C-j>"]     = { "select_next", "fallback" },
          ["<C-k>"]     = { "select_prev", "fallback" },

          ["<C-d>"]     = { "scroll_documentation_down", "fallback" },
          ["<C-u"]      = { "scroll_documentation_up", "fallback" },

          ["<C-;>"]     = { "show_signature", "hide_signature", "fallback" },
        },

        cmdline = {
          enabled = false,
        },
        completion = {
          menu = {
            scrollbar = false,

            draw = {
              columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 1 },
                { "source_name" },
              },
            },
          },
          -- documentation = {
          --   window = {
          --     scrollbar = false,
          --   },
          -- },
        },
        signature = {
          enabled = true,

          trigger = {
            enabled = false,
          },
        },

        sources = {
          default = { "lazydev", "lsp", "path", "buffer" },

          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
          },
        },
      })
    end,
  },
}
