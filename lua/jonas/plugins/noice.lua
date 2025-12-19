require("noice").setup({
  popupmenu = {
    enabled = false, -- overwrites builtin completion menu
  },

  views = {
    cmdline_popup = {
      position = {
        row = 0.2,
      },
    },
  },
  cmdline = {
    opts = {
      border = {
        text = {
          top = " Command Line ",
        },
      },
    },
  },
  messages = {
    enabled = true,
  },
  notify = {
    enabled = false,
  },
  lsp = {
    hover = {
      enabled = false,
    },
    signature = {
      enabled = false,
    },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    bottom_search = true,
  },
})
