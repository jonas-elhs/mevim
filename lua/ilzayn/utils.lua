local M = {}

function M.width_less_than(target)
  return vim.o.columns <= target
end
function M.width_more_than(target)
  return vim.o.columns > target
end

function M.get_colors()
  return {
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
end
function M.remove_highlight_groups_from_string(str)
  return str:gsub("%%%#[a-zA-Z_]+#", "")
end

M.mode_map = {
  ["n"]      = { "normal", "NORMAL" },
  ["no"]     = { "normal", "O-PENDING" },
  ["nov"]    = { "normal", "O-PENDING" },
  ["noV"]    = { "normal", "O-PENDING" },
  ["no\22"]  = { "normal", "O-PENDING" },
  ["niI"]    = { "normal", "NORMAL" },
  ["niR"]    = { "normal", "NORMAL" },
  ["niV"]    = { "normal", "NORMAL" },
  ["nt"]     = { "normal", "NORMAL" },
  ["ntT"]    = { "normal", "NORMAL" },
  ["v"]      = { "visual", "VISUAL" },
  ["vs"]     = { "visual", "VISUAL" },
  ["V"]      = { "visual", "V-LINE" },
  ["Vs"]     = { "visual", "V-LINE" },
  ["\22"]    = { "visual", "V-BLOCK" },
  ["\22s"]   = { "visual", "V-BLOCK" },
  ["s"]      = { "visual", "SELECT" },
  ["S"]      = { "visual", "S-LINE" },
  ["\19"]    = { "visual", "S-BLOCK" },
  ["i"]      = { "insert", "INSERT" },
  ["ic"]     = { "insert", "INSERT" },
  ["ix"]     = { "insert", "INSERT" },
  ["R"]      = { "replace", "REPLACE" },
  ["Rc"]     = { "replace", "REPLACE" },
  ["Rx"]     = { "replace", "REPLACE" },
  ["Rv"]     = { "replace", "V-REPLACE" },
  ["Rvc"]    = { "replace", "V-REPLACE" },
  ["Rvx"]    = { "replace", "V-REPLACE" },
  ["c"]      = { "command", "COMMAND" },
  ["cv"]     = { "command", "EX" },
  ["ce"]     = { "command", "EX" },
  ["r"]      = { "replace", "REPLACE" },
  ["rm"]     = { "command", "MORE" },
  ["r?"]     = { "command", "CONFIRM" },
  ["!"]      = { "normal", "SHELL" },
  ["t"]      = { "terminal", "TERMINAL" },
}
function M.get_current_mode_type()
  return M.mode_map[vim.api.nvim_get_mode().mode][1]
end
function M.get_current_mode_name()
  return M.mode_map[vim.api.nvim_get_mode().mode][2]
end
function M.get_current_mode_color()
  return require("ilzayn.utils").get_colors()[M.get_current_mode_type():lower()]
end


return M
