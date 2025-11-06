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
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          replace = "gsr",
          find = "",
          find_left = "",
          highlight = "",
        },

        silent = true,
      })
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
