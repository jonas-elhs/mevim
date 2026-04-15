local tabline_data = {
  anchor = "first",
  anchor_index = 1,
  current_index = -1,
  last_visible_index = 999,
  first_visible_index = 1,
}
local left_arrow = "%#JonasInactive#%@v:lua.TablineArrowLeftAction@%T "
local right_arrow = " %#JonasInactive#%@v:lua.TablineArrowRightAction@%T"

-- Click Actions
function _G.TablineBufferAction(buf, _, button, _)
  if button == "m" then
    Snacks.bufdelete(buf)
  else
    vim.cmd.buffer(buf)
  end
end
function _G.TablineArrowLeftAction()
  if tabline_data.current_index == tabline_data.last_visible_index then
    vim.cmd.bprevious()
  end

  tabline_data.anchor = "first"
  tabline_data.anchor_index = tabline_data.first_visible_index - 1

  vim.cmd.redrawtabline()
end
function _G.TablineArrowRightAction()
  if tabline_data.current_index == tabline_data.first_visible_index then
    vim.cmd.bnext()
  end

  tabline_data.anchor = "last"
  tabline_data.anchor_index = tabline_data.last_visible_index + 1

  vim.cmd.redrawtabline()
end

-- Utils
local fname_overrides = {
  [""] = "[No Name]",
  ["health://"] = "checkhealth",
}
local function get_unique_names(bufs)
  -- Get absolute paths
  local paths = {}
  for _, buf in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(buf)
    name = fname_overrides[name] or name

    paths[buf] = vim.fn.fnamemodify(name, ":~")
  end

  -- Split paths
  local split_paths = {}
  for buf, path in pairs(paths) do
    local parts = vim.split(path, "/", { plain = true, trimempty = true })
    split_paths[buf] = parts
  end

  -- Start with only filename
  local result = {}
  local depth = {}
  for buf, parts in pairs(split_paths) do
    depth[buf] = 1
    result[buf] = parts[#parts]
  end

  -- Resolve duplicates
  local changed = true
  while changed do
    changed = false

    local seen = {}

    -- Group by names
    for buf, name in pairs(result) do
      seen[name] = seen[name] or {}

      table.insert(seen[name], buf)
    end

    -- Find duplicates
    for _, grouped_bufs in pairs(seen) do
      if #grouped_bufs > 1 then
        for _, buf in ipairs(grouped_bufs) do
          local parts = split_paths[buf]

          if depth[buf] < #parts then
            depth[buf] = depth[buf] + 1

            local start = #parts - depth[buf] + 1
            result[buf] = table.concat(parts, "/", start, #parts)

            changed = true
          end
        end
      end
    end
  end

  return result
end

local function get_bufs()
  -- Get listed buffers
  local all_bufs = vim
    .iter(vim.api.nvim_list_bufs())
    :filter(function(buf)
      return vim.bo[buf].buflisted
    end)
    :totable()
  local all_bufs_index_map = Utils.build_index_map(all_bufs)

  -- Get buffer slice ending at anchor
  local slice = {
    unpack(
      all_bufs,
      tabline_data.anchor == "first" and tabline_data.anchor_index or 1,
      tabline_data.anchor == "last" and tabline_data.anchor_index or nil
    ),
  }

  -- Get current buf
  local current_buf = vim.api.nvim_get_current_buf()
  tabline_data.current_index = all_bufs_index_map[current_buf] or tabline_data.anchor_index

  -- Make sure indices are in bounds
  tabline_data.first_visible_index = math.max(1, tabline_data.first_visible_index)
  tabline_data.last_visible_index = math.min(#all_bufs, tabline_data.last_visible_index)

  if tabline_data.anchor == "first" then
    tabline_data.anchor_index = math.max(1, tabline_data.anchor_index)
    tabline_data.first_visible_index = tabline_data.anchor_index
  else
    tabline_data.anchor_index = math.min(#all_bufs, tabline_data.anchor_index)
    tabline_data.last_visible_index = tabline_data.anchor_index
  end

  return {
    all = all_bufs,
    bufs = slice,
    names = get_unique_names(all_bufs),
    current = current_buf,
  }
end
local function build_buf_label(buf, current_buf, buf_names)
  local name = buf_names[buf]
  local icon = MiniIcons and MiniIcons.get("file", name) or ""
  local flag = vim.bo[buf].modified and "" or (not vim.bo[buf].modifiable or vim.bo[buf].readonly) and "󰌾"

  local label =
    Utils.highlight_module(" " .. icon .. " " .. name .. " " .. (flag and flag .. " " or ""), buf ~= current_buf)
  local clickable = "%" .. buf .. "@v:lua.TablineBufferAction@" .. label .. "%T"

  -- spacing (2) + icon (1) + spacing (1) + name + flag spacing (1) + flag(1) + spacing (2)
  local label_len = name:len() + 6 + (flag and 2 or 0)

  return clickable, label_len
end

-- Sections
local function buffer_section(tabs_width)
  local max_width = vim.o.columns - tabs_width - (tabs_width ~= 0 and 20 or 0)
  local bufs = get_bufs()
  local show_left_arrow = tabline_data.first_visible_index ~= 1
  local show_right_arrow = tabline_data.last_visible_index ~= #bufs.all

  if tabline_data.anchor == "last" then
    bufs.bufs = vim.iter(bufs.bufs):rev():totable()
  end

  local width = (show_left_arrow and 2 or 0) + (show_right_arrow and 2 or 0)
  local labels = {}
  for i, buf in ipairs(bufs.bufs) do
    local label, label_len = build_buf_label(buf, bufs.current, bufs.names)

    width = width + label_len + 1 -- Spacing before next label

    if width > max_width then
      -- Adjust anchor when moving to non-visible buffer
      local updated = false
      if tabline_data.anchor == "first" then
        if tabline_data.current_index >= i then
          -- Jumped to other side
          tabline_data.anchor = "last"
          updated = true
        elseif tabline_data.current_index < tabline_data.anchor_index then
          -- Moved to the left of the first visible buffer
          updated = true
        end
      else
        if (#bufs.bufs - tabline_data.current_index) >= i - 1 then
          -- Jumped to other side
          tabline_data.anchor = "first"
          updated = true
        elseif tabline_data.current_index > tabline_data.anchor_index then
          -- Moved to the right of the last visible buffer
          updated = true
        end
      end

      if updated then
        tabline_data.anchor_index = tabline_data.current_index

        if tabline_data.anchor == "first" then
          tabline_data.first_visible_index = tabline_data.anchor_index
        else
          tabline_data.last_visible_index = tabline_data.anchor_index
        end

        return buffer_section(tabs_width)
      end

      break
    end

    labels[#labels + 1] = label
  end

  if tabline_data.anchor == "first" then
    tabline_data.last_visible_index = #labels
  else
    tabline_data.first_visible_index = (#bufs.bufs - #labels + 1)
  end

  if tabline_data.anchor == "last" then
    labels = vim.iter(labels):rev():totable()
  end

  return (show_left_arrow and left_arrow or "") .. table.concat(labels, " ") .. (show_right_arrow and right_arrow or "")
end

local function tab_section()
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

function _G.Tabline()
  local tabs = tab_section()
  local tabs_width = vim.api.nvim_eval_statusline(tabs, { use_tabline = true }).width
  local buffers = buffer_section(tabs_width)

  return buffers .. tabs or ""
end

vim.o.tabline = "%!v:lua.Tabline()"
