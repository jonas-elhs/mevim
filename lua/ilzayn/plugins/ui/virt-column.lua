return {
  {
    "virt-column.nvim",

    after = function()
      require("virt-column").setup({
        char = "┃",
        highlight = "ColorColumn",
      })
    end,
  },
}
