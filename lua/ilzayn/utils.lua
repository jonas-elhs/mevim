local Utils = {}

Utils.setup = function()
  _G.Utils = Utils
end

---@param max number The maximum width to check against
Utils.width_less_than = function(max)
  return vim.o.columns <= max
end
---@param min number The minimum width to check against
Utils.width_more_than = function(min)
  return vim.o.columns > min
end

function Utils.get_colors()
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
---@param str string The string to remove the highlight groups from
Utils.remove_highlight_groups_from_string = function(str)
  return str:gsub("%%%#[a-zA-Z_]+#", "")
end
---@param highlight_group string The name of the highlight group to extend
---@param values table The highlight values to extend the group with
Utils.extend_highlight = function(highlight_group, values)
  return vim.tbl_extend("keep", values, vim.api.nvim_get_hl(0, { name = highlight_group }))
end

-- stylua: ignore
Utils.mode_map = {
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
Utils.get_current_mode_type = function()
  return Utils.mode_map[vim.api.nvim_get_mode().mode][1]
end
Utils.get_current_mode_name = function()
  return Utils.mode_map[vim.api.nvim_get_mode().mode][2]
end
Utils.get_current_mode_color = function()
  return Utils.get_colors()[Utils.get_current_mode_type():lower()]
end

return Utils
