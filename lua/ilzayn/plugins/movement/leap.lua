return {
  {
    "leap.nvim",

    keys = {
      {
        mode = { "n", "x", "o" },
        "s",
        "<Plug>(leap)",
        desc = "Leap",
      },
      {
        mode = { "x", "o" },
        "r",
        function()
          require("leap.remote").action()
        end,
      },
    },

    after = function()
      require("leap").setup({
        safe_labels = "",
        max_phase_one_targets = 1,
      })

      vim.api.nvim_set_hl(0, "LeapLabel", { fg = "#ff0000", bg = "NONE", bold = true })
    end,
  },
}
