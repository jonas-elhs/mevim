local color_utils = require("ilzayn.utils.color")

local M = {}

M.mode_type = {
  ["n"]      = "normal",
  ["no"]     = "normal",
  ["nov"]    = "normal",
  ["noV"]    = "normal",
  ["no\22"]  = "normal",
  ["niI"]    = "normal",
  ["niR"]    = "normal",
  ["niV"]    = "normal",
  ["nt"]     = "normal",
  ["ntT"]    = "normal",
  ["v"]      = "visual",
  ["vs"]     = "visual",
  ["V"]      = "visual",
  ["Vs"]     = "visual",
  ["\22"]    = "visual",
  ["\22s"]   = "visual",
  ["s"]      = "visual",
  ["S"]      = "visual",
  ["\19"]    = "visual",
  ["i"]      = "insert",
  ["ic"]     = "insert",
  ["ix"]     = "insert",
  ["R"]      = "replace",
  ["Rc"]     = "replace",
  ["Rx"]     = "replace",
  ["Rv"]     = "replace",
  ["Rvc"]    = "replace",
  ["Rvx"]    = "replace",
  ["c"]      = "command",
  ["cv"]     = "command",
  ["ce"]     = "command",
  ["r"]      = "replace",
  ["rm"]     = "command",
  ["r?"]     = "command",
  ["!"]      = "normal",
  ["t"]      = "terminal",
}
M.mode_name = {
  ["n"]      = "NORMAL",
  ["no"]     = "O-PENDING",
  ["nov"]    = "O-PENDING",
  ["noV"]    = "O-PENDING",
  ["no\22"]  = "O-PENDING",
  ["niI"]    = "NORMAL",
  ["niR"]    = "NORMAL",
  ["niV"]    = "NORMAL",
  ["nt"]     = "NORMAL",
  ["ntT"]    = "NORMAL",
  ["v"]      = "VISUAL",
  ["vs"]     = "VISUAL",
  ["V"]      = "V-LINE",
  ["Vs"]     = "V-LINE",
  ["\22"]    = "V-BLOCK",
  ["\22s"]   = "V-BLOCK",
  ["s"]      = "SELECT",
  ["S"]      = "S-LINE",
  ["\19"]    = "S-BLOCK",
  ["i"]      = "INSERT",
  ["ic"]     = "INSERT",
  ["ix"]     = "INSERT",
  ["R"]      = "REPLACE",
  ["Rc"]     = "REPLACE",
  ["Rx"]     = "REPLACE",
  ["Rv"]     = "V-REPLACE",
  ["Rvc"]    = "V-REPLACE",
  ["Rvx"]    = "V-REPLACE",
  ["c"]      = "COMMAND",
  ["cv"]     = "EX",
  ["ce"]     = "EX",
  ["r"]      = "REPLACE",
  ["rm"]     = "MORE",
  ["r?"]     = "CONFIRM",
  ["!"]      = "SHELL",
  ["t"]      = "TERMINAL",
}

function M.get_type()
  local mode = vim.api.nvim_get_mode().mode

  return M.mode_type[mode]
end

function M.get_name()
  local mode = vim.api.nvim_get_mode().mode

  return M.mode_name[mode]
end

function M.get_color()
  return require("ilzayn.utils").color.get_colors()[M.get_type():lower()]
end

function M.get_highlight_group(reverse)
  return table.concat({
    "Ilzayn",
    M.get_type():gsub("^%l", string.upper),
    "Mode",
    reverse == true and "Reverse" or "",
  })
end

function M.get_highlight(reverse)
  return table.concat({
    "%#",
    M.get_highlight_group(reverse),
    "#",
  })
end

return M
