local utils = require("ilzayn.utils")

local function get_center_spacing(left_component, center_component)
  left_component = utils.highlight.remove_highlights(left_component)
  center_component = utils.highlight.remove_highlights(center_component)

  local left_width = vim.api.nvim_strwidth(left_component)

  local center_width = vim.api.nvim_strwidth(center_component)
  local center_center = math.floor(center_width / 2)

  local window_width = vim.opt.columns._value
  local window_center = math.floor(window_width / 2)

  local space_count = window_center - center_center - left_width

  return string.rep(" ", space_count)
end

function Statusline()
  local mode_module = require("ilzayn.core.ui.statusline.mode")()
  local file_module = require("ilzayn.core.ui.statusline.file")()
  local line_module = require("ilzayn.core.ui.statusline.line")()

  return table.concat({
    mode_module,

    utils.width.more_than(35)
      and get_center_spacing(mode_module, file_module)
      or "%=",

    file_module,

    utils.width.more_than(35)
      and table.concat({ "%=", line_module, })
      or "",
  })
end

vim.opt.statusline = "%!v:lua.Statusline()"
