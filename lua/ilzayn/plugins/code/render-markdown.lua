return {
  {
    "render-markdown.nvim",

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
