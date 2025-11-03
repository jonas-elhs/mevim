local M = {}

local palette = {
  background = "#000000",
  foreground = "#ffffff",
  normal = "#00ffff",
  visual = "#0000ff",
  insert = "#00ff00",
  replace = "#ff0000",
  command = "#ffff00",
  terminal = "#ff00ff",
  inactive = "#7f7f7f",
}

function M.get_colors()
  return palette
end

return M
