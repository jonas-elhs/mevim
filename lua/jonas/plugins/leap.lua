require("leap").setup({
  safe_labels = "",
})

vim.keymap.set({ "n", "x" }, "s", "<Plug>(leap-anywhere)")

-- Remote action
vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("leap.remote").action()
end)

-- Remote text object
for _, ai in ipairs({ "a", "i" }) do
  vim.keymap.set({ "x", "o" }, ai .. "r", function()
    local ok, char = pcall(vim.fn.getcharstr)
    if not ok or (char == vim.keycode("<ESC>")) then
      return
    end

    require("leap.remote").action({ input = ai .. char })
  end)
end
