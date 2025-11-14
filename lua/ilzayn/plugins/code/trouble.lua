return {
  {
    "trouble.nvim",

    cmd = { "Trouble" },
    keys = {
      { "<leader>x", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>X", "<CMD>Trouble diagnostics toggle<CR>", desc = "Project Diagnostics (Trouble)" },
      { "<leader>cs", "<CMD>Trouble symbols toggle focus=false<CR>", desc = "Document Symbols (Trouble)"}
    },

    after = function()
      require("trouble").setup({
        warn_no_results = false,
        open_no_results = true,

        win = {
          wo = {
            wrap = true,
            breakindent = true,
          },
          position = "right",
          size = 0.2,
        },
      })
    end,
  }
}
