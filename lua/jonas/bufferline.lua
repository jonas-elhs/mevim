local M = {}
local api = vim.api

-- Managing
function M.set_winbar(win)
  win = win or api.nvim_get_current_win()
  local buf = api.nvim_win_get_buf(win)

  if not vim.bo[buf].buflisted or vim.bo[buf].buftype ~= "" then
    return
  end

  vim.wo[win].winbar = "%{%v:lua.require'jonas.bufferline'.render(" .. win .. ")%}"
end

function M.set_win_data(win, data)
  if api.nvim_win_is_valid(win) then
    vim.w[win].jonas_bufferline_data = data
  end
end
function M.get_win_data(win)
  if api.nvim_win_is_valid(win) then
    local data = vim.w[win].jonas_bufferline_data

    if type(data) == "table" then
      return data
    end
  end

  return {
    bufs = {},
    anchor = "first",
    anchor_index = 1,
    current_index = 1,
    last_visible_index = 1,
    first_visible_index = 1,
  }
end

function M.add_buf_to_win(win, buf)
  if
    not api.nvim_win_is_valid(win)
    or not api.nvim_buf_is_valid(buf)
    or not vim.bo[buf].buflisted
    or vim.bo[buf].buftype ~= ""
  then
    return
  end

  local data = M.get_win_data(win)
  if data.bufs == {} then
    data.bufs = { buf }
    M.set_win_data(win, data)
  else
    if not vim.tbl_contains(data.bufs, buf) then
      data.bufs[#data.bufs + 1] = buf
      M.set_win_data(win, data)
    end
  end
end
function M.buf_orphaned(buf)
  for _, win in ipairs(api.nvim_list_wins()) do
    if vim.list_contains(M.get_win_data(win).bufs, buf) then
      return false
    end
  end

  return true
end
function M.remove_buf_from_win(win, buf, forceDelete, dontDelete)
  if not api.nvim_win_is_valid(win) or not api.nvim_buf_is_valid(buf) or not vim.bo[buf].buflisted then
    return
  end

  local data = M.get_win_data(win)
  data.bufs = vim.tbl_filter(function(b)
    return b ~= buf
  end, data.bufs)
  M.set_win_data(win, data)

  if not dontDelete and api.nvim_buf_is_valid(buf) and M.buf_orphaned(buf) then
    api.nvim_buf_delete(buf, { force = forceDelete or false })
  end
end

-- Click Actions
function M.buffer_click(minwid, clicks, button, mods)
  local win = math.floor(minwid / 100000)
  local buf = minwid % 100000

  if button == "m" then
    M.close_buf(false, { win = win, buf = buf })
  else
    api.nvim_set_current_win(win)
    api.nvim_set_current_buf(buf)
  end
end

function M.arrow_left_click(win)
  local data = M.get_win_data(win)

  data.anchor = "first"
  data.anchor_index = data.first_visible_index - 1
  M.set_win_data(win, data)

  if data.current_index == data.last_visible_index then
    api.nvim_win_set_buf(win, data.bufs[data.first_visible_index])
    M.render(win)
    data = M.get_win_data(win)
    api.nvim_win_set_buf(win, data.bufs[data.last_visible_index])
  end

  vim.cmd("redrawstatus!")
end
function M.arrow_right_click(win)
  local data = M.get_win_data(win)

  data.anchor = "last"
  data.anchor_index = data.last_visible_index + 1
  M.set_win_data(win, data)

  if data.current_index == data.first_visible_index then
    api.nvim_win_set_buf(win, data.bufs[data.last_visible_index])
    M.render(win)
    data = M.get_win_data(win)
    api.nvim_win_set_buf(win, data.bufs[data.first_visible_index])
  end

  vim.cmd("redrawstatus!")
end

-- Rendering
local fname_overrides = {
  [""] = "[No Name]",
  ["health://"] = "checkhealth",
}
local function get_unique_names(bufs)
  -- Get absolute paths
  local paths = {}
  for _, buf in ipairs(bufs) do
    local name = api.nvim_buf_get_name(buf)
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

local function get_bufs(win, bufferline_data)
  -- Get listed buffers
  bufferline_data.bufs = vim.tbl_filter(function(buf)
    return api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end, bufferline_data.bufs)
  local all_bufs_index_map = Utils.build_index_map(bufferline_data.bufs)

  -- Get current buf
  local current_buf = api.nvim_win_get_buf(win)
  bufferline_data.current_index = all_bufs_index_map[current_buf] or bufferline_data.anchor_index

  -- Validate and clamp indices
  bufferline_data.first_visible_index = math.max(1, bufferline_data.first_visible_index)
  bufferline_data.last_visible_index = math.min(#bufferline_data.bufs, bufferline_data.last_visible_index)

  if bufferline_data.anchor == "first" then
    bufferline_data.anchor_index = math.max(1, bufferline_data.anchor_index)
    bufferline_data.first_visible_index = bufferline_data.anchor_index
  else
    bufferline_data.anchor_index = math.min(#bufferline_data.bufs, bufferline_data.anchor_index)
    bufferline_data.last_visible_index = bufferline_data.anchor_index
  end

  -- Get buffer slice untill anchor
  local slice = {
    unpack(
      bufferline_data.bufs,
      bufferline_data.anchor == "first" and bufferline_data.anchor_index or 1,
      bufferline_data.anchor == "last" and bufferline_data.anchor_index or nil
    ),
  }

  M.set_win_data(win, bufferline_data)

  return {
    all = bufferline_data.bufs,
    bufs = slice,
    names = get_unique_names(bufferline_data.bufs),
    current = current_buf,
  }
end
local function build_buf_label(win, buf, current_buf, buf_names)
  local name = buf_names[buf]
  local icon = MiniIcons and MiniIcons.get("file", name) or ""
  local flag = vim.bo[buf].modified and "" or (not vim.bo[buf].modifiable or vim.bo[buf].readonly) and "󰌾"

  local label =
    Utils.highlight_module(" " .. icon .. " " .. name .. " " .. (flag and flag .. " " or ""), buf ~= current_buf)
  local encoded_data = win * 100000 + buf
  local clickable = "%" .. encoded_data .. "@v:lua.require'jonas.bufferline'.buffer_click@" .. label .. "%T"

  -- spacing (2) + icon (1) + spacing (1) + name + flag spacing (1) + flag(1) + spacing (2)
  local label_len = name:len() + 6 + (flag and 2 or 0)

  return clickable, label_len
end

function M.render(win)
  if not win or not api.nvim_win_is_valid(win) or vim.bo[api.nvim_win_get_buf(win)].buftype ~= "" then
    return ""
  end

  local data = M.get_win_data(win)
  local max_width = api.nvim_win_get_width(win)
  local bufs = get_bufs(win, data)
  data = M.get_win_data(win)
  local show_left_arrow = data.first_visible_index ~= 1
  local show_right_arrow = data.last_visible_index ~= #bufs.all

  -- If anchored at last buffer, first reverse buffer list and later re-reverse the labels
  if data.anchor == "last" then
    bufs.bufs = vim.iter(bufs.bufs):rev():totable()
  end

  local width = (show_left_arrow and 2 or 0) + (show_right_arrow and 2 or 0)
  local labels = {}
  for i, buf in ipairs(bufs.bufs) do
    local label, label_len = build_buf_label(win, buf, bufs.current, bufs.names)

    width = width + label_len + 1 -- Spacing before next label

    if width > max_width then
      -- Adjust anchor when moving to non-visible buffer
      local changed = false

      if data.anchor == "first" then
        if data.current_index >= data.first_visible_index + i - 1 then
          -- Moved to the right of the last visible buffer
          data.anchor = "last"
          changed = true
        elseif data.current_index < data.first_visible_index then
          -- Moved to the left of the first visible buffer
          changed = true
        end
      else
        if data.current_index <= data.last_visible_index - i + 1 then
          -- Moved to the left of the first visible buffer
          data.anchor = "first"
          changed = true
        elseif data.current_index > data.last_visible_index then
          -- Moved to the right of the last visible buffer
          changed = true
        end
      end

      if changed then
        data.anchor_index = data.current_index

        if data.anchor == "first" then
          data.first_visible_index = data.anchor_index
        else
          data.last_visible_index = data.anchor_index
        end
        M.set_win_data(win, data)

        return M.render()
      end

      break
    end

    labels[#labels + 1] = label
  end
  if data.anchor == "last" then
    labels = vim.iter(labels):rev():totable()
  end

  if data.anchor == "first" then
    data.last_visible_index = data.first_visible_index + #labels - 1
  else
    data.first_visible_index = (data.last_visible_index - #labels + 1)
  end

  M.set_win_data(win, data)

  local left_arrow = "%#JonasInactive#%" .. win .. "@v:lua.require'jonas.bufferline'.arrow_left_click@%T "
  local right_arrow = "%=%#JonasInactive#%" .. win .. "@v:lua.require'jonas.bufferline'.arrow_right_click@%T "

  return (show_left_arrow and left_arrow or "") .. table.concat(labels, " ") .. (show_right_arrow and right_arrow or "")
end

-- Actions
function M.cycle_bufs(offset, opts)
  opts = opts or {}
  local win = opts.win or api.nvim_get_current_win()
  local data = opts.data or M.get_win_data(win)

  local index = ((data.current_index - 1 + offset) % #data.bufs) + 1
  api.nvim_win_set_buf(win, data.bufs[index])

  vim.cmd("redrawstatus")
end

function M.open_buf_at(index, opts)
  opts = opts or {}
  local win = opts.win or api.nvim_get_current_win()
  local data = M.get_win_data(win)

  local buf_index = data.first_visible_index + index - 1
  if buf_index <= data.last_visible_index then
    api.nvim_win_set_buf(win, data.bufs[buf_index])
  end
end

function M.close_buf(force, opts)
  opts = opts or {}
  local win = opts.win or api.nvim_get_current_win()
  local bufs = M.get_win_data(win).bufs
  local current_index = M.get_win_data(win).current_index
  local buf = opts.buf or bufs[current_index]

  if buf == api.nvim_win_get_buf(win) then
    if #bufs > 1 then
      M.cycle_bufs(current_index == #bufs and -1 or 1, { win = win })
    else
      api.nvim_win_call(win, vim.cmd.enew)
      M.add_buf_to_win(win, api.nvim_win_get_buf(win))
      M.set_winbar(win)
    end
  end

  M.remove_buf_from_win(win, buf, force, opts.dontDelete)
end

function M.close_split(force)
  local win = api.nvim_get_current_win()
  local bufs = M.get_win_data(win).bufs

  local ok = pcall(vim.cmd, "close")
  if not ok then
    return
  end

  for _, buf in ipairs(bufs) do
    if M.buf_orphaned(buf) then
      api.nvim_buf_delete(buf, { force = force or false })
    end
  end
end

function is_normal_win(win)
  if not api.nvim_win_is_valid(win) then
    return false
  end

  local config = api.nvim_win_get_config(win)

  return (config.relative and config.relative == "" or true) and vim.bo[api.nvim_win_get_buf(win)].buftype == ""
end
function M.move_buf(dir, opts)
  opts = opts or {}
  local source_win = opts.win or api.nvim_get_current_win()
  local source_buf = opts.buf or api.nvim_win_get_buf(source_win)

  if vim.bo[source_buf].buftype ~= "" or not vim.bo[source_buf].buflisted then
    return
  end

  api.nvim_set_current_win(source_win)
  vim.cmd("wincmd " .. dir)
  local target_win = api.nvim_get_current_win()

  local create_split = source_win == target_win or not is_normal_win(target_win)
  if create_split then
    if target_win ~= source_win then
      api.nvim_set_current_win(source_win)
    end

    local cmds = {
      h = "leftabove vsplit",
      j = "rightbelow split",
      k = "leftabove split",
      l = "rightbelow vsplit",
    }

    vim.cmd(cmds[dir])
  else
    local target_buf = api.nvim_win_get_buf(target_win)
    local delete_target_buf = api.nvim_buf_is_valid(target_buf)
      and api.nvim_buf_get_name(target_buf) == ""
      and vim.bo[target_buf].buftype == ""
      and not vim.bo[target_buf].modified
      and #vim.fn.win_findbuf(target_buf) == 1
      and vim.tbl_isempty(api.nvim_buf_get_lines(target_buf, 1, -1, false))

    api.nvim_set_current_buf(source_buf)
    M.close_buf(nil, { win = source_win, buf = source_buf })

    if delete_target_buf then
      M.close_buf(nil, { buf = target_buf })
    end
  end

  vim.cmd("redrawstatus!")
end

return M
