-- UTILS
local filename_overrides = {
  ["minifiles"] = "Mini Files",
  ["snacks_picker_input"] = "Snacks Picker",
  ["snacks_notif_history"] = "Snacks Notification History",
}

local function get_center_spacing(left_components, center_component)
  -- Get visible width (without highlight groups) of left componenents
  local left_width = 0
  for _, left_component in ipairs(left_components) do
    left_component = Utils.remove_highlight_groups_from_string(left_component)
    left_width = left_width + vim.api.nvim_strwidth(left_component)
  end

  -- Get visible width (without highlight groups) of center component
  center_component = Utils.remove_highlight_groups_from_string(center_component)
  local center_width = vim.api.nvim_strwidth(center_component)

  -- Get center of center component
  local center_component_center = math.floor(center_width / 2)

  -- Get center of window
  local window_width = vim.o.columns
  local window_center = math.floor(window_width / 2)

  local space_count = window_center - center_component_center - left_width

  return string.rep(" ", space_count)
end
local function highlight_module(content)
  local separator_highlight = "%#JonasCurrentModeReverse#"
  local content_highlight = "%#JonasCurrentMode#"

  return table.concat({
    separator_highlight,
    "",

    content_highlight,
    content,

    separator_highlight,
    "",

    "%#Normal#",
  })
end

-- MODULES
local function mode_module()
  local mode = Utils.get_current_mode_name()

  return table.concat({
    " ",

    Utils.width_more_than(50) and mode or mode:sub(1, 1),

    " ",
  })
end
local function git_module()
  local status = vim.b.gitsigns_status_dict

  if not status then
    return ""
  end

  local branch = vim.b.gitsigns_head
  branch = branch == "main" or branch == "master" and "" or "  " .. branch

  local added = (status.added and status.added > 0) and ("%#Added#  " .. status.added) or ""
  local changed = (status.changed and status.changed > 0) and ("%#Changed#  " .. status.changed) or ""
  local removed = (status.removed and status.removed > 0) and ("%#Removed#  " .. status.removed) or ""

  return branch .. added .. changed .. removed .. "%#Normal#"
end
local function file_module()
  local name = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
  local filetype = vim.bo.filetype
  name = filename_overrides[filetype] or name ~= "" and name or filetype ~= "" and filetype or "[No Name]"

  local icon = MiniIcons and MiniIcons.get("file", name) or ""
  local flags = vim.bo[0].modified and "" or (not vim.bo[0].modifiable or vim.bo[0].readonly) and "󰌾"

  return table.concat({
    (Utils.width_more_than(35) and icon) and icon .. "  " or "",

    name,

    (Utils.width_more_than(50) and flags) and " " .. flags or "",
  })
end
local function diagnostics_module()
  local signs = vim.diagnostic.config().signs.text or {}

  local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warn_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local info_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  local hint_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

  local error = error_count > 0
      and ("%#DiagnosticError#" .. signs[vim.diagnostic.severity.ERROR] .. " " .. error_count .. " ")
    or ""
  local warn = warn_count > 0
      and ("%#DiagnosticWarn#" .. signs[vim.diagnostic.severity.WARN] .. " " .. warn_count .. " ")
    or ""
  local info = info_count > 0
      and ("%#DiagnosticInfo#" .. signs[vim.diagnostic.severity.INFO] .. " " .. info_count .. " ")
    or ""
  local hint = hint_count > 0
      and ("%#DiagnosticHint#" .. signs[vim.diagnostic.severity.HINT] .. " " .. hint_count .. " ")
    or ""

  return error .. warn .. info .. hint .. "%#Normal#"
end
local function line_module()
  local current, total = vim.fn.line("."), vim.fn.line("$")
  local progress = current == 1 and "Top"
    or current == total and "Bottom"
    or string.format("%d%%%%", current / total * 100)

  return table.concat({
    Utils.width_more_than(50) and "  " or " ",

    Utils.width_more_than(70) and progress .. "  |  " or "",

    "%l:%c",

    Utils.width_more_than(50) and "  " or " ",
  })
end

function Statusline()
  local mode = highlight_module(mode_module())
  local git = Utils.width_more_than(120) and " " .. git_module() or ""
  local file = file_module()
  local diagnostics = Utils.width_more_than(120) and diagnostics_module() .. " " or ""
  local line = Utils.width_more_than(60) and highlight_module(line_module()) or ""

  local first_space = Utils.width_more_than(60) and get_center_spacing({ mode, git }, file) or "%="
  local second_space = Utils.width_more_than(60) and "%=" or ""

  return mode .. git .. first_space .. file .. second_space .. diagnostics .. line
end

vim.o.statusline = "%!v:lua.Statusline()"
