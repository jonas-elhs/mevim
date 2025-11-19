return {
  {
    lazy = false,
    "noice.nvim",

    event = "DeferredUIEnter",

    after = function()
      require("noice").setup({
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
        presets = {
          bottom_search = true,
        },
      })
    end,
  },
}
