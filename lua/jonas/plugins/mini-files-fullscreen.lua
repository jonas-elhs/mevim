-- Full Screen mini.files
vim.api.nvim_create_user_command("MiniFilesFullscreen", function(opts)
  vim.g.minifiles_fullscreen_bottom_offset = tonumber(opts.args) or 3
  vim.g.minifiles_fullscreen = true

  MiniFiles.open()
end, { nargs = "?" })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    if not vim.g.minifiles_fullscreen then
      return
    end

    vim.keymap.set("n", "h", function()
      MiniFiles.go_out()
      MiniFiles.trim_right()
    end, { buffer = args.data.buf_id })
    vim.keymap.set("n", "l", function()
      MiniFiles.go_in({ close_on_file = true })
    end, { buffer = args.data.buf_id })
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesWindowUpdate",
  callback = function(args)
    if not vim.g.minifiles_fullscreen then
      return
    end

    local config = vim.api.nvim_win_get_config(args.data.win_id)

    config.height = vim.o.lines - vim.g.minifiles_fullscreen_bottom_offset
    config.border = { " ", " ", " ", "│", " ", " ", " ", " " }

    if config.width == MiniFiles.config.windows.width_preview then
      config.width = vim.o.columns - config.col
      config.border = { " ", " ", " ", "", " ", " ", " ", " " }
    end

    vim.api.nvim_win_set_config(args.data.win_id, config)
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesExplorerClose",
  callback = function()
    vim.g.minifiles_fullscreen = false
  end,
})
