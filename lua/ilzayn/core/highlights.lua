local utils = require("ilzayn.utils")
local colors = utils.color.get_colors()

local function highlight(name, value, namespace)
  vim.api.nvim_set_hl(namespace or 0, name, value)
end

-- Transparent Highlights
for _, group in ipairs(vim.fn.getcompletion('', 'highlight')) do
  highlight(
    group,
    vim.tbl_extend("keep", { bg = "NONE" }, vim.api.nvim_get_hl(0, { name = group } ))
  )
end

-- Mode highlights
vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged" }, {
  group = vim.api.nvim_create_augroup("IlzaynModeHighlight", { clear = true }),
  callback = function()
    highlight("IlzaynMode", {
      fg = colors.background,
      bg = utils.mode.get_color(),
    })

    highlight("IlzaynModeReverse", {
      fg = utils.mode.get_color(),
      bg = "NONE",
    })
  end,
})
for color_name, color in pairs(colors) do
  highlight(table.concat({ "Ilzayn", (color_name:gsub("^%l", string.upper)) }), {
    fg = colors.background,
    bg = color,
  })
  highlight(table.concat({ "Ilzayn", (color_name:gsub("^%l", string.upper)), "Reverse" }), {
    fg = color,
    bg = "NONE",
  })
end


-- Custom highlights
highlight("CursorLine", {})
highlight("WinSeparator", { link = "IlzaynInactiveReverse" })
