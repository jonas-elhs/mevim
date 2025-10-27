return {
  {
    "noice.nvim",

    event = "DeferredUIEnter",

    after = function()
      require("noice").setup({
        views = {
          cmdline_popup = {
            position = {
              row = 18,
            },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = 20,
              col = "50%",
            },
            size = {
              width = 56,
              height = "auto",
            },
            border = {
              style = {
                top_left    = "│", top    = " ",    top_right = "│",
                left        = "│",                      right = "│",
                bottom_left = "╰", bottom = "─", bottom_right = "╯",
              },
              padding = { 0, 3 },
            },
            win_options = {
              winhighlight = {
                Normal = "Normal",
                FloatBorder = "DiagnosticInfo",
              },
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
          format = {
            search_down = {
              view = "cmdline",
            },
            search_up = {
              view = "cmdline",
            },
          },
        },
        messages = {
          enabled = true
        },
        notify = {
          enabled = true,
        },
        lsp = {
          progress = {
            enabled = false,
          },
          hover = {
            enabled = false,
          },
          signature = {
            enabled = false,
          },
          messages = {
            enabled = false,
          },
        },
      })
    end,
  },
}
