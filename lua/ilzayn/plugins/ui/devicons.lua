return {
  {
    "nvim-web-devicons",

    lazy = false,

    after = function()
      require("nvim-web-devicons").setup({
        strict = true,
      })
    end,
  },
}
