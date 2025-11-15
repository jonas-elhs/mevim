return {
  {
    "conform.nvim",

    keys = {
      {
        "<leader>f",
        function()
          require("conform").format()
        end,
        desc = "Format buffer",
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
