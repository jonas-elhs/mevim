function Tabline()
  local tab_numbers = vim.api.nvim_list_tabpages()
  local current = vim.api.nvim_get_current_tabpage()
  local tabs = {}

  for index, tab_number in ipairs(tab_numbers) do
    local label = Utils.highlight_module(" " .. index .. " ", tab_number ~= current)

    tabs[#tabs + 1] = "%" .. index .. "T" .. label .. "%T"
  end

  return table.concat(tabs, " ")
end

vim.o.tabline = "%!v:lua.Tabline()"
