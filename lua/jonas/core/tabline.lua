local tabline_data = {
  first_index = 1,
  last_index = 999,
  current_index = -1,
  anchor = "first",
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
  if tabline_data.current_index == tabline_data.last_index then
    vim.cmd.bprevious()
  end

  tabline_data.first_index = tabline_data.first_index - 1
  tabline_data.anchor = "first"

  vim.cmd.redrawtabline()
end
function _G.TablineArrowRightAction()
  if tabline_data.current_index == tabline_data.first_index then
    vim.cmd.bnext()
  end

  tabline_data.last_index = tabline_data.last_index + 1
  tabline_data.anchor = "last"

  vim.cmd.redrawtabline()
end

-- Utils
local function get_unique_names(bufs)
  -- Get absolute paths
  local paths = {}
  for _, buf in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then
      name = "[No Name]"
    end

    paths[buf] = vim.fn.fnamemodify(name, ":~:.")
  end

  -- Split paths
  local split_paths = {}
  for buf, path in pairs(paths) do
    local parts = vim.split(path, "/", { plain = true })
    split_paths[buf] = parts
  end

  -- Start with only filename
  local result = {}
  local depth = {}
  for bufnr, parts in pairs(split_paths) do
    depth[bufnr] = 1
    result[bufnr] = parts[#parts]
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

  -- Get current buf
  local current_buf = vim.api.nvim_get_current_buf()
  tabline_data.current_index = all_bufs_index_map[current_buf] or tabline_data.first_index

  -- Make sure 'last_index' is in bounds
  tabline_data.first_index = math.max(1, tabline_data.first_index)
  tabline_data.last_index = math.min(#all_bufs, tabline_data.last_index)

  -- Make sure current buffer is visible and adjust indices/anchor accordingly
  if tabline_data.current_index <= tabline_data.first_index then
    tabline_data.first_index = tabline_data.current_index
    tabline_data.anchor = "first"
  elseif tabline_data.current_index >= tabline_data.last_index then
    tabline_data.last_index = tabline_data.current_index
    tabline_data.anchor = "last"
  end

  -- Get visible subset of buffers
  local visible_bufs = {}
  for index = math.max(tabline_data.first_index, 1), math.min(tabline_data.last_index, #all_bufs) do
    visible_bufs[#visible_bufs + 1] = all_bufs[index]
  end

  return {
    all = all_bufs,
    names = get_unique_names(all_bufs),
    indices = all_bufs_index_map,
    visible = visible_bufs,
    current = current_buf,
  }
end
local function build_buf_label(buf, current_buf, buf_names)
  local name = buf_names[buf]
  -- local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
  -- if name == "" then
  --   name = "[No Name]"
  -- end
  local icon = MiniIcons and MiniIcons.get("file", name) or ""
  local flag = vim.bo[buf].modified and "" or (not vim.bo[buf].modifiable or vim.bo[buf].readonly) and "󰌾"

  local label =
    Utils.highlight_module(" " .. icon .. " " .. name .. " " .. (flag and flag .. " " or ""), buf ~= current_buf)
  -- spacing (2) + icon (1) + spacing (1) + name + flag spacing (1) + flag(1) + spacing (2)
  local label_len = name:len() + 6 + (flag and 2 or 0)

  return label, label_len
end

-- Sections
local function buffer_section(tabs_width)
  local max_width = vim.o.columns - tabs_width - (tabs_width ~= 0 and 20 or 0)
  local bufs = get_bufs()

  local width = 0
  local labels = {}
  for _, buf in ipairs(bufs.visible) do
    local label, label_len = build_buf_label(buf, bufs.current, bufs.names)

    width = width + label_len + 1 -- Spacing before next label

    -- If tabline is to large either stop stop appending new buffers (anchor == "first")
    -- or remove buffers from the beginning (anchor == "last")
    if width > max_width then
      if tabline_data.anchor == "first" then
        -- Last visible label is previous one
        tabline_data.last_index = bufs.indices[buf] - 1
        break
      end
      if tabline_data.anchor == "last" then
        while width > max_width do
          width = width - vim.api.nvim_eval_statusline(table.remove(labels, 1), { use_tabline = true }).width - 1
          -- First visible label is after previous one
          tabline_data.first_index = tabline_data.first_index + 1
        end
      end
    end

    -- Make labels clickable
    labels[#labels + 1] = "%" .. buf .. "@v:lua.TablineBufferAction@" .. label .. "%T"
  end

  return (tabline_data.first_index ~= 1 and left_arrow or "")
    .. table.concat(labels, " ")
    .. (tabline_data.last_index ~= #bufs.all and right_arrow or "")
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

  return buffers .. "%=" .. tabs
end

vim.o.tabline = "%!v:lua.Tabline()"
