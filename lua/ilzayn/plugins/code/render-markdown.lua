return {
  {
    "render-markdown.nvim",

    ft = "markdown",

    after = function()
      require("render-markdown").setup({
        completions = {
          lsp = {
            enabled = true,
          },
        },
      })
    end
  },
}
