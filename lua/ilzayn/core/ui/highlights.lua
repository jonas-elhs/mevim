local utils = require("ilzayn.utils")
local colors = utils.get_colors()

local function highlight(name, value, namespace)
  vim.api.nvim_set_hl(namespace or 0, name, value)
end

-- Transparent Highlights
for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
  highlight(group, utils.extend_highlight(group, { bg = "NONE" }))
end

-- Mode highlights
vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged" }, {
  group = vim.api.nvim_create_augroup("IlzaynModeHighlight", { clear = true }),
  callback = function()
    highlight("IlzaynMode", {
      fg = colors.background,
      bg = utils.get_current_mode_color(),
    })

    highlight("IlzaynModeReverse", {
      fg = utils.get_current_mode_color(),
      bg = "NONE",
    })
  end,
})
for color_name, color in pairs(colors) do
  highlight("Ilzayn" .. color_name:gsub("^%l", string.upper), {
    fg = colors.background,
    bg = color,
  })
  highlight("Ilzayn" .. color_name:gsub("^%l", string.upper) .. "Reverse", {
    fg = color,
    bg = "NONE",
  })
end

-- Custom highlights
highlight("Folded", { bg = "grey" })
highlight("CursorLineNr", { link = "IlzaynModeReverse" })
highlight("WinSeparator", { link = "IlzaynInactiveReverse" })
