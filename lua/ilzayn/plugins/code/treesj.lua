return {
  {
    "treesj",

    event = { "BufReadPre", "BufNewFile" },

    after = function()
      require("treesj").setup({
        use_default_keymaps = false,
        max_join_length = 5000,
      })

      vim.keymap.set("n", "<leader>m", require("treesj").toggle, { desc = "Toggle node under cursor" })
      vim.keymap.set("n", "<leader>M", function()
        require("treesj").toggle({
          split = { recursive = true },
        })
      end, { desc = "Toggle node under cursor recursively" })
    end,
  },
}
