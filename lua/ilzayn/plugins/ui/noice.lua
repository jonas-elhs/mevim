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
