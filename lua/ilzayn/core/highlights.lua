local utils = require("ilzayn.utils")
local colors = utils.color.get_colors()

function highlight(name, value, namespace)
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
for mode, color in pairs(utils.color.get_mode_colors()) do
  highlight(
    table.concat({ "Ilzayn", mode:gsub("^%l", string.upper), "Mode" }),
    {
      fg = colors.background,
      bg = color,
    }
  )

  highlight(
    table.concat({ "Ilzayn", mode:gsub("^%l", string.upper), "ModeReverse" }),
    {
      fg = color,
      bg = "NONE",
    }
  )
end

-- Custom highlights
highlight("CursorLine", {})
