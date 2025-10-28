return {
  {
    "helpview.nvim",

    lazy = false,

    after = function()
      require("helpview").setup({
        preview = {
          icon_provider = "devicons",
        },
      })
    end,
  },
}
