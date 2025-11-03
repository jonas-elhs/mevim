return {
  {
    "colorful-winsep",

    event = "DeferredUIEnter",

    after = function()
      require("colorful-winsep").setup({
        border = "rounded",
      })

      vim.api.nvim_set_hl(0, "ColorfulWinSep", { link = "IlzaynModeReverse" })
    end,
  },
}
