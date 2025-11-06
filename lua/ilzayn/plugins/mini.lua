return {
  {
    "mini.move",

    event = "BufReadPre",

    after = function()
      require("mini.move").setup()
    end,
  },
  {
    "mini.surround",

    event = "BufReadPre",

    after = function()
      -- require("mini.surround").setup()
    end,
  },
  {
    "mini.splitjoin",

    event = "BufReadPre",

    after = function()
      require("mini.splitjoin").setup({
        mappings = {
          toggle = "<leader>m",
        },
      })
    end,
  },
}
