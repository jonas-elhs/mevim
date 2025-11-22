local colors = Utils.get_colors()

local function highlight(name, value, namespace)
  vim.api.nvim_set_hl(namespace or 0, name, value)
end

-- Transparent Highlights
for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
  highlight(group, Utils.extend_highlight(group, { bg = "NONE" }))
end

-- Mode highlights
vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged" }, {
  group = vim.api.nvim_create_augroup("JonasCurrentModeHighlight", { clear = true }),
  callback = function()
    highlight("JonasCurrentMode", {
      fg = colors.background,
      bg = Utils.get_current_mode_color(),
    })
    highlight("JonasCurrentModeBold", {
      fg = colors.background,
      bg = Utils.get_current_mode_color(),
      bold = true,
    })

    highlight("JonasCurrentModeReverse", {
      fg = Utils.get_current_mode_color(),
      bg = "NONE",
    })
    highlight("JonasCurrentModeBoldReverse", {
      fg = Utils.get_current_mode_color(),
      bg = "NONE",
      bold = true,
    })
  end,
})
for color_name, color in pairs(colors) do
  highlight("Jonas" .. color_name:gsub("^%l", string.upper), {
    fg = colors.background,
    bg = color,
  })
  highlight("Jonas" .. color_name:gsub("^%l", string.upper) .. "Reverse", {
    fg = color,
    bg = "NONE",
  })
end

-- Custom highlights
highlight("Folded", { bg = "grey" })
