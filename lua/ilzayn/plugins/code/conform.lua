return {
  {
    "conform.nvim",

    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true })
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
      })
    end,
  },
}
