return {
  {
    "leap.nvim",

    lazy = false,

    after = function()
      require("leap").setup({
        safe_labels = "",
        max_phase_one_targets = 1,
      })

      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")

      vim.keymap.set({ "x", "o"}, "r", function ()
        require("leap.remote").action()
      end)

      vim.api.nvim_set_hl(0, "LeapLabel", { fg = "#ff0000", bg = "NONE", bold = true })
    end
  },
}
