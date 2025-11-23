-- blink.pairs
require("blink.pairs").setup({
  highlights = {
    enabled = false,
  },
})

-- blink.cmp
require("blink.cmp").setup({
  keymap = {
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<Enter>"] = { "accept", "fallback" },

    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },

    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<C-u"] = { "scroll_documentation_up", "fallback" },

    ["<C-;>"] = { "show_signature", "hide_signature", "fallback" },
  },

  cmdline = {
    enabled = true,

    keymap = {
      preset = "inherit",
    },

    completion = {
      ghost_text = {
        enabled = false,
      },
      menu = {
        auto_show = function()
          return vim.fn.getcmdtype() == ":" and vim.g.autoshow_autocomplete
        end,
      },
    },
  },
  completion = {
    menu = {
      scrollbar = false,
      auto_show = function()
        return vim.g.autoshow_autocomplete
      end,

      draw = {
        treesitter = { "lsp" },
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
      },
    },
  },
  signature = {
    enabled = true,

    trigger = {
      enabled = false,
    },
  },

  sources = {
    default = { "lsp", "lazydev", "path", "buffer" },

    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
})

Utils.toggle({
  name = "Autoshow Auto Complete",
  command = "Autocomplete",
  toggle_keymap = "<leader>ta",

  enable = function()
    vim.g.autoshow_autocomplete = true
  end,
  disable = function()
    vim.g.autoshow_autocomplete = false
  end,
  enabled = function()
    return vim.g.autoshow_autocomplete == true
  end,
})
