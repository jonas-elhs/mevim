return {
  {
    "nvim-colorizer.lua",

    event = "BufReadPre",

    after = function()
      require("colorizer").setup({
        user_default_options = {
          css = true,
          tailwind = true,
          sass = {
            enable = true,
            parsers = { "css" },
          },
          mode = "virtualtext",
          virtualtext = "󱓻",
          virtualtext_inline = "before",
        },
      })
    end,
  }
}
