return {
  {
    "treesj",
    enabled = false,

    keys = {
      {
        "<leader>m",
        function()
          require("treesj").toggle()
        end,
        desc = "Toggle node under cursor",
      },
      {
        "<leader>M",
        function()
          require("treesj").toggle({ split = { recursive = true } })
        end,
        desc = "Toggle node under cursor recursively",
      },
    },

    after = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 5000,
      })
    end,
  },
}
