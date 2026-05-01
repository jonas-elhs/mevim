function _G.Tabline()
  local tabs = vim.api.nvim_list_tabpages()

  if #tabs == 1 then
    return ""
  end

  local current = vim.api.nvim_get_current_tabpage()
  local labels = {}

  for index, tab in ipairs(tabs) do
    local label = Utils.highlight_module(" " .. index .. " ", tab ~= current)

    labels[#labels + 1] = "%" .. index .. "T" .. label .. "%T"
  end

  return table.concat(labels, " ")
end

vim.o.tabline = "%!v:lua.Tabline()"
