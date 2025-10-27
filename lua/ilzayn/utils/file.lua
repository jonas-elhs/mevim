local M = {}

M.name_to_name = {
  [""] = "[No Name]",
}
M.type_to_name = {
  ["help"] = "Help",
  ["oil"] = "Oil",
}

function M.path_to_name(path)
  return vim.fn.fnamemodify(path, ":t")
end

function M.get_flags()
  return (vim.bo.buftype ~= "" and vim.bo.buftype ~= "acwrite")
    and ""
    or vim.bo.modified
      and ""
      or (vim.bo.modifiable == false or vim.bo.readonly == true)
        and "󰌾"
        or ""
end

function M.get_type()
  return vim.bo.filetype
end

function M.get_name(dontOverride)
  local name = M.path_to_name(vim.fn.expand("%"))

  if dontOverride == true then
    return name
  end

  local type = vim.bo.filetype

  if M.type_to_name[type] then
    name = M.type_to_name[type]
  elseif M.name_to_name[name] then
    name = M.name_to_name[name]
  end

  return name
end

function M.get_icon()
  local success, devicons = pcall(require, "nvim-web-devicons")

  if not success then
    return ""
  end

  return devicons.get_icon(M.get_name(true), M.get_type()) or ""
end

return M
