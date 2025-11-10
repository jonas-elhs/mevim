local utils = require("ilzayn.utils")

local mode_module = require("ilzayn.core.ui.statusline.mode")
local git_module = require("ilzayn.core.ui.statusline.git")
local file_module = require("ilzayn.core.ui.statusline.file")
local diagnostics_module = require("ilzayn.core.ui.statusline.diagnostics")
local line_module = require("ilzayn.core.ui.statusline.line")

local function get_center_spacing(left_components, center_component)
  local left_width = 0
  for _, left_component in ipairs(left_components) do
    left_component = utils.remove_highlight_groups_from_string(left_component)
    left_width = left_width + vim.api.nvim_strwidth(left_component)
  end

  center_component = utils.remove_highlight_groups_from_string(center_component)
  local center_width = vim.api.nvim_strwidth(center_component)

  local center_component_center = math.floor(center_width / 2)

  local window_width = vim.o.columns
  local window_center = math.floor(window_width / 2)

  local space_count = window_center - center_component_center - left_width

  return string.rep(" ", space_count)
end

local function highlight_module(content)
  local separator_highlight = "%#IlzaynModeReverse#"
  local content_highlight = "%#IlzaynMode#"

  return table.concat({
    separator_highlight, "",

    content_highlight, content,

    separator_highlight, "",

    "%#Normal#",
  })
end

function Statusline()
  local mode = highlight_module(mode_module())
  local git = utils.width_more_than(120)
    and " " .. git_module()
    or ""
  local file = file_module()
  local diagnostics = utils.width_more_than(120)
    and diagnostics_module() .. " "
    or ""
  local line = utils.width_more_than(60)
    and highlight_module(line_module())
    or ""

  local first_space = utils.width_more_than(60)
    and get_center_spacing({ mode, git }, file)
    or "%="
  local second_space = utils.width_more_than(60)
    and "%="
    or ""

  return mode .. git .. first_space .. file .. second_space .. diagnostics .. line
end

vim.o.statusline = "%!v:lua.Statusline()"
