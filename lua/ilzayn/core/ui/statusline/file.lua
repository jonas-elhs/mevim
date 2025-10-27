local utils = require("ilzayn.utils")

return function()
  local icon = utils.file.get_icon()
  local name = utils.file.get_name()
  local flags = utils.file.get_flags()
  -- local type = utils.file.get_type()

  return table.concat({
    (utils.width.more_than(35) and icon ~= "")
      and table.concat({ icon, "  ", })
      or "",

    name,

    (utils.width.more_than(50) and flags ~= "")
      and table.concat({ " ", flags, })
      or "",

    -- (utils.width.more_than(75) and type ~= "")
    --   and table.concat({ "  |  ", type, })
    --   or "",
  })
end
