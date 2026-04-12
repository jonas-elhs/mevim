vim.opt.rtp:prepend("/home/jonas/dev/jj.nvim/")

require("jj").setup({
  terminal = {
    window = {
      type = "floating",
      floating_width = 0.85,
      floating_height = 0.8,
    },
  },

  cmd = {
    describe = {
      editor = {
        type = "input",
      },
    },
  },
})

vim.keymap.set("n", "<leader>js", "<CMD>J status<CR>")
vim.keymap.set("n", "<leader>jl", "<CMD>J log<CR>")
vim.keymap.set("n", "<leader>jd", "<CMD>J describe<CR>")
vim.keymap.set("n", "<leader>jn", function()
  vim.ui.input({ prompt = "New Description" }, function(input)
    require("jj.cmd").new({ args = "-m '" .. (input or "") .. "'" })
  end)
end)
vim.keymap.set("n", "<leader>jP", "<CMD>J push<CR>")
vim.keymap.set("n", "<leader>jS", "<CMD>J split<CR>")
vim.keymap.set("n", "<leader>jD", "<CMD>J diff<CR>")
-- TODO: bookmarks
