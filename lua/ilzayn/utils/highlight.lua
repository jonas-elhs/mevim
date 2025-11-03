local M = require("ilzayn.utils.mode")

local highlight_utils = {}

highlight_utils.separators = {
  left = "",
  right = "",
}

function highlight_utils.remove_highlights(str)
  return str:gsub("%%%#[a-zA-Z_]+#", "")
end

function highlight_utils.reset()
  return "%#Normal#"
end

function highlight_utils.reverse_group(highlight)
  local reverse = "Reverse"

  return highlight:sub(-#reverse) == reverse
    and highlight:gsub(reverse, "")
    or table.concat({ highlight, reverse })
end

function highlight_utils.module(content, active)
  local separator_highlight = "%#IlzaynModeReverse#"
  local content_highlight = "%#IlzaynMode#"

  return table.concat({
    separator_highlight, highlight_utils.separators.left,

    content_highlight, content,

    separator_highlight, highlight_utils.separators.right,

    highlight_utils.reset(),
  })
end

return highlight_utils
