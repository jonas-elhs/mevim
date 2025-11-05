return {
  {
    "mini.move",

    after = function()
      require("mini.move").setup()
    end,
  },
  {
    "mini.surround",

    after = function()
      -- require("mini.surround").setup()
    end,
  },
  {
    "mini.splitjoin",

    after = function()
      require("mini.splitjoin").setup({
        mappings = {
          toggle = "<leader>m",
        },
      })
    end,
  },
}
