return {
  {
    lazy = false,
    "mini.diff",

    after = function()
      require("mini.diff").setup({
        view = {
          priority = 0,
        },
      })
    end,
  },
}
