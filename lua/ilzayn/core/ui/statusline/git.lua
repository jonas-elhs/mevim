return function()
  if not vim.b[0].gitsigns_head then
    return ""
  end

  local status = vim.b[0].gitsigns_status_dict

  local added = (status.added and status.added ~= 0) and ("  " .. status.added) or ""
  local changed = (status.changed and status.changed ~= 0) and ("  " .. status.changed) or ""
  local removed = (status.removed and status.removed ~= 0) and ("  " .. status.removed) or ""
  local branch = " " .. vim.b[0].gitsigns_head

  return branch .. added .. changed .. removed .. "%#Normal#"
end
