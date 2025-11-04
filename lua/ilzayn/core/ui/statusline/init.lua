local utils = require("ilzayn.utils")

local mode_module = require("ilzayn.core.ui.statusline.mode")
local file_module = require("ilzayn.core.ui.statusline.file")
local line_module = require("ilzayn.core.ui.statusline.line")

local function get_center_spacing(left_component, center_component)
  local left_width = vim.api.nvim_strwidth(left_component)

  local center_width = vim.api.nvim_strwidth(center_component)
  local center_center = math.floor(center_width / 2)

  local window_width = vim.opt.columns._value
  local window_center = math.floor(window_width / 2)

  local space_count = window_center - center_center - left_width

  return string.rep(" ", space_count)
end
local function highlight_module(content)
  local separator_highlight = "%#IlzaynModeReverse#"
  local content_highlight = "%#IlzaynMode#"

  return table.concat({
    separator_highlight, "",

    content_highlight, content,

    separator_highlight, "",

    "%#Normal#",
  })
end

function Statusline()
  local left_module = mode_module()
  local center_module = file_module()
  local right_module = line_module()

  return table.concat({
    highlight_module(left_module),

    utils.width.more_than(35)
      and get_center_spacing(left_module, center_module)
      or "%=",

    center_module,

    utils.width.more_than(35)
      and table.concat({ "%=", highlight_module(right_module) })
      or "",
  })
end

vim.opt.statusline = "%!v:lua.Statusline()"
