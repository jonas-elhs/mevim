return {
  {
    "treesj",

    event = "DeferredUIEnter",

    after = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 5000,
      })

      local map = require("ilzayn.utils").keymap.map
      map("n", "<leader>m", require("treesj").toggle, "Toggle node under cursor")
      map("n", "<leader>M", function()
        require("treesj").toggle({
          split = { recursive = true },
        })
      end, "Toggle node under cursor recursively")
    end,
  },
}
