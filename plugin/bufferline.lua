-- inspired by https://github.com/e-sigs/winbuf.nvim

local bufferline = require("jonas.bufferline")

-- Mappings
vim.keymap.set("n", "]b", function()
  bufferline.cycle_bufs(1)
end)
vim.keymap.set("n", "[b", function()
  bufferline.cycle_bufs(-1)
end)

vim.keymap.set("n", "<leader>x", function()
  bufferline.close_buf()
end, { desc = "Exit buffer" })
vim.keymap.set("n", "<leader>X", function()
  bufferline.close_buf(true)
end, { desc = "Force exit buffer" })

vim.keymap.set("n", "<leader>sx", function()
  bufferline.close_split()
end, { desc = "Exit split" })
vim.keymap.set("n", "<leader>sX", function()
  bufferline.close_split(true)
end, { desc = "Force exit split" })

vim.keymap.set("n", "<C-M-h>", function()
  bufferline.move_buf("h")
end)
vim.keymap.set("n", "<C-M-j>", function()
  bufferline.move_buf("j")
end)
vim.keymap.set("n", "<C-M-k>", function()
  bufferline.move_buf("k")
end)
vim.keymap.set("n", "<C-M-l>", function()
  bufferline.move_buf("l")
end)

vim.keymap.set("n", "<leader>1", function()
  bufferline.open_buf_at(1)
end, { desc = "Open first buffer" })
vim.keymap.set("n", "<leader>2", function()
  bufferline.open_buf_at(2)
end, { desc = "Open second buffer" })
vim.keymap.set("n", "<leader>3", function()
  bufferline.open_buf_at(3)
end, { desc = "Open third buffer" })
vim.keymap.set("n", "<leader>4", function()
  bufferline.open_buf_at(4)
end, { desc = "Open fourth buffer" })
vim.keymap.set("n", "<leader>5", function()
  bufferline.open_buf_at(5)
end, { desc = "Open fifth buffer" })
vim.keymap.set("n", "<leader>6", function()
  bufferline.open_buf_at(6)
end, { desc = "Open sixeth buffer" })
vim.keymap.set("n", "<leader>7", function()
  bufferline.open_buf_at(7)
end, { desc = "Open seventh buffer" })
vim.keymap.set("n", "<leader>8", function()
  bufferline.open_buf_at(8)
end, { desc = "Open eighth buffer" })
vim.keymap.set("n", "<leader>9", function()
  bufferline.open_buf_at(9)
end, { desc = "Open nineth buffer" })

-- Track buffers
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    bufferline.add_buf_to_win(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf())
    vim.schedule(bufferline.set_winbar)
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    bufferline.add_buf_to_win(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf())
    vim.schedule(bufferline.set_winbar)
  end,
})

-- "Move" buffer from previous to new window when creating a new split
local prev_win = nil
vim.api.nvim_create_autocmd("WinNewPre", {
  callback = function()
    prev_win = vim.api.nvim_get_current_win()
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if not prev_win then
      return
    end

    vim.schedule(function()
      local buf = vim.api.nvim_get_current_buf()

      if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then
        bufferline.close_buf(nil, { win = prev_win, dontDelete = true })
        vim.cmd("redrawstatus!")
      end

      prev_win = nil
    end)
  end,
})
