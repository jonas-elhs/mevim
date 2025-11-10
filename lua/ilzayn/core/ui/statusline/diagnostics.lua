local severity = vim.diagnostic.severity

return function()
  local signs = vim.diagnostic.config().signs.text or {}

  local error_count = #vim.diagnostic.get(0, { severity = severity.ERROR })
  local warn_count = #vim.diagnostic.get(0, { severity = severity.WARN })
  local info_count = #vim.diagnostic.get(0, { severity = severity.INFO })
  local hint_count = #vim.diagnostic.get(0, { severity = severity.HINT })

  local error = error_count > 0
    and ("%#DiagnosticError#" .. signs[severity.ERROR] .. " " .. error_count .. " ")
    or ""
  local warn = warn_count > 0
    and ("%#DiagnosticWarn#" .. signs[severity.WARN] .. " " .. warn_count .. " ")
    or ""
  local info = info_count > 0
    and ("%#DiagnosticInfo#" .. signs[severity.INFO] .. " " .. info_count .. " ")
    or ""
  local hint = hint_count > 0
    and ("%#DiagnosticHint#" .. signs[severity.HINT] .. " " .. hint_count)
    or ""

  return error .. warn .. info .. hint .. "%#Normal#"
end
