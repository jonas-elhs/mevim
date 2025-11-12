return {
  {
    "blink.pairs",

    event = { "BufReadPre", "BufNewFile" },

    after = function()
      require("blink.pairs").setup({})
    end,
  },
}
