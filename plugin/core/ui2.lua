-- based on https://www.reddit.com/r/neovim/comments/1shj1jn/routing_and_filtering_messages_via_type_and_kind/

local ui2 = require("vim._core.ui2")
local msgs = require("vim._core.ui2.messages")

-- Config ──────────────────────────────────────────────────────────
local MIN_MSG_WIDTH = 40
local MAX_MSG_WIDTH = 0.4 * vim.o.columns

local IGNORED_KINDS = {
  [""] = true,
  empty = true,
  bufwrite = true,
  search_cmd = true,
  search_count = true,
}

local SKIP_PATTERNS = {
  "%d+L, %d+B",
  "; after #%d+",
  "; before #%d+",
  "%d fewer lines",
  "%d more lines",
  "%d lines yanked",
}

local KIND_TITLES = {
  emsg = { "  Error ", "DiagnosticError" },
  echoerr = { "  Error ", "DiagnosticError" },
  lua_error = { "  Error ", "DiagnosticError" },
  rpc_error = { "  Error ", "DiagnosticError" },
  wmsg = { "  Warning ", "DiagnosticWarn" },
  echo = { "  Info ", "DiagnosticInfo" },
  echomsg = { "  Info ", "DiagnosticInfo" },
  lua_print = { "  Print ", "DiagnosticInfo" },
  search_cmd = { "  Search ", "DiagnosticInfo" },
  search_count = { "  Search ", "DiagnosticInfo" },
  undo = { "  Undo ", "DiagnosticInfo" },
  shell_out = { "  Shell ", "DiagnosticInfo" },
  shell_err = { "  Shell ", "DiagnosticError" },
  shell_cmd = { "  Shell ", "DiagnosticInfo" },
  quickfix = { "  Quickfix ", "DiagnosticInfo" },
  progress = { "  Progress ", "DiagnosticInfo" },
  typed_cmd = { "  Command ", "DiagnosticInfo" },
  list_cmd = { "  List ", "DiagnosticInfo" },
  verbose = { "  Verbose ", "Comment" },
}

-- State ────────────────────────────────────────────────────────────

local last_title = nil
local last_hl = "Normal"

-- Helpers ─────────────────────────────────────────────────────────

local function content_to_text(content)
  if type(content) ~= "table" then
    return tostring(content or "")
  end

  local parts = {}
  for _, chunk in ipairs(content) do
    if type(chunk) == "table" and chunk[2] then
      parts[#parts + 1] = chunk[2]
    end
  end

  return table.concat(parts)
end

local function should_skip(kind, content)
  if IGNORED_KINDS[kind] then
    return true
  end

  local text = content_to_text(content)
  for _, pattern in ipairs(SKIP_PATTERNS) do
    if text:find(pattern) then
      return true
    end
  end

  return false
end

local function override_msg_win()
  local win = ui2.wins and ui2.wins.msg

  if not win or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).hide then
    return
  end

  -- Clamp width
  local width = vim.api.nvim_strwidth(last_title or "")
  local lines = vim.api.nvim_buf_get_lines(ui2.bufs.msg, 0, -1, false)
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line) + 2) -- Left and right padding
  end
  width = math.max(MIN_MSG_WIDTH, math.min(MAX_MSG_WIDTH, width))

  -- Configure window
  vim.api.nvim_win_set_config(win, {
    relative = "editor",
    anchor = "NE",
    row = 1,
    col = vim.o.columns - 1,
    width = width,
    height = #lines,
    style = "minimal",
    border = "rounded",
    title = last_title or nil,
    title_pos = last_title and "center" or nil,
  })

  vim.wo[win].statuscolumn = " " -- Left padding
  vim.wo[win].winhighlight = last_title and "FloatBorder:" .. last_hl .. ",FloatTitle:" .. last_hl or ""
end

local function override_pager_win()
  local win = ui2.wins and ui2.wins.pager

  if not win or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).hide then
    return
  end

  local height = vim.api.nvim_win_get_height(win)
  vim.api.nvim_win_set_config(win, {
    border = "rounded",
    height = height,
    style = "minimal",
    title = last_title or nil,
    title_pos = last_title and "center" or nil,
  })

  vim.wo[win].winhighlight = last_title and "FloatBorder:" .. last_hl .. ",FloatTitle:" .. last_hl or ""
