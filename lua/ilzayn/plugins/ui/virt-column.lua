return {
  {
    "virt-column.nvim",

    after = function()
      local color_column = vim.api.nvim_get_hl(0, { name = "ColorColumn" })

      require("virt-column").setup({
        char = "┃",
        highlight = "ColorColumn",
      })

      highlight("ColorColumn", color_column)
    end,
  },
}
