return {
  {
    "colorful-winsep",

    event = "DeferredUIEnter",

    after = function()
      require("colorful-winsep").setup({
        border = "rounded",
      })
    end,
  },
}
