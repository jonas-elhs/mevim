return {
  {
    "conform.nvim",

    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format()
        end,
        desc = "Format buffer",
      },
      {
        "<leader>F",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n", "x" },
        desc = "Format injected languages",
      },
    },

    after = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "alejandra" },
          rust = { "rustfmt" },
        },
        format_on_save = {
          timeout_ms = 500,
        },
      })
    end,
  },
}
