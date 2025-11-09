local utils = require("ilzayn.utils")

return function()
  local mode = utils.get_current_mode_name()

  return table.concat({
    " ",

    utils.width_more_than(50)
      and mode
      or mode:sub(1, 1),

    " ",
  })
end
