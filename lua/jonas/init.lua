vim.loader.enable()

_G.nix = require(vim.g.nix_info_plugin_name)

require("jonas.utils").setup()

require("jonas.core")
require("jonas.plugins")
