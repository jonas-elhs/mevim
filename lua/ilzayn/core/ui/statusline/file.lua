local utils = require("ilzayn.utils")

local M = {}

M.name_overrides = {
  ["help"] = "Help",
  ["oil"] = "Oil",
  ["snacks_picker_input"] = "Snacks Picker",
}

function M.get_flags(buffer)
  buffer = buffer or 0

  return vim.bo[buffer].modified
      and ""
      or (vim.bo[buffer].modifiable == false or vim.bo[buffer].readonly == true)
        and "󰌾"
        or ""
end

function M.get_name()
  local name = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")

  local type = vim.bo.filetype
  if M.name_overrides[type] then
    name = M.name_overrides[type]
  end

  return name ~= "" and name or type
end

function M.get_icon()
  local success, icons = pcall(require, "mini.icons")

  if not success then
    return ""
  end

  return icons.get("file", M.get_name())
end

function M.get_type()
  return vim.bo.filetype
end

return function()
  local icon = M.get_icon()
  local name = M.get_name()
  local flags = M.get_flags()

  return table.concat({
    (utils.width.more_than(35) and icon ~= "")
      and table.concat({ icon, "  ", })
      or "",

    name,

    (utils.width.more_than(50) and flags ~= "")
      and table.concat({ " ", flags, })
      or "",
  })
end
