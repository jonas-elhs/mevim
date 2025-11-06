return {
  {
    "helpview.nvim",

    lazy = false,
    enabled = false,

    after = function()
      require("helpview").setup({
        preview = {
          icon_provider = "devicons",
        },
      })
    end,
  },
}
