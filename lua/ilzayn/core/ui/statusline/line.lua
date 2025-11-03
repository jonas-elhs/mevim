local utils = require("ilzayn.utils")

local function get_line_progress()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")

  if current_line == 1 then
    return "Top"
  elseif current_line == total_lines then
    return "Bottom"
  else
    return string.format("%d%%%%", math.floor(current_line / total_lines * 100))
  end
end

local function get_line_location()
  return "%l:%c"
end

return function()
  return utils.highlight.module(
    table.concat({
      utils.width.more_than(50) and "  " or " ",

      utils.width.more_than(70)
        and table.concat({ get_line_progress(), "  |  " })
        or "",

      get_line_location(),

      utils.width.more_than(50) and "  " or " ",
    })
  )
end
