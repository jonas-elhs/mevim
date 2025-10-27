local M = {}

local palette = {
  background = "#000000",
  foreground = "#ffffff",
  accent = "#00ffff",
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

function M.get_mode_colors()
  return {
    normal = palette.accent,
    visual = palette.visual,
    insert = palette.insert,
    replace = palette.replace,
    command = palette.command,
    terminal = palette.terminal,
  }
end

return M
