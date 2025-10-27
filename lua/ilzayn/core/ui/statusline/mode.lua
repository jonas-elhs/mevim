local utils = require("ilzayn.utils")

return function()
  local mode = utils.mode.get_name()

  return utils.highlight.module(
    table.concat({
      " ",

      utils.width.more_than(50)
        and mode
        or mode:sub(1, 1),

      " ",
    })
  )
end
