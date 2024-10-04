require("options")
require("keymaps")
require("lazy-setup")

-- Try to require `local.lua`. Note we ignore the error message, so if local
-- does exist, but just doesn't load because of an error... this will be silent.
-- I should probably fix that.
pcall(require, "local")