end

local function override_dialog_win()
  local win = ui2.wins and ui2.wins.dialog

  if not win or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).hide then
    return
  end

  local height = vim.api.nvim_win_get_height(win)
  vim.api.nvim_win_set_config(win, {
    border = "rounded",
    height = height,
    style = "minimal",
    title = last_title or nil,
    title_pos = last_title and "center" or nil,
  })

  vim.wo[win].winhighlight = last_title and "FloatBorder:" .. last_hl .. ",FloatTitle:" .. last_hl or ""

  ui2.cmd.dialog = true
end

-- Override msg and pager window
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
  orig_set_pos(tgt)

  if tgt == "msg" or tgt == nil then
    override_msg_win()
    return
  end

  if tgt == "pager" then
    override_pager_win()
  end

  if tgt == "dialog" then
    override_dialog_win()
  end
end

-- Wrap ui2 msg functions ────────────────────────────────────────────────────────────

-- Filtering and title tracking
msgs.msg_show = function(kind, content, replace_last, history, append, id, trigger)
  if should_skip(kind, content) then
    return
  end

  local title = KIND_TITLES[kind] or { "  ", "DiagnosticInfo" }
  last_title, last_hl = title[1], title[2]

  local tgt = ui2.cfg.msg.targets[kind]
    or (trigger ~= "" and ui2.cfg.msg.targets[trigger])
    or ui2.cfg.msg.targets[trigger]
    or ui2.cfg.msg.target

  msgs.show_msg(tgt, kind, content, replace_last, append, id)
  msgs.set_pos(tgt)
end

-- Reroute to pager if message is too long
local orig_show_msg = msgs.show_msg
msgs.show_msg = function(tgt, kind, content, replace_last, append, id)
  if tgt == "msg" then
    local lines = vim.split(content_to_text(content), "\n")

    local width = 0
    for _, line in ipairs(lines) do
      width = math.max(width, vim.api.nvim_strwidth(line))
    end

    if width > math.floor(vim.o.columns * 0.75) or #lines > 20 then
      vim.schedule(function()
        msgs.show_msg("pager", kind, content, replace_last, append, id)
        msgs.set_pos("pager")
      end)

      return
    end
  end

  orig_show_msg(tgt, kind, content, replace_last, append, id)
end

-- ui2 enable ──────────────────────────────────────────────────────

ui2.enable({
  enable = true,
  msg = {
    targets = {
      [""] = "msg",
      empty = "msg",
      bufwrite = "msg",
      echo = "msg",
      echomsg = "msg",
      shell_ret = "msg",
      undo = "msg",
      wmsg = "msg",
      completion = "msg",
      confirm = "dialog",
      confirm_sub = "dialog",
      echoerr = "msg",
      emsg = "msg",
      list_cmd = "pager",
      lua_error = "msg",
      lua_print = "msg",
      progress = "msg",
      quickfix = "msg",
      rpc_error = "msg",
      search_cmd = "msg",
      search_count = "msg",
      shell_cmd = "msg",
      shell_err = "msg",
      shell_out = "msg",
      typed_cmd = "msg",
      verbose = "pager",
      wildlist = "msg",
    },
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 3000 },
    pager = { height = 0.8 },
  },
})

-- ── LSP progress ─────────────────────────────────────────────────────

local id = { LspProgressMessages = vim.api.nvim_create_augroup("LspProgressMessages", { clear = true }) }

vim.api.nvim_create_autocmd("LspProgress", {
  group = id.LspProgressMessages,
  callback = function(ev)
    local value = ev.data.params.value
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    local is_end = value.kind == "end"
    local msg = value.message and (client.name .. ": " .. value.message) or (client.name .. (is_end and ": done" or ""))
    vim.api.nvim_echo({ { msg } }, false, {
      id = "lsp." .. ev.data.client_id,
      kind = "progress",
      source = "vim.lsp",
      title = value.title,
      status = is_end and "success" or "running",
      percent = value.percentage,
    })
  end,
})
